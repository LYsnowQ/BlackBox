# 20260724-hot-feed-detail

## 背景

负责人 **wgl** 按小黑盒截图实现 **热点 Tab** 前端展示（仅 Mock，无真实接口）。  
截图目录：`entry/src/main/ets/pages/Hot/Screen/`（深色图1–图6；浅色见 `Screen/Light/`）。  
**默认已改为浅色**，深色作调试配色，详见 [20260724-hot-light-theme.md](./20260724-hot-light-theme.md)。

| 截图 | 对应界面 |
|------|----------|
| 图1 / 图2 | 热点「全部」：顶栏 + 频道 Tab + Banner + 新闻列表 |
| 图3 | 新闻详情「正文」（Steam 折扣文） |
| 图4 | 新闻详情「评论」 |
| 图5 | 新闻详情「正文」（剑星 MOD，含游戏卡片） |
| 图6 | 「热榜」列表 |

需求补充：

- 顶部频道默认 **全部**；含 **热榜**、**剑星 / Steam / 战术小队 / 绝地求生** 等。
- 剑星、Steam 等游戏频道截图暂未提供 → 点击显示 **待开发** 占位。
- 点击新闻主体进入详情（正文 + 评论）。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `entry/src/main/ets/model/HotModel.ets` | 热点类型定义 + 全部 Mock 数据 + `getHotNewsById` / `getAllFeedNews` |
| `entry/src/main/ets/pages/Hot/Hot.ets` | 热点 Tab 主界面（全部 / 热榜 / 待开发） |
| `entry/src/main/ets/pages/Hot/HotNewsDetail.ets` | 新闻详情页（正文 / 评论 + 底栏互动） |
| `entry/src/main/resources/base/profile/main_pages.json` | 注册路由 `pages/Hot/HotNewsDetail` |
| `entry/src/main/ets/pages/Hot/Screen/*.png` | UI 参考截图（不参与编译） |
| `docs/ui-refs/02-hot/notes.md` | 截图清单说明 |

## 实现说明

### 1. 数据层 `HotModel`

- **频道** `HotChannel`：`type = all | rank | game`。
- **Feed** `HotNewsItem`：标题、时间、标签、评论数、缩略图类型（`image` / `deal` / `video`）、折扣宫格等。
- **热榜** `HotRankItem`：排名色（前三红）、阅读量、可映射 `newsId` 打开详情。
- **详情数据** `HotNewsDetailData`：作者、平台、正文块（段落 / 列表 / 标题 / 图 / 游戏卡）、评论与回复。  
  （接口名刻意不叫 `HotNewsDetail`，避免与页面组件同名，见下方「编译问题修复」。）
- 专属 Mock：`news-steam-sale`（图3/4）、`news-stellar-mod`（图5）；其余列表项由 `buildPlaceholderDetail` 生成占位正文。

### 2. 列表页 `Hot`

- 顶栏：「热点」+ 搜索 / 消息图标（展示用）。
- 横向频道 Tab + 下划线选中态；右侧 ☰。
- **全部**：`Swiper` Banner + `List` 新闻行（左文右图；deal 类型渲染绿色折扣格）。
- **热榜**：序号 + 标题 + 阅读/标签 + 缩略占位。
- **game 频道**：居中「待开发」文案。
- 点击新闻 / 热榜项：`router.pushUrl('pages/Hot/HotNewsDetail', { id })`。
- 背景色 `#0D0D0D`，文字白 / 灰，对齐截图深色风格。

### 3. 详情页组件 `HotNewsDetail`

- 顶栏：返回、正文/评论 Tab、分享图标。
- **正文**：标题、作者行（头像渐变占位、等级色标、关注按钮）、平台标签、可选顶置游戏卡、正文块列表。
- **评论**：数量 +「热门」、评论项（置顶标记、楼中楼回复底色块）、点赞数、底部「暂无更多内容」。
- 底栏：输入占位「来说点什么吧!」+ 赞 / 藏 / 推 / 评；赞与藏为本地 `@State` 切换；点评论图标切到评论 Tab。
- 正文/评论切换状态字段为 `@State detailTabIndex`（**不要**用 `tabIndex`，见下方修复记录）。

### 4. 路由

`main_pages.json` 增加 `pages/Hot/HotNewsDetail`，与游戏详情页同样通过 `router` 打开，不嵌在底部 Tab 内。

## 编译问题修复（2026-07-24）

首次 `assembleHap` 在 `CompileArkTS` 失败，原因与处理如下。

| 错误 | 原因 | 处理 |
|------|------|------|
| `Import declaration conflicts with local declaration of 'HotNewsDetail'` / `arkts-unique-names` | 页面 `struct HotNewsDetail` 与模型 `interface HotNewsDetail` 同名 | 模型改为 **`HotNewsDetailData`**；页面组件与路由名保持 `HotNewsDetail` |
| `Property 'tabIndex' ... not assignable ... base type 'CustomComponent'` | `@State tabIndex` 与组件基类属性冲突 | 改为 **`@State detailTabIndex`** |
| 连带「类型缺失 title/author/…」等一串错误 | 上述同名导致类型被解析成组件自身 | 随重命名一并消失 |

验证：本地执行 `assembleHap` → **BUILD SUCCESSFUL**（仍有与游戏库相同的 `router.pushUrl/getParams/back` deprecated 警告，不影响打包）。

## 验证方式

1. DevEco 编译运行，底部切到 **热点**。
2. **全部**：可见 Banner 轮播与多条新闻；列表可上下滑（图1/2）。
3. 点第一条 Steam 折扣新闻 → 正文接近图3；切「评论」接近图4。
4. 点「剑星可爱白色蓬蓬裙…」→ 正文含游戏卡，接近图5。
5. 切频道 **热榜** → 1–7 排名列表（图6）；可点进详情。
6. 切 **剑星 / Steam / …** → 显示待开发占位，不崩溃。
7. 详情返回后仍在热点 Tab。

## 已知限制 / 后续

- **无真实图片资源**：封面 / 头像 / Banner 均用渐变 + 文字占位；接入素材后替换为 `Image($r('app.media.xxx'))` 即可。
- 色值已抽到 `HotTheme.ets`（默认 light）；未接系统 `colorMode` / 上层主题。
- 游戏频道内容未提供，仅占位。
- 搜索、消息、关注、分享、发评等 **无业务逻辑**，仅 UI。
- 底栏（Index）仍为全局浅色导航，与热点深色内容并存；若需整页沉浸深色，可再与主壳负责人协调。
- 未做下拉刷新 / 分页加载。

## 结构一览

```
Hot Tab
├── 全部 → Banner + NewsList → HotNewsDetail(正文|评论)
├── 热榜 → RankList → HotNewsDetail
└── 剑星/Steam/… → 待开发占位
```
