# 20260726-Profile-个人库游戏封面图

## 背景

个人主页游戏库卡片原先仅用 `coverColors` 渐变占位。entry / 游戏库模块已有同批 media 资源，可直接复用 `$r('app.media.*')` 展示封面，无需再拷贝文件（HAR 运行时解析到 entry 的 `app.media`）。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Profile/.../model/types/LibraryModel.ets` | `LibraryGame` 增加可选 `coverImg` |
| `Profile/.../model/mock/LibraryMock.ets` | 为 lg1–lg16 绑定封面 |
| `Profile/.../pages/GameLibrarySection.ets` | `CoverBuilder` 有图用 Image，无图回落渐变 |
| `Profile/.../model/mock/GameCatalogMock.ets` | 补充条目补 `coverImg`，详情页一致 |

## 实现说明

- **不新增 media 文件**：复用 `entry/src/main/resources/base/media/` 已有 png
- 有对应原作图的优先（悟空 / 帕鲁 / 法环 / 2077 / 只狼 / 生化4 等）
- 无专属图的用气质接近的现有图占位（如 Hades II → storm）
- 详情目录 stub 与列表封面保持同一资源，避免列表与详情不一致

## 验证方式

1. 「我」→ 数据 → 游戏库分区：卡片左侧为真实封面，非纯色首字  
2. 切换心愿单 / 拥有等 Tab，封面仍正常  
3. 点击卡片进详情，头图有封面  

## 已知限制 / 后续

- 部分游戏无专属素材，仅为占位映射  
- 若后续补专用封面，只改 mock 的 `$r` 即可  
