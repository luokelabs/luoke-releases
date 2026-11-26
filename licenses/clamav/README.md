# ClamAV 的源码

螺壳扫描（luoke-scan）带着 [ClamAV](https://www.clamav.net/)（GPLv2）的程序和库，从 Homebrew 装好的版本原样拷进去。每个 ClamAV 版本第一次随 beta 发布时，那一版附上完整的上游源码包、那次构建用的 Homebrew 配方和配方编译前打的每个上游补丁（配方里写着它们的 sha256）。之后带同一个 ClamAV 的版本在发布说明里链回这里列的那一版。

| ClamAV（Homebrew 版本） | 附在哪一版 | 源码包 | 配方 | 补丁 |
|---|---|---|---|---|
| 1.5.4_2 | [beta2](https://github.com/luokelabs/luoke-releases/releases/tag/beta2) | [clamav-1.5.4.tar.gz](https://github.com/luokelabs/luoke-releases/releases/download/beta2/clamav-1.5.4.tar.gz) | [clamav-1.5.4_2.rb](https://github.com/luokelabs/luoke-releases/releases/download/beta2/clamav-1.5.4_2.rb) | [clamav-1.5.4_2-patch1-0097a6f99d9f.patch](https://github.com/luokelabs/luoke-releases/releases/download/beta2/clamav-1.5.4_2-patch1-0097a6f99d9f.patch)<br>[clamav-1.5.4_2-patch2-729eaef96263.patch](https://github.com/luokelabs/luoke-releases/releases/download/beta2/clamav-1.5.4_2-patch2-729eaef96263.patch)<br>[clamav-1.5.4_2-patch3-c905f7e2fbe6.patch](https://github.com/luokelabs/luoke-releases/releases/download/beta2/clamav-1.5.4_2-patch3-c905f7e2fbe6.patch)<br>[clamav-1.5.4_2-patch4-b823aef0635f.patch](https://github.com/luokelabs/luoke-releases/releases/download/beta2/clamav-1.5.4_2-patch4-b823aef0635f.patch) |

这些发布不会删：附着源码的版本至少保留到最后一次分发这个 ClamAV 版本之后三年。

这个文件由出版流水线在发 beta 时更新（luoke-core 的 `tools/clamav_source.py`），请不要手改。
