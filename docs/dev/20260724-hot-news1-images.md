# 20260724-hot-news1-images

## 背景

完善热点「全部」列表**第一条新闻**（`news-steam-sale` / Steam 折扣合集）详情与素材，对照真实 App 截图与 `D:\Project\Image` 下「新闻1-*」资源。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_news1_img1.jpg` | 图1 怪猎封面（卡片） |
| `Hot/src/main/resources/base/media/hot_news1_img2.jpg` | 图2 怪猎详情页截图 |
| `Hot/src/main/resources/base/media/hot_news1_img3.png` | 图3 街霸6 封面（卡片） |
| `Hot/src/main/resources/base/media/hot_news1_img4.jpg` | 图4 街霸6 详情页截图 |
| `Hot/src/main/resources/base/media/hot_news1_img5.jpg` | 图5 生化4 封面（卡片） |
| `Hot/src/main/resources/base/media/hot_news1_img6.jpg` | 图6 生化4 详情页截图 |
| `Hot/src/main/resources/base/media/hot_news1_avatar.png` | 博主头像「塔可松」 |
| `Hot/src/main/ets/model/HotModel.ets` | 扩展 `avatarImg` / `imageSrc` / `coverImg` / `discountLabel`；重写 `detailSteamSale` |
| `Hot/src/main/ets/pages/Hot/HotNewsDetail.ets` | 头像 / 游戏卡 / 正文图优先真实资源 |
| `Hot/src/main/ets/pages/Hot/Hot.ets` | 列表缩略图支持 `coverImg`（本条仍用 deal 宫格） |

未入库（仅对照）：`新闻1-图片3与4的截图.jpg`、`新闻1-图片5与6的截图.jpg`。

## 实现说明

### 详情正文结构（对照截图）

1. 标题 + 作者（真实头像）+ Steam 平台
2. 引言 / 游戏节 bullet / 引导文案 / 「史低佳作区」
3. 序号 `1` → 怪猎游戏卡 + 图2 全宽截图  
4. 序号 `2` → 街霸6 游戏卡 + 图4 全宽截图  
5. 序号 `3` → 生化4 游戏卡 + 图6 全宽截图  

游戏卡字段对齐截图：评分、券后价、史低角标、收藏数、封面折扣标。

底栏互动数对齐截图：👍837 / ☆187 / ⚡93 / 💬20。

### UI 策略

- 有 `avatarImg` / `coverImg` / `imageSrc` 时用 `Image`；否则保留渐变占位
- 正文大图用 `ImageFit.Contain`（整页截图含价格条，避免 Cover 裁切）
- 列表第一条仍为 deal 折扣宫格（与列表设计一致），真实图主要服务详情

## 验证方式

1. 编译 entry / Hot，确认 `app.media.hot_news1_*` 可解析  
2. 热点 → 全部 → 点第一条 Steam 折扣文  
3. 作者头像为塔可松插画；正文依次出现 3 组游戏卡 + 大图  
4. 底栏数字 837 / 187 / 93 / 20  

## 已知限制 / 后续

- 详情页内嵌的是完整 App 截图（含价格条/标签），未拆成可交互组件  
- 评论区 mock 未按截图重做  
- 列表 deal 宫格未换真实缩略图  
