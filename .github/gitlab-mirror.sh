#!/usr/bin/env bash
# 把 luoke-releases 的一个发布同步到 gitlab.com/luokelabs/luoke-releases：
# 推 main 和这个 tag，把发布里的文件传到 GitLab 的软件包库，再建同名发布、挂上这些文件。
# 由 .github/workflows/gitlab-mirror.yml 在发布时调用；也能在仓库根目录手动跑：
#   TAG=beta1 GITLAB_TOKEN=... .github/gitlab-mirror.sh
# GITLAB_TOKEN 是 GitLab 个人令牌（权限 api）；gh 要能读这个仓库（已登录或有 GH_TOKEN）。
# 令牌只放在临时文件和环境变量里，不上命令行（命令行别的用户用 ps 就能看到）。
# 重跑没关系：GitLab 上已有、内容相同的文件跳过不传，发布删掉重建。
set -euo pipefail
shopt -s nullglob
: "${TAG:?要指定 TAG}" "${GITLAB_TOKEN:?要指定 GITLAB_TOKEN}"

GH_REPO=${GH_REPO:-luokelabs/luoke-releases}
GL_REPO=luokelabs/luoke-releases
API=https://gitlab.com/api/v4/projects/${GL_REPO//\//%2F}
PKG=$API/packages/generic/luoke-releases/$TAG

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir "$work/files"
(umask 077; printf 'PRIVATE-TOKEN: %s\n' "$GITLAB_TOKEN" > "$work/auth")
AUTH=(-H "@$work/auth")

# 1. 代码：main 和这个 tag，以 GitHub 为准（强推）。tag 先推上去，GitLab 上才能建这个发布
git fetch --quiet origin main "+refs/tags/$TAG:refs/tags/$TAG"
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.https://gitlab.com/.extraheader \
  GIT_CONFIG_VALUE_0="Authorization: Basic $(printf 'oauth2:%s' "$GITLAB_TOKEN" | base64 | tr -d '\n')" \
  git push "https://gitlab.com/$GL_REPO.git" "+refs/remotes/origin/main:refs/heads/main" "+refs/tags/$TAG:refs/tags/$TAG"

# 2. 发布文件：从 GitHub 下载，逐个传到 GitLab 软件包库
gh release view "$TAG" -R "$GH_REPO" --json name,body,publishedAt > "$work/release.json"
gh release download "$TAG" -R "$GH_REPO" -D "$work/files"
pkg_id=$(curl -sS --fail-with-body "${AUTH[@]}" "$API/packages?package_type=generic&package_name=luoke-releases&package_version=$TAG" |
  jq -r --arg v "$TAG" '[.[] | select(.name == "luoke-releases" and .version == $v)][0].id // empty')
have='[]'
if [[ -n $pkg_id ]]; then
  have=$(curl -sS --fail-with-body "${AUTH[@]}" "$API/packages/$pkg_id/package_files?per_page=100" | jq -c '[.[] | {file_name, file_sha256}]')
fi
links='[]'
for f in "$work"/files/*; do
  n=$(basename "$f")
  sha=$(shasum -a 256 "$f" | cut -d' ' -f1)
  if jq -e --arg n "$n" --arg s "$sha" 'any(.[]; .file_name == $n and .file_sha256 == $s)' <<< "$have" > /dev/null; then
    echo "已在 GitLab 上，跳过 $n"
  else
    echo "上传 $n（$(du -h "$f" | cut -f1)）"
    curl -sS --fail-with-body --http1.1 "${AUTH[@]}" --upload-file "$f" "$PKG/$n" > /dev/null
  fi
  links=$(jq -c --arg n "$n" --arg u "$PKG/$n" \
    '. + [{name: $n, url: $u, direct_asset_path: ("/" + $n), link_type: (if ($n | test("\\.(dmg|zip)$")) then "package" else "other" end)}]' <<< "$links")
done

# 3. 发布：标题、说明和发布时间照搬 GitHub。重跑时先删掉 GitLab 上已有的同名发布（tag 保留）再建
# 发布时间一定要照抄：GitLab 按它定哪个是最新（permalink/latest、发布列表的顺序，螺壳 GitHub 不通时查更新也看它），
# 不给就记成同步那一刻，补跑一个旧版本它就成了「最新」
if [[ $(curl -sS -o /dev/null -w '%{http_code}' "${AUTH[@]}" "$API/releases/$TAG") == 200 ]]; then
  curl -sS --fail-with-body -X DELETE "${AUTH[@]}" "$API/releases/$TAG" > /dev/null
fi
jq -n --arg tag "$TAG" --argjson links "$links" --slurpfile r "$work/release.json" \
  '{tag_name: $tag, name: $r[0].name, description: $r[0].body, released_at: $r[0].publishedAt, assets: {links: $links}}' |
  curl -sS --fail-with-body "${AUTH[@]}" -H 'Content-Type: application/json' --data @- "$API/releases" > /dev/null
echo "已同步：https://gitlab.com/$GL_REPO/-/releases/$TAG"
