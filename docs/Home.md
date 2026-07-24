# 首页开发文档（`home` 分支）

职责：首页 **关注 + 推荐**（社区内容流）。其它 Tab 不在本模块范围。

对照设计：`design/Home/`，见 `design/README.md`。

## 进度总览

| 模块 | 状态 | 说明 |
|---|---|---|
| 首页壳（顶栏 关注/推荐、搜索/消息入口） | 已完成 | `pages/Home/Home.ets`，默认推荐 |
| 推荐 Tab（圈子横滑 + 图文帖流） | 已完成 | `HomeRecommend.ets` + mock |
| 关注 Tab（关注用户条 + 盒友动态） | 已完成 | `FollowFeed.ets` + mock |
| 关注用户筛选内容 | 进行中 | 头像可点选高亮；尚未按用户过滤列表 |
| 帖子详情（正文） | 已完成 | `PostDetail.ets` 正文 Tab，对照 `post/detail-*` |
| 帖子评论（列表 / 楼中楼） | 已完成 | 评论 Tab + 展开/收起回复，对照 `post/comments-*` |
| 首页 mock / model | 已完成 | `HomeModel.ets` 含详情与评论；列表点进详情 |

状态取值：`未开始` / `进行中` / `已完成`。

## 目录与关键文件

```
entry/src/main/ets/
├── model/HomeModel.ets          # 流 / 详情 / 评论 mock + getPostDetailById
└── pages/Home/
    ├── Home.ets                 # 顶栏 + Tab 切换
    ├── HomeRecommend.ets
    ├── FollowFeed.ets
    ├── PostCard.ets             # 点击 → PostDetail
    └── PostDetail.ets           # 二级页（main_pages 已注册）
entry/src/main/resources/base/profile/main_pages.json  # 末尾追加 PostDetail
design/Home/
docs/Home.md
```

## 变更记录

> 每完成一小部分功能，在此追加一条（新在上）。

- 2026-07-24 · 修复 PostDetail 与基类 tabIndex 命名冲突 · `PostDetail.ets` · commit:9551075
- 2026-07-24 · 帖子详情正文/评论 + 列表跳转 · `PostDetail.ets` `HomeModel` `PostCard` `main_pages.json` · commit:88fa36e
- 2026-07-24 · 首页关注/推荐可切换流 · `pages/Home/*` `model/HomeModel.ets` · commit:9e34403
- 2026-07-24 · 协作约束 + 设计图 + 开发文档骨架 · `CLAUDE.md` `design/` `docs/Home.md` · commit:3537d5b

## 已知问题 / 待办

- 圈子 / 关注用户筛选目前只改选中态，未真正过滤帖子
- 搜索、消息、真实发评未做
- 帖图复用游戏库 media 占位
- 图标暂用 emoji / 符号
- 评论「查看更多回复」在已展开时仅收起，未分页加载更多 mock
