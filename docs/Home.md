# 首页开发文档（`home` 分支）

职责：首页 **关注 + 推荐**（社区内容流）。其它 Tab 不在本模块范围。

对照设计：`design/Home/`，见 `design/README.md`。

## 进度总览

| 模块 | 状态 | 说明 |
|---|---|---|
| 首页壳（顶栏 关注/推荐、搜索/消息入口） | 已完成 | `pages/Home/Home.ets`，默认推荐 |
| 推荐 Tab（圈子横滑 + 图文帖流） | 已完成 | `HomeRecommend.ets` + mock，对照 `recommend.jpg` |
| 关注 Tab（关注用户条 + 盒友动态） | 已完成 | `FollowFeed.ets` + mock，对照 `follow.jpg` |
| 关注用户筛选内容 | 进行中 | 头像可点选高亮；尚未按用户过滤列表 / 二级页 |
| 帖子详情（正文） | 未开始 | 参考 `design/Home/post/detail-*` |
| 帖子评论（列表 / 楼中楼） | 未开始 | 参考 `design/Home/post/comments-*` |
| 首页 mock / model | 已完成 | `model/HomeModel.ets`；卡片 `PostCard.ets` |

状态取值：`未开始` / `进行中` / `已完成`。

## 目录与关键文件

```
entry/src/main/ets/
├── model/HomeModel.ets          # 圈子 / 关注用户 / 帖子 mock
└── pages/Home/
    ├── Home.ets                 # 顶栏 + Tab 切换
    ├── HomeRecommend.ets        # 推荐：圈子横滑 + 列表
    ├── FollowFeed.ets           # 关注：用户条 + 盒友动态
    └── PostCard.ets             # 共用帖子卡片
design/Home/                     # UI 截图（不参与编译）
docs/Home.md                     # 本文件
```

## 变更记录

> 每完成一小部分功能，在此追加一条（新在上）。格式：日期 · 摘要 · 涉及路径 · 对应 commit。

- 2026-07-24 · 首页关注/推荐可切换流（mock 帖卡、圈子与关注用户条） · `pages/Home/*` `model/HomeModel.ets` · commit:待提交
- 2026-07-24 · 协作约束 + 设计图 + 开发文档骨架 · `CLAUDE.md` `design/` `docs/Home.md` · commit:3537d5b

## 已知问题 / 待办

- 圈子 / 关注用户筛选目前只改选中态，未真正过滤帖子
- 搜索、消息、帖子点击进详情尚未做
- 帖图复用游戏库 media 占位，非真实社区配图
- 图标暂用 emoji（搜索/消息/评论/点赞），可后续换矢量资源
