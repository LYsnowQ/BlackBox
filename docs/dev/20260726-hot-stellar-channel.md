# 20260726-hot-stellar-channel

## 背景

完善热点 Tab **剑星** 频道主页面展示，对照 `D:\Project\Image\剑星\主页面条目`：

- 结构截图：顶部游戏卡（封面 + 剑星 > + 存档解析 / 纳米服图鉴 / 怪物图鉴）+ 列表
- 仅展示 **6 个条目**，右侧缩略图用给定 `条目N缩略图`
- 点击进入详情：沿用现有 `HotNewsDetail`，**仅正文 / 评论 Tab**；除已有「白色蓬蓬裙」完整 mock 外，其余条目正文与评论用占位说明

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_stellar_1~6_thumb.*` | 条目1–6 列表缩略图 |
| `Hot/src/main/ets/model/HotModel.ets` | `HotStellarHeader`、`hotStellarHeader`、`hotStellarList`、`getStellarFeed`、详情查找兼容 |
| `Hot/src/main/ets/pages/Hot/Hot.ets` | 剑星频道 UI：顶卡 + 6 条列表 |
| `docs/dev/20260726-hot-stellar-channel.md` | 本文档 |
| `docs/dev/README.md` / `20260724-hot-progress-summary.md` | 索引与进度汇总 |

## 实现说明

### 列表 6 条（标题 / 副文 / 评论数对照条目图）

| # | id | 标题摘要 | 缩略图资源 |
|---|-----|----------|------------|
| 1 | `stellar-jk-mod` | 剑星JK有领连衣裙伊芙 mods… | `hot_stellar_1_thumb` |
| 2 | `news-stellar-mod` | 剑星可爱白色蓬蓬裙…（复用新闻2 完整详情） | `hot_stellar_2_thumb` |
| 3 | `stellar-eve-ninja` | 剑星EVE（真人快打紫色忍者装）… | `hot_stellar_3_thumb` |
| 4 | `stellar-eve-look` | 伊芙:我看看盒友都发了啥 | `hot_stellar_4_thumb` |
| 5 | `stellar-ns2-esrb` | NS2版《剑星》在ESRB上获17+… | `hot_stellar_5_thumb` |
| 6 | `stellar-ns2-release` | NS2版剑星过审17+无删减… | `hot_stellar_6_thumb` |

- 列表副文 `timeLabel·tag` 中 `tag` 使用作者昵称（与截图一致）
- 顶部卡封面复用 `hot_news2_game`（剑星封面已有资源）
- 条目 2 的 `id` 与「全部」feed 中蓬蓬裙新闻相同 → 点进为完整正文/评论；其余走 `buildPlaceholderDetail` 占位

### UI

- `channel.id === 'stellar'` 时渲染 `StellarFeedBuilder`，不再走通用「待开发」占位
- Steam / 战术小队 / 绝地求生 仍为占位

## 验证方式

1. DevEco 同步资源后编译运行
2. 热点 → 点 **剑星** Tab
3. 应见顶部深色游戏卡 + 恰好 6 条列表，右侧为真实缩略图
4. 点第 2 条：完整蓬蓬裙正文与评论
5. 点其余条目：详情顶栏「正文 / 评论」可切换；正文为占位说明 + 缩略图，评论为占位评论

## 已知限制 / 后续

- 未做「存档解析 / 纳米服图鉴 / 怪物图鉴」跳转
- 条目 1/3/4/5/6 无完整正文截图，仅占位
- 结构图中另有视频类条目（doro / 废土金刚）本批按「只展示 6 个给定条目」未纳入
- 顶部卡封面未单独提供时继续用 `hot_news2_game`
