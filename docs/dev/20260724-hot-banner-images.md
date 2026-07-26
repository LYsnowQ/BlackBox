# 20260724-hot-banner-images

## 背景

热点「全部」频道顶部动态展示栏（Swiper Banner）原先用渐变色 + 文案占位。  
现将 `D:\Project\Image` 的 **图1–图4** 依次接入为轮播真实图片，对齐宣传素材（图内已含标题/CTA）。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/resources/base/media/hot_banner_1.jpg` | 图1 · 风暴枪弹 |
| `Hot/src/main/resources/base/media/hot_banner_2.jpg` | 图2 · 战地风云 6 第 4 赛季 |
| `Hot/src/main/resources/base/media/hot_banner_3.jpg` | 图3 · 碧蓝幻想 Relink |
| `Hot/src/main/resources/base/media/hot_banner_4.jpg` | 图4 · PUBG KUN 夏日空投 |
| `Hot/src/main/ets/model/HotModel.ets` | `HotBanner.coverImg` + 4 条 mock 绑定 `$r('app.media.hot_banner_n')` |
| `Hot/src/main/ets/pages/Hot/Hot.ets` | `BannerSlideBuilder` 有图则 `Image` Cover，无图回退渐变文案 |

## 实现说明

- 资源放在 **Hot HAR** 的 `resources/base/media`，模块内用 `$r('app.media.hot_banner_1')` 等引用（与 Gamelibrary 一致）。
- `hotBanners` 扩展为 4 帧，顺序与图1→图4 一致。
- 宣传图已烘焙文案，有 `coverImg` 时不再叠 CTA/标题，避免重影；无图时仍走原渐变占位逻辑。
- 轮播仍：`autoPlay` / 4s / 指示器 / 高度 148。

## 验证方式

1. DevEco 编译 entry / Hot：资源能解析，无 `app.media.hot_banner_*` 找不到
2. 运行 App → 底部「热点」→「全部」
3. 顶部 Banner 依次为图1–图4，可自动轮播与手势滑动
4. 切换「热榜」等频道不影响 Banner 资源

## 已知限制 / 后续

- Banner 点击暂未跳转详情/外链
- 源文件在仓库外 `D:\Project\Image`，以 `Hot/.../media` 内拷贝为准入库
- 第一条新闻配图见 [20260724-hot-news1-images.md](./20260724-hot-news1-images.md)；其余列表缩略图仍可能为渐变占位
