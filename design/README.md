# UI 参考截图

对照真实小黑盒首页相关界面，**不参与编译**。目录与 `entry/src/main/ets/pages/Home` 对齐。

```
design/Home/
├── recommend.jpg              # 首页 · 推荐 Tab
├── follow.jpg                 # 首页 · 关注 Tab
├── follow-content/            # 关注页：点进某用户后的内容流
│   ├── user-1.jpg
│   └── user-2.jpg
└── post/                      # 帖子正文 + 评论
    ├── detail-1-body-top.jpg
    ├── detail-2-body-bottom.jpg
    ├── comments-1-list.jpg
    ├── comments-2-replies-expand.jpg
    ├── comments-3-replies-more.jpg
    └── comments-4-other-post.jpg
```

| 文件 | 内容要点 |
|---|---|
| `recommend.jpg` | 顶栏关注/推荐、圈子横滑、图文帖卡片 |
| `follow.jpg` | 关注用户头像条、盒友动态流 |
| `follow-content/*` | 单用户筛选后的关注内容 |
| `post/detail-*` | 帖子正文（顶栏正文/评论切换、作者、标签、正文） |
| `post/comments-*` | 评论列表、楼中楼展开、另一帖评论样式 |
