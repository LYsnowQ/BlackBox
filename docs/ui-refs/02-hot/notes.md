# 热点 UI 参考截图清单

源文件（仓库内）：`entry/src/main/ets/pages/Hot/Screen/`

## 浅色（产品默认）`Screen/Light/`

| 文件 | 说明 | 实现落点 |
|------|------|----------|
| 图1.jpg | 全部-Banner + 新闻列表 | `Hot.ets` AllFeed + `HOT_THEME_LIGHT` |
| 图2.jpg | 热榜（彩色序号 1–4） | `Hot.ets` RankList |
| 图3.jpg | 详情-正文 | `HotNewsDetail.ets` 正文 Tab |
| 图4.jpg | 详情-评论 | `HotNewsDetail.ets` 评论 Tab |

## 深色（调试保留）`Screen/` 根目录

| 文件 | 说明 | 实现落点 |
|------|------|----------|
| 图1.png / 图2.png | 全部列表 | `HOT_THEME_DARK` |
| 图3.png | 详情正文 Steam | mock `news-steam-sale` |
| 图4.png | 详情评论 | 评论 Tab |
| 图5.png | 详情正文 剑星 MOD | mock `news-stellar-mod` |
| 图6.png | 热榜 | RankList 深色态 |

主题：默认 **light**（`HOT_DEFAULT_THEME_MODE`）。  
未提供：剑星 / Steam 等独立频道 Feed → 待开发页。
