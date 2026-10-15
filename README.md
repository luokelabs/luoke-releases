# luoke-releases — 螺壳的发布

螺壳（luoke）是一组在你自己的 Mac 上跑本地模型的应用：螺壳主控（管模型和引擎的菜单栏程序，也是安装器）、螺壳邮件助手、螺壳输入法、螺壳记忆。这个仓库放它们的发布版本（Releases）和再分发所需的许可文件。

- **现状**：封闭测试准备中。测试版作为不公开列出的预发布版发给测试者；公开发布前这里不放安装包。
- **系统要求**：Apple 芯片的 Mac，macOS 26.2 以上，内存 16 GB 起（推荐 32 GB 以上），磁盘约 7 GB（16 / 32 GB 内存）或 28 GB（64 GB 以上）。
- **模型**放在 ModelScope（组织 `luokelabs`）；主控首次运行时按发布清单下载并逐文件核对哈希。

## 这里的东西

| 路径 | 内容 |
|---|---|
| Releases | 每个发布：各应用的安装器 DMG（`安装邮件助手.dmg` 等，同一个签名公证过的主控）、引擎包 zip、发布清单 `release.json`、发布说明 |
| `licenses/engine/` | 引擎包（[oMLX](https://github.com/jundot/omlx) 的副本，重签名、代码未改）的 Apache-2.0 许可和它自带的 Python 包清单（名字、版本、许可） |
| `licenses/python-runtime/` | 应用自带的 Python 运行时（python-build-standalone）各组件的许可 |
| `licenses/models/` | 模型的许可（三个模型都是 Apache-2.0）和来源 |

## 许可与署名

- 螺壳各应用的代码由 **螺壳实验室 Luoke Labs** 开发，公开发布时开源（许可见各代码仓库）。
- 引擎包里的 oMLX 按 Apache License 2.0 再分发（`licenses/engine/LICENSE-oMLX.txt`），版本和"代码未改"写在每次的发布说明里。引擎包自带的 Python 包各按自己的许可（`licenses/engine/THIRD-PARTY-PACKAGES.txt`），其中 GPL / LGPL 的几个（mlx_embeddings、phonemizer_fork、espeakng_loader、num2words、pycountry、soxr）未做改动，源码包见各发布的附件或 PyPI。
- 模型：Qwen3.5-9B、Qwen3.5-0.8B-Base（Apache-2.0，Alibaba Qwen）和 Gemma 4 26B（Apache-2.0，Google；另有 Google 的[禁止用途政策](https://ai.google.dev/gemma/prohibited_use_policy)）。实验室量化的版本在模型卡里写明上游、许可和量化方式。详见 `licenses/models/README.md`。

## 反馈

封闭测试期间的反馈渠道在给测试者的说明里；公开后在这里开 Issues。
