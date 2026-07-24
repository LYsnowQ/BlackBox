# 首页开发文档（`home` 分支）

职责：首页 **关注 + 推荐**（社区内容流）。业务在 **Home HAR**（包名 `home`），entry 只挂载壳。

对照设计：`design/Home/`，见 `design/README.md`。路由契约见 `docs/ROUTE_CONTRACT.md`。

## 当前工程状态（2026-07-24）

- 分支：`home`（已与 `origin/master` 合并，编译运行通过）
- 模块化：`home` / `profile` / `gamelibrary` 已作为本地 HAR 被 entry 依赖
- Index 挂载：`import { Home } from 'home'`；游戏库 Tab：`import { RecommendTab, RankingTab } from 'gamelibrary'`；我：`import { Me } from 'profile'`
- 依赖安装：修改 `entry/oh-package.json5` 后需在工程执行 `ohpm install`（或 DevEco 同步），生成 `entry/oh_modules/*`

## 进度总览

| 模块 | 状态 | 说明 |
|---|---|---|
| 首页壳（顶栏 关注/推荐） | 已完成 | `Home/src/main/ets/pages/Home.ets` |
| 推荐 Tab | 已完成 | `HomeRecommend.ets` |
| 关注 Tab | 已完成 | `FollowFeed.ets` |
| 关注用户筛选 | 进行中 | 仅选中高亮，未过滤列表 |
| 帖子详情 + 评论连续滚动 | 已完成 | `PostDetailPage` + entry 壳 `pages/Home/PostDetail` |
| 底栏赞/藏/充/评 | 已完成 | mock 本地状态 |
| Home 模块化 | 已完成 | 业务在 `Home/` HAR，entry 仅壳 |
| 与主分支模块化对齐 | 已完成 | 已 merge master；游戏库/Profile 同为 HAR |

## 目录与关键文件

```
Home/                                   # HAR 包名 home · 本分支主战场
├── Index.ets                           # 导出 Home / PostDetailPage / HomeRoutes 等
└── src/main/ets/
    ├── model/HomeModel.ets
    ├── pages/
    │   ├── Home.ets
    │   ├── HomeRecommend.ets
    │   ├── FollowFeed.ets
    │   ├── PostCard.ets
    │   └── PostDetailPage.ets
    └── router/HomeRoutes.ets

entry/src/main/ets/
├── pages/Index.ets                     # 底栏壳；import home / gamelibrary / profile
├── pages/Home/PostDetail.ets           # @Entry 壳 → PostDetailPage
├── pages/GameLibrary|GameDetail/       # 游戏库 @Entry 壳（业务在 gamelibrary）
├── pages/Profile/*                     # 我的二级页壳（业务在 profile）
├── pages/Hot/*                         # 热点仍部分在 entry（Hot HAR 多为骨架）
└── router/AppRoutes.ets

entry/oh-package.json5                  # dependencies: home, profile, gamelibrary
design/Home/                            # UI 截图（不参与编译）
docs/Home.md / ROUTE_CONTRACT.md
```

## entry 依赖（本地 HAR）

| 包名 | 路径 | 用途 |
|---|---|---|
| `home` | `file:../Home` | 首页关注/推荐/帖子详情 |
| `profile` | `file:../Profile` | 我的 Tab 与二级页 |
| `gamelibrary` | `file:../Gamelibrary` | 游戏库推荐/榜单/详情 |

## 变更记录

> 每完成一小部分功能，在此追加一条（新在上）。

- 2026-07-24 · 文档同步：主分支合并后模块化与依赖现状 · `docs/*` `CLAUDE.md` `design/README.md` · commit:待提交
- 2026-07-24 · merge origin/master 进 home，编译运行通过 · commit:fe2d5c6
- 2026-07-24 · ohpm install 链接 home/profile · commit:f78eda4
- 2026-07-24 · 合并 origin/LYsnowQ + 首页迁入 Home HAR · commit:b30b006
- 2026-07-24 · 详情底栏互动 + 正文评论连续滚动 · commit:789675b
- 2026-07-24 · 修复 PostDetail 与基类 tabIndex 冲突 · commit:9551075
- 2026-07-24 · 帖子详情正文/评论 + 列表跳转 · commit:88fa36e
- 2026-07-24 · 首页关注/推荐可切换流 · commit:9e34403
- 2026-07-24 · 协作约束 + 设计图 + 开发文档骨架 · commit:3537d5b

## 已知问题 / 待办

- 圈子 / 关注用户筛选未真正过滤
- 搜索、消息未做；评论输入为本地 mock
- 帖图复用游戏库 media 占位；图标多用 emoji
- Hot 业务仍主要在 `entry/.../pages/Hot/`，`Hot/` HAR 尚未承接业务
- 充电无真实支付；仅本地计数 + toast

## 编译注意

1. `entry/oh-package.json5` 增删 HAR 依赖后执行 ohpm install  
2. 找不到 `home`/`profile`/`gamelibrary` → 先查 `entry/oh_modules/` 是否有对应链接  
3. HAR 内组件不能直接 `@Entry`；二级页必须 entry 壳 + `main_pages.json`  
