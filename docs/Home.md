# 首页开发文档（`home` 分支）

职责：首页 **关注 + 推荐**（社区内容流）。业务在 **Home HAR**（包名 `home`），entry 只挂载壳。

对照设计：`design/Home/`，见 `design/README.md`。路由契约见 `docs/ROUTE_CONTRACT.md`。

## 当前工程状态（2026-07-25）

- 分支：`home`（已与 `origin/master` 合并，编译运行通过）
- 模块化：`home` / `profile` / `gamelibrary` 已作为本地 HAR 被 entry 依赖
- Index 挂载：`import { Home } from 'home'`；游戏库 Tab：`import { RecommendTab, RankingTab } from 'gamelibrary'`；我：`import { Me } from 'profile'`
- 依赖安装：修改 `entry/oh-package.json5` 后需在工程执行 `ohpm install`（或 DevEco 同步），生成 `entry/oh_modules/*`

## 进度总览

| 模块 | 状态 | 说明 |
|---|---|---|
| 首页壳（顶栏 关注/推荐） | 已完成 | `Home/src/main/ets/pages/Home.ets` |
| 推荐 Tab | 已完成 | `HomeRecommend.ets` |
| 圈子筛选 | 已完成 | 点圈子按 `circleId` 过滤；「全部」显示全量 |
| 关注 Tab | 已完成 | `FollowFeed.ets` |
| 关注用户筛选 | 已完成 | 点头像过滤该用户帖子，再点取消；无帖显示「暂无动态」 |
| 帖子详情 + 评论连续滚动 | 已完成 | `PostDetailPage` + entry 壳 `pages/Home/PostDetail` |
| 底栏赞/藏/充/评 | 已完成 | mock 本地状态 |
| 互动数据持久化 | 已完成 | Preferences 存赞/藏/充/关注/评论/回复；列表计数同步 |
| 顶栏搜索 | 已完成 | `HomeSearchPage` + entry 壳 `pages/Home/Search`；本地过滤推荐/关注 |
| 顶栏消息 | 已完成 | 复用 `pages/Profile/Messages`（`HomeRoutes.MESSAGES`） |
| 评论回复 | 已完成 | 点「回复」挂到该楼层；本地回复可持久化 |
| 评论点赞 | 已完成 | 楼层 👍 可切换；`likedCommentIds` 持久化 |
| 用户主页 | 已完成 | 头像/昵称跳转 `UserProfilePage`；列表+简介 mock |
| Home 模块化 | 已完成 | 业务在 `Home/` HAR，entry 仅壳 |
| 与主分支模块化对齐 | 已完成 | 已 merge master；游戏库/Profile 同为 HAR |

## 目录与关键文件

```
Home/                                   # HAR 包名 home · 本分支主战场
├── Index.ets                           # 导出 Home / PostDetailPage / HomeRoutes 等
└── src/main/ets/
    ├── model/
    │   ├── HomeModel.ets
    │   └── HomeInteractStore.ets         # Preferences 互动持久化
    ├── pages/
    │   ├── Home.ets
    │   ├── HomeRecommend.ets
    │   ├── HomeSearchPage.ets
    │   ├── UserProfilePage.ets
    │   ├── FollowFeed.ets
    │   ├── PostCard.ets
    │   └── PostDetailPage.ets
    └── router/HomeRoutes.ets

entry/src/main/ets/
├── pages/Index.ets                     # 底栏壳；import home / gamelibrary / profile
├── pages/Home/PostDetail.ets           # @Entry 壳 → PostDetailPage
├── pages/Home/Search.ets               # @Entry 壳 → HomeSearchPage
├── pages/Home/UserProfile.ets          # @Entry 壳 → UserProfilePage
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

- 2026-07-25 · 图标贴近小黑盒 · media `ic_like/star/charge/comment/search/mail` 实心剪影；触底加载延迟 650ms
- 2026-07-25 · 评论热门/最新排序 · `PostDetailPage` 本地 sort
- 2026-07-25 · 下拉刷新 + 触底加载 · `HomeRecommend` `FollowFeed` Refresh + 分页 mock
- 2026-07-25 · 列表层帖子点赞 · `PostCard` `HomeInteractStore.toggleLike` · 与详情计数/状态同步
- 2026-07-25 · 配图全屏预览 · `ImagePreviewPage` + entry 壳 · 列表/详情点图 Swiper
- 2026-07-25 · 修评论赞数同步 + 进首页随机排序 · `PostDetailPage` 展示层用 likedCommentIds 叠加；`HomeRecommend`/`FollowFeed` 进入打乱
- 2026-07-25 · 评论点赞 + 用户主页 · `PostDetailPage` `PostCard` `FollowFeed` `UserProfilePage` `HomeInteractStore` · 路由 `HomeRoutes.USER_PROFILE`
- 2026-07-25 · 首页搜索 + 消息入口 + 评论回复 · `HomeSearchPage` `Home` `PostDetailPage` `HomeInteractStore` + entry 壳 `Search` · 路由 `HomeRoutes.SEARCH/MESSAGES`
- 2026-07-25 · 截图补 8 篇真实帖 mock（rs5–rs12，仅推荐流；评论只文字） · `HomeModel` + media `scrape_greenhell/jiahao/muse/doubao/messi/cxmt/wzry/cf*` · 提取 JSON 在 `Home/mock_raw/extracted/` · 生成脚本 `gen_from_extracted.py`
- 2026-07-24 · 小黑盒真实帖子 mock 扩充（4 帖正文+评论+配图） · `HomeModel` `PostCard` `PostDetailPage` + media `scrape_*` · 原始 JSON 在 `Home/mock_raw/posts/`
- 2026-07-24 · 赞/藏/充/关注/评论本地持久化 · `HomeInteractStore` `PostDetailPage` `PostCard` `Home` · commit:5d3a60d
- 2026-07-24 · 推荐圈子筛选真正过滤 + 扩充各圈子 mock · `HomeRecommend` `HomeModel` `PostCard` · commit:42d4b2e
- 2026-07-24 · 关注用户筛选真正过滤列表 + 扩充 mock（u2/u3） · `FollowFeed` `HomeModel` `PostCard` · commit:83d984e
- 2026-07-24 · 文档同步：主分支合并后模块化与依赖现状 · `docs/*` `CLAUDE.md` `design/README.md` · commit:a35a146
- 2026-07-24 · merge origin/master 进 home，编译运行通过 · commit:fe2d5c6
- 2026-07-24 · ohpm install 链接 home/profile · commit:f78eda4
- 2026-07-24 · 合并 origin/LYsnowQ + 首页迁入 Home HAR · commit:b30b006
- 2026-07-24 · 详情底栏互动 + 正文评论连续滚动 · commit:789675b
- 2026-07-24 · 修复 PostDetail 与基类 tabIndex 冲突 · commit:9551075
- 2026-07-24 · 帖子详情正文/评论 + 列表跳转 · commit:88fa36e
- 2026-07-24 · 首页关注/推荐可切换流 · commit:9e34403
- 2026-07-24 · 协作约束 + 设计图 + 开发文档骨架 · commit:3537d5b

## 已知问题 / 待办

### 待办（按序）

1. ~~配图全屏预览（列表/详情 Swiper）~~
2. ~~列表层帖子点赞（PostCard 接 InteractStore）~~
3. ~~下拉刷新 + 触底加载更多（mock）~~
4. ~~评论热门/最新排序~~
5. ~~搜索/消息/赞藏充评等图标优化~~
6. ~~每次进入主页帖子随机排序~~（已完成）

### 其它

- 搜索为本地 mock 过滤（标题/摘要/作者/标签），无网络；可后续补热搜/历史
- 帖图：真实帖多用 `scrape_*`；其余仍复用游戏库 media / 纯色
- 真实帖 mock：旧爬取 4 篇（rs1–rs4）+ 截图补 8 篇（rs5–rs12）；评论区为截图可见楼层精简
- Hot 业务仍主要在 `entry/.../pages/Hot/`，`Hot/` HAR 尚未承接业务
- 充电无真实支付；仅本地计数 + toast（状态已持久化）
- mediaKey → `$r` 硬编码 if/else 双份，后续可抽公共映射

## 编译注意

1. `entry/oh-package.json5` 增删 HAR 依赖后执行 ohpm install  
2. 找不到 `home`/`profile`/`gamelibrary` → 先查 `entry/oh_modules/` 是否有对应链接  
3. HAR 内组件不能直接 `@Entry`；二级页必须 entry 壳 + `main_pages.json`  
