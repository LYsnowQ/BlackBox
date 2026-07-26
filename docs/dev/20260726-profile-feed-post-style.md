# 20260726-Profile-动态帖子风格对齐首页

## 背景

个人页「动态」列表与详情原先为简版卡片（灰底圆角卡 + 灰块封面），与首页 `PostCard` / `PostDetail` 气质不一致。需以首页为基准统一格式，且 **对照实现 / 自有 media**，禁止 import home 或直接引用他人资源名。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Profile/.../model/types/FeedModel.ets` | 扩展作者行、图片、详情段落/圈子/话题等 |
| `Profile/.../model/mock/FeedMock.ets` | mock 对齐帖子结构；`mediaKey` 仅 Profile 键 |
| `Profile/.../api/FeedApi.ets` | 拷贝字段补全 |
| `Profile/.../pages/DynamicTab.ets` | 列表：作者头像行 + 右图/宫格 + 底栏赞评 |
| `Profile/.../pages/FeedDetailPage.ets` | 详情：正文/评论顶栏、分段正文、底栏赞藏充评 |
| `docs/dev/20260726-profile-feed-post-style.md` | 本文 |

## 实现说明

- **对照不引用**：版式照抄 Home 节奏，代码与资源全在 Profile
- **配图**：`FeedImage.mediaKey` → `MediaApi.getProfileCoverSync` → `profile_*`
- **列表**：白底 + 分割线流（对齐推荐流），不再用灰底圆角卡叠 margin
- **详情**：List 连续滚动正文/评论；底栏四操作 mock 本地状态

## 验证方式

1. 「我」→ 动态：卡片有头像/等级/配图布局，与首页帖子气质接近  
2. 点进详情：顶栏「正文/评论」、头图、底栏可赞/藏/充/评  
3. 无 `import` home；无他人 media 裸名  

## 已知限制

- 评论回复楼中楼未做（首页有，Profile 先单层）  
- 部分动态图为气质占位，非原作截图  
