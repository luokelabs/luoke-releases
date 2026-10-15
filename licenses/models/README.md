# 模型的许可与来源

螺壳主控按发布清单下载这些模型（ModelScope 组织 `luokelabs` 下的镜像或实验室自己量化的版本）。三个模型的上游都是 Apache License 2.0（全文见 `LICENSE-Apache-2.0.txt`）；量化属于"修改"，按 Apache §4 在模型卡里标明来源、改动（量化方式）并保留上游的许可和 NOTICE。

| 模型 | 用途 | 上游 | 许可 |
|---|---|---|---|
| Qwen3.5-9B（4 bit） | 16 / 32 GB 档的底座 | Alibaba Qwen，社区 4 bit 量化 | Apache-2.0 |
| Qwen3.5-0.8B-Base（4 bit） | 输入法的打分模型 | Alibaba Qwen，实验室量化 | Apache-2.0 |
| Gemma 4 26B-A4B（8 bit） | 128 GB 档的底座 | Google，社区 8 bit 量化 | Apache-2.0；Google 另有[禁止用途政策](https://ai.google.dev/gemma/prohibited_use_policy)和[使用条款](https://ai.google.dev/gemma/terms) |
