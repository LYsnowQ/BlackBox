# 20260726-hot-rank-thumbs-2-7

## 背景

热榜第 1 条已用 `hot_rank1_img1` 作列表缩略图；第 2–10 条此前仍为渐变 + `thumbLabel` 占位。  
现将 `D:\Project\Image\热榜缩略图\` 提供的 **热榜2–7 缩略图** 接入列表右侧真图。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_rank2_thumb.jpg` | 热榜2 缩略图 |
| `Hot/src/main/resources/base/media/hot_rank3_thumb.jpg` | 热榜3 缩略图 |
| `Hot/src/main/resources/base/media/hot_rank4_thumb.jpg` | 热榜4 缩略图 |
| `Hot/src/main/resources/base/media/hot_rank5_thumb.png` | 热榜5 缩略图 |
| `Hot/src/main/resources/base/media/hot_rank6_thumb.jpg` | 热榜6 缩略图 |
| `Hot/src/main/resources/base/media/hot_rank7_thumb.jpg` | 热榜7 缩略图 |
| `Hot/src/main/ets/model/HotModel.ets` | `hotRankList` rank-2~7 增加 `coverImg` |

源目录：`D:\Project\Image\热榜缩略图\`。

## 实现说明

- `HotRankItem.coverImg` / `RankItemBuilder` 此前已支持真图，本次只补数据绑定。
- 命名：`热榜N缩略图` → `hot_rankN_thumb`（与新闻列表 `hot_newsN_thumb` 一致）。
- 第 1 条仍用 `hot_rank1_img1`（详情配图复用，未单独提供 rank1 缩略图文件）。
- 第 8–10 条：素材未提供，继续渐变占位。

## 验证方式

1. 编译：`app.media.hot_rank2_thumb` … `hot_rank7_thumb` 可解析  
2. 热点 → **热榜**：第 2–7 条右侧为真图；第 1 条仍为显卡图；第 8–10 仍为渐变  

## 已知限制 / 后续

- 热榜 8–10 缩略图待素材  
- 热榜 2–10 详情正文大多仍为占位（仅 rank1 有完整详情）  
