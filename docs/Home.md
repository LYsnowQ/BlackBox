# 首页开发文档（`home` 分支）

职责：首页 **关注 + 推荐**（社区内容流）。业务在 **Home HAR**（包名 `home`），entry 只挂载壳。

对照设计：`design/Home/`，见 `design/README.md`。路由契约见 `docs/ROUTE_CONTRACT.md`。

## 进度总览

| 模块 | 状态 | 说明 |
|---|---|---|
| 首页壳（顶栏 关注/推荐） | 已完成 | `Home/src/main/ets/pages/Home.ets`，Index 从 `home` 包挂载 |
| 推荐 Tab | 已完成 | `HomeRecommend.ets` |
| 关注 Tab | 已完成 | `FollowFeed.ets` |
| 关注用户筛选 | 进行中 | 仅选中高亮，未过滤 |
| 帖子详情 + 评论连续滚动 | 已完成 | `PostDetailPage` + entry 壳 `pages/Home/PostDetail` |
| 底栏赞/藏/充/评 | 已完成 | mock 本地状态 |
| 模块化迁移 | 已完成 | 业务进 Home HAR，entry 仅壳 |

## 目录与关键文件

```
Home/                              # HAR 包名 home
├── Index.ets                      # 导出 Home / PostDetailPage / HomeRoutes
└── src/main/ets/
    ├── model/HomeModel.ets
    ├── pages/                     # Home, HomeRecommend, FollowFeed, PostCard, PostDetailPage
    └── router/HomeRoutes.ets

entry/src/main/ets/
├── pages/Index.ets                # import { Home } from 'home'
├── pages/Home/PostDetail.ets      # @Entry 壳 → PostDetailPage
└── router/AppRoutes.ets
```

## 变更记录

> 每完成一小部分功能，在此追加一条（新在上）。

- 2026-07-24 · 合并 origin/LYsnowQ + 首页迁入 Home HAR · `Home/**` `entry` 壳与依赖 · commit:待提交
- 2026-07-24 · 详情底栏赞藏充评论交互 + 正文评论连续滚动 · `PostDetail` · commit:789675b
- 2026-07-24 · 修复 PostDetail 与基类 tabIndex 命名冲突 · commit:9551075
- 2026-07-24 · 帖子详情正文/评论 + 列表跳转 · commit:88fa36e
- 2026-07-24 · 首页关注/推荐可切换流 · commit:9e34403
- 2026-07-24 · 协作约束 + 设计图 + 开发文档骨架 · commit:3537d5b

## 已知问题 / 待办

- 圈子 / 关注用户筛选未真正过滤
- 搜索、消息未做；评论为本地 mock
- 帖图复用游戏库 media 占位
- Hot / Gamelibrary 业务仍在 entry，仅有 HAR 骨架
- 合并后需 DevEco / ohpm 安装 `home` 依赖后编译验证
