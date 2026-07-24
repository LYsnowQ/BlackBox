# 20260724-hot-news2-images

## 背景

完善热点「全部」列表**第二条新闻**（`news-stellar-mod` / 剑星白色蓬蓬裙 MOD）详情与素材，对照 `D:\Project\Image` 下「新闻2-*」资源与「新闻2-正文及评论截图」。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_news2_img1.jpg` | 展示图1 正面/背面 |
| `Hot/src/main/resources/base/media/hot_news2_img2.png` | 展示图2 工业场景对比 |
| `Hot/src/main/resources/base/media/hot_news2_img3.jpg` | 展示图3 湖边 |
| `Hot/src/main/resources/base/media/hot_news2_img4.jpg` | 展示图4 峡谷 ver2.0 |
| `Hot/src/main/resources/base/media/hot_news2_img5.jpg` | 展示图5 太空 |
| `Hot/src/main/resources/base/media/hot_news2_avatar.png` | 作者 CHENSTUDIOS 头像 |
| `Hot/src/main/resources/base/media/hot_news2_game.jpg` | 游戏卡「剑星」封面 |
| `Hot/src/main/ets/model/HotModel.ets` | 列表 `coverImg` + 重写 `detailStellarMod` / 评论 mock |
| `Hot/src/main/ets/pages/Hot/HotNewsDetail.ets` | 正文图块角标逻辑微调（真图不叠占位角标） |

未入库（仅布局对照）：`新闻2-正文及评论截图.jpg`。

## 实现说明

### 详情结构（对照截图）

1. 标题 + 作者（宸字头像）+ 平台：剑星 / Steam / steam游戏  
2. 顶部游戏卡：剑星 · 9.1 · ¥242 券后价 · 已拥有 · 真实封面  
3. 五张展示图（img1–5）依次全宽  
4. 「安装路径」+ `\\StellarBlade\\SB\\Content\\Paks\\~mods\\` + 编号 2990  
5. 「已知可能遇到的问题」Chunk ID 冲突说明  
6. 评论 mock 对齐截图主要用户与文案；底栏 86 / 141 / 9 / 💬14  

### 列表

- 第二条缩略图绑定 `coverImg = hot_news2_img1`（`ImageThumbBuilder` 已支持真图）

## 验证方式

1. 编译 entry / Hot：`app.media.hot_news2_*` 可解析  
2. 热点 → 全部 → 第二条「剑星…蓬蓬裙」缩略图为展示图1  
3. 进详情：头像、游戏卡封面、五张图、安装路径与问题说明  
4. 切「评论」：可见 mock 评论列表  

## 已知限制 / 后续

- 截图中的话题标签条 / 合集条未单独组件化  
- 评论头像除作者外仍为渐变字占位  
- 回复楼中楼仅保留一条示例  
