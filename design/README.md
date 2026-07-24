# UI 参考截图

对照真实小黑盒首页相关界面，**不参与编译**。  
目录命名与 **Home HAR 业务**对齐（源码在 `Home/src/main/ets/pages/`；entry 仅保留 `pages/Home/PostDetail` 路由壳）。

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

| 文件 | 内容要点 | 实现落点 |
|---|---|---|
| `recommend.jpg` | 顶栏关注/推荐、圈子横滑、图文帖卡片 | `HomeRecommend` + `PostCard` |
| `follow.jpg` | 关注用户头像条、盒友动态流 | `FollowFeed` + `PostCard` |
| `follow-content/*` | 单用户筛选后的关注内容 | `FollowFeed` 按 `authorId` 过滤 |
| `post/detail-*` | 正文（作者、标签、配图、段落） | `PostDetailPage` 上部 |
| `post/comments-*` | 评论列表、楼中楼展开 | `PostDetailPage` 连续滚动评论区 |

开发说明见 `docs/Home.md`。
