# 20260726-Profile-个人库封面（自有 media + API）

## 背景

个人主页游戏卡片需要封面图。**资源必须落在 Profile HAR 内**，经本模块 API / 工具解析使用；不得把 entry 或其他模块 media 当作公共资源直接 `$r`。

## 原则（纠正）

| 要 | 不要 |
|----|------|
| `cp` 到 `Profile/src/main/resources/base/media/` | 直接 `$r('app.media.wukong')` 等他模块文件名 |
| 文件名 `profile_*` 前缀 | 与 entry / Gamelibrary 同名抢资源 |
| mock 存 `coverKey`，API 填 `coverImg` | 页面/mock 硬编码他人资源路径 |
| `ProfileMedia` / `MediaApi` 统一解析 | 业务侧散落 `$r` |

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Profile/.../resources/base/media/profile_*.png` | **拷贝**自游戏库素材，改名归 Profile |
| `Profile/.../model/utils/ProfileMedia.ets` | `resolveProfileCover` / `profileBackground` |
| `Profile/.../api/MediaApi.ets` | `getProfileCoverSync` 等 |
| `Profile/.../model/types/LibraryModel.ets` | `coverKey` + `coverImg` |
| `Profile/.../model/mock/LibraryMock.ets` | 仅 `coverKey` |
| `Profile/.../api/LibraryApi.ets` | `copyGame` 时解析封面 |
| `Profile/.../model/mock/GameCatalogMock.ets` | 详情目录走 `resolveProfileCover` |
| `Profile/.../model/mock/GameDetailExtraMock.ets` | 默认底图本模块 |
| `Profile/.../pages/GameLibrarySection.ets` | 有 `coverImg` 显示 Image |
| `Profile/.../pages/ProfileGameDetailPage.ets` | alt 本模块底图 |

## 数据流

```
LibraryMock.coverKey
    → LibraryApi.copyGame → MediaApi.getProfileCoverSync
    → LibraryGame.coverImg
    → GameLibrarySection.CoverBuilder Image
```

详情：`GameCatalogMock` 内 `coverImg: resolveProfileCover(key)`，社区帖缺图时用 `profileBackground()`。

## 验证方式

1. 「我」→ 数据 → 游戏库：卡片为 Profile media 封面  
2. 点进详情头图正常  
3. `rg "app.media." Profile` 仅剩 `profile_*` 与 `ProfileMedia` 内映射  

## 已知限制

- 部分游戏无专属图，用气质接近的 profile 拷贝图占位  
- 后续换图只改 `Profile/media` + `ProfileMedia` 映射  
