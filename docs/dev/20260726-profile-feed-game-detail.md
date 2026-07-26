# 20260726-Profile-动态详情与个人库游戏详情

## 背景

个人页「动态」卡片与「游戏库」信息卡需要可点进详情。为避免与 Home / Gamelibrary 模块联动带来的 id 对齐与 Git 冲突，**在 Profile HAR 内自包含实现**两套详情页与 mock，不 import 其他业务 HAR。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Profile/.../router/ProfileRoutes.ets` | 新增 `FEED_DETAIL` / `GAME_DETAIL` |
| `Profile/.../model/types/FeedModel.ets` | 扩展 `FeedDetail` / `FeedComment` |
| `Profile/.../model/mock/FeedMock.ets` | 详情 mock（id 与列表一致） |
| `Profile/.../api/FeedApi.ets` | `fetchFeedDetail` / `getFeedDetailSync` |
| `Profile/.../api/LibraryApi.ets` | `fetchLibraryGameById` / `getLibraryGameByIdSync` |
| `Profile/.../pages/FeedDetailPage.ets` | 动态详情 UI |
| `Profile/.../pages/ProfileGameDetailPage.ets` | 个人库游戏详情 UI |
| `Profile/.../pages/DynamicTab.ets` | 卡片点击跳转 |
| `Profile/.../pages/GameLibrarySection.ets` | 游戏卡点击跳转 |
| `Profile/Index.ets` | 导出新页面与 API |
| `entry/.../pages/Profile/FeedDetail.ets` | @Entry 壳 |
| `entry/.../pages/Profile/GameDetail.ets` | @Entry 壳 |
| `entry/.../router/AppRoutes.ets` | 镜像路径 |
| `entry/.../profile/main_pages.json` | **末尾追加**两条 path |
| `docs/ROUTE_CONTRACT.md` | 契约表 |

## 实现说明

- 路由：
  - 动态：`ProfileRoutes.FEED_DETAIL` → `pages/Profile/FeedDetail`，`params.id`
  - 游戏：`ProfileRoutes.GAME_DETAIL` → `pages/Profile/GameDetail`，`params.id`（`lg1`…）
- **不**使用 `pages/GameDetail/GameDetail`（gamelibrary 包）与 `pages/Home/PostDetail`；代码为 **复制** 进 Profile
- 游戏详情：整页复制 `Gamelibrary` 的 `GameDetail` + `GameLibraryModel` + `GameDetailModel`
  - 展示评分 / 介绍 / 价格 / 社区 / 统计（商城向），**不是**个人时长成就页
  - `resolveProfileLibraryToGameId(lg*)` 映射到详情 slug；缺的游戏在 Profile 内补 stub
- 动态详情：正文 + 评论列表 + 点赞/发评（本地 mock 状态）

## 验证方式

1. 「我」→ 动态 → 点任意卡片 → 进入动态详情，返回正常  
2. 「我」→ 数据 → 游戏库分区 → 点心愿单/拥有等卡片 → 进入个人库游戏详情，id 与卡片一致  
3. 与游戏库 Tab 内详情互不影响（路径不同）  
4. `main_pages.json` 仅追加，未重排/删除他人 path  

## 已知限制 / 后续

- 游戏封面仍为渐变占位，未接真实 media  
- 详情页购买/预约为展示态，无真实下单  
- 若未来要与游戏库统一，可再做 id 映射层；当前刻意隔离  
