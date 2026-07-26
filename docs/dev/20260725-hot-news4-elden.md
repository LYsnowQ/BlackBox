# 20260725-hot-news4-elden

## 背景

替换「全部」列表**第四条**占位帖（原 `news-gta-titan` / GTA 活动），改为对照 `D:\Project\Image\新闻4\` 真实帖：

**《艾尔登法环：褪色者版》双新职业公开，完整开局属性一览**（阿熊快讯 / 主机游戏）

素材源目录：`D:\Project\Image\新闻4\`（列表截图、正文截图、评论截图、图片 1–3、博主头像、列表缩略图）。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_news4_img1.jpg` | 官推双职业拼图 |
| `Hot/src/main/resources/base/media/hot_news4_img2.jpg` | Heavy Knight 属性卡 |
| `Hot/src/main/resources/base/media/hot_news4_img3.jpg` | Idus Knight 属性卡 |
| `Hot/src/main/resources/base/media/hot_news4_avatar.jpg` | 作者「阿熊快讯」头像 |
| `Hot/src/main/resources/base/media/hot_news4_thumb.png` | 列表专用缩略图 |
| `Hot/src/main/ets/model/HotModel.ets` | 列表项 `news-elden-faded`；`authorAxiong`；`detailEldenFaded`；`detailMap` 注册 |

未入库（仅布局/文案对照）：`新闻4-列表截图.png`、`新闻4-正文截图.jpg`、`新闻4-评论截图.jpg`。

## 实现说明

### 1. 列表（对照列表截图）

| 字段 | 值 |
|------|-----|
| id | `news-elden-faded` |
| 标题 | 《艾尔登法环：褪色者版》双新职业公开，完整开局属性… |
| 时间 | 昨天16:49 |
| 标签 | 主机游戏 |
| 评论数 | 17 |
| 缩略图 | `$r('app.media.hot_news4_thumb')` |

### 2. 详情正文（对照正文截图）

1. 作者：阿熊快讯 Lv.17 · 昨天16:49·河南 · 真实头像 · 平台：主机游戏  
2. 导语（褪色者版双新职业、8 月 28 日上线）+ 图1 官推双职业  
3. **一、重装骑士（Heavy Knight）** bullet（等级/属性/定位/优缺点）+ 图2  
4. **二、伊德斯骑士（Idus Knight）** bullet + 图3  
5. **版本配套信息**（本体 + 黄金树幽影 DLC、升级包、预购奖励、伊德斯之地）

底栏 mock：👍22 / ☆8 / ⚡0 / 💬18。

### 3. 评论（评论截图原文，不杜撰）

按截图可见主评 + 楼中楼录入，例如：

| 用户 | 赞 | 摘要 |
|------|-----|------|
| 刃暖枪寒 | 9 | 法环的职业有任何意义么… |
| Watcher | 2 | FS 要不你直接把黑魂123重做… |
| 【置顶】 | 2 | 圈一波，再圈一波… |
| 略显笨拙 / 杠精 / 寒天碎梦 / AoirKunS / taecg1985 / 于是乎福来运转 等 | — | 截图原文 |

### 4. 资源命名约定

与新闻 1–3 一致：

- `新闻N-图片K` → `hot_newsN_imgK`
- `新闻N-博主头像` → `hot_newsN_avatar`
- `新闻N-列表缩略图` → `hot_newsN_thumb`（列表 `coverImg`）

## 验证方式

1. DevEco 编译 entry / Hot：`app.media.hot_news4_*` 可解析  
2. 热点 → 全部 → 第四条：标题/标签/评论数/缩略图与列表截图一致  
3. 进详情：作者头像、三图、双职业文案、版本配套段落  
4. 评论区用户名与正文为截图原文  

## 变更记录

| 日期 | 内容 |
|------|------|
| 2026-07-25 | 初版：替换 GTA 占位为褪色者版；接入 img1–3、avatar；详情 + 评论 mock |
| 2026-07-25 | 列表缩略图改为用户提供的 `新闻4-列表缩略图.png` → `hot_news4_thumb` |

## 已知限制 / 后续

- 评论头像除作者外仍为渐变字占位  
- 评论附图未接入  
- 详情大图为素材图，非可交互组件  
