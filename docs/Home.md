# 首页开发文档（`home` 分支）

职责：首页 **关注 + 推荐**（社区内容流）。其它 Tab 不在本模块范围。

对照设计：`design/Home/`，见 `design/README.md`。

## 进度总览

| 模块 | 状态 | 说明 |
|---|---|---|
| 首页壳（顶栏 关注/推荐、搜索/消息入口） | 未开始 | 内嵌于 `Index` 的 `Home` 组件 |
| 推荐 Tab（圈子横滑 + 图文帖流） | 未开始 | 参考 `design/Home/recommend.jpg` |
| 关注 Tab（关注用户条 + 盒友动态） | 未开始 | 参考 `design/Home/follow.jpg` |
| 关注用户筛选内容 | 未开始 | 参考 `design/Home/follow-content/` |
| 帖子详情（正文） | 未开始 | 参考 `design/Home/post/detail-*` |
| 帖子评论（列表 / 楼中楼） | 未开始 | 参考 `design/Home/post/comments-*` |
| 首页 mock / model | 未开始 | 独立于 `GameModel` |

状态取值：`未开始` / `进行中` / `已完成`。

## 目录与关键文件

```
entry/src/main/ets/pages/Home/   # 首页 UI（主战场）
entry/src/main/ets/model/        # 首页专用 model（勿写 GameModel）
entry/src/main/resources/base/media/  # 运行时图片（扁平、新文件名）
design/Home/                     # UI 截图（不参与编译）
```

## 变更记录

> 每完成一小部分功能，在此追加一条（新在上）。格式：日期 · 摘要 · 涉及路径 · 对应 commit。

- （尚无功能提交）

## 已知问题 / 待办

- （无）
