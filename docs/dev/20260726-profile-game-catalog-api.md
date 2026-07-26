# 20260726-Profile-商城游戏详情 API 统一

## 背景

Profile 内复制的游戏库详情页原先直接 import `GameLibraryModel` / `GameDetailModel`，与模块「页面只走 api + types」约定不一致。需在 **仅 Profile 模块内** 完成 API 分层，不与 gamelibrary 包联动。

## 目录

```
Profile/src/main/ets/
├── api/GameCatalogApi.ets          # 商城详情 API（ApiResult）
├── model/types/GameCatalogModel.ets # GameItem / CommunityPost 等类型
├── model/mock/GameCatalogMock.ets   # gameList + id 映射 + getGameById
├── model/mock/GameDetailExtraMock.ets # 社区 / 数据库 / 区价 mock
└── pages/ProfileGameDetailPage.ets # 只依赖 api + types
```

## API

| 方法 | 约定路径 | 说明 |
|------|----------|------|
| `resolveLibraryToCatalogId` | — | `lg*` → 详情 slug |
| `fetchCatalogGameById` | GET `/api/v1/profile/catalog/games/{id}` | 按详情 id |
| `fetchCatalogGameForLibraryId` | GET `.../catalog/games?libraryId=` | 个人库入口（含回退） |
| `fetchGameCommunityPosts` | GET `.../games/{id}/community` | 社区帖 |
| `fetchGameDatabaseItems` | GET `.../games/{id}/database` | 数据库 |
| `fetchGameRegionPrices` | GET `.../games/{id}/region-prices` | 区价 |

同步便捷：`getCatalogGameForLibraryIdSync` / `getGameCommunityPostsSync` 等。

## 约定

1. 页面 **禁止** 直接 import `model/mock/GameCatalog*`  
2. 类型从 `model/types/GameCatalogModel` 取  
3. 接真实网络时只改 `GameCatalogApi`  
4. 与 `LibraryApi`（个人库时长/成就列表）职责分离：列表仍用 `LibraryGame`，详情用 `GameItem`

## 验证

1. 个人页游戏卡 → 详情：评分/介绍/社区正常  
2. 动态详情仍走 `FeedApi`  
3. 编译无「页面直引 mock」路径  
