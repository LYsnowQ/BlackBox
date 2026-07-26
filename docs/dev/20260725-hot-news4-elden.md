# 20260725-hot-news4-elden

## 背景

替换「全部」列表**第四条**占位帖（原 `news-gta-titan`），改为对照 `D:\Project\Image\新闻4\`：

**《艾尔登法环：褪色者版》双新职业公开，完整开局属性一览**（阿熊快讯）

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_news4_img1~3.jpg` | 官推双职业 / Heavy Knight / Idus Knight |
| `Hot/src/main/resources/base/media/hot_news4_avatar.jpg` | 作者头像 |
| `Hot/src/main/resources/base/media/hot_news4_thumb.png` | 列表专用缩略图 |
| `Hot/src/main/ets/model/HotModel.ets` | 列表 `news-elden-faded`；`detailEldenFaded`；`detailMap` |

未入库（仅对照）：`新闻4-列表截图.png`、`新闻4-正文截图.jpg`、`新闻4-评论截图.jpg`。

## 实现说明

### 列表

- 标题 / 昨天16:49 / 主机游戏 / 💬17  
- 缩略图：`hot_news4_thumb`（用户提供的列表专用缩略图）

### 详情正文（对照正文截图）

1. 作者：阿熊快讯 Lv.17 · 昨天16:49·河南 · 真实头像 · 主机游戏  
2. 导语 + 图1（官推双职业）  
3. 一、重装骑士 bullet + 图2  
4. 二、伊德斯骑士 bullet + 图3  
5. 版本配套信息段落  

### 评论（评论截图原文，不杜撰）

刃暖枪寒、Watcher、【置顶】、略显笨拙、杠精、寒天碎梦、AoirKunS、taecg1985、于是乎福来运转、意挽卿 等；底栏 mock 👍22 / ☆8 / ⚡0 / 💬18。

## 验证方式

1. 编译：`app.media.hot_news4_*` 可解析  
2. 热点 → 全部 → 第四条标题/标签与列表截图一致  
3. 详情：三图、双职业文案、评论用户名与原文  

## 已知限制 / 后续

- 评论头像除作者外仍渐变字  
