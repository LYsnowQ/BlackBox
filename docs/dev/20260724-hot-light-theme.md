# 20260724-hot-light-theme

## 背景

热点模块首版按深色截图（`Screen/图1–图6`）实现。现补充浅色截图 `Screen/Light/`，要求：

1. **默认显示浅色**（与主壳底栏一致）
2. **深色保留为可调试配色**，后期由上层主题接管
3. 持续更新开发文档

浅色截图对照：

| 文件 | 界面 |
|------|------|
| `Screen/Light/图1.jpg` | 全部 Feed + Banner |
| `Screen/Light/图2.jpg` | 热榜（1–4 彩色序号底） |
| `Screen/Light/图3.jpg` | 详情正文 |
| `Screen/Light/图4.jpg` | 详情评论 |

## 涉及文件

| 路径 | 说明 |
|------|------|
| `entry/src/main/ets/pages/Hot/HotTheme.ets` | **新增** light/dark 色板 + `HOT_DEFAULT_THEME_MODE` |
| `entry/src/main/ets/pages/Hot/Hot.ets` | 列表页改用主题色，默认 light |
| `entry/src/main/ets/pages/Hot/HotNewsDetail.ets` | 详情页改用主题色，支持路由传 `themeMode` |
| `docs/ui-refs/02-hot/notes.md` | 补充浅色截图清单 |
| `docs/dev/20260724-hot-feed-detail.md` | 交叉引用本主题变更 |

## 实现说明

### 主题结构 `HotTheme.ets`

- `HotThemeMode = 'light' | 'dark'`
- **`HOT_DEFAULT_THEME_MODE = 'light'`** ← 产品默认
- `HOT_THEME_LIGHT` / `HOT_THEME_DARK`：页面背景、主/次文字、Tab、卡片、输入框、关注按钮、折扣格、热榜序号底色等
- `getHotTheme(mode)` / `rankBadgeBackground(theme, rank)`

浅色关键色值（对照 Light 截图）：

- 页底 / 标题：`#FFFFFF` / `#1A1A1A`
- 次要文字：`#8A8A8A`
- 关注按钮：黑底白字
- 热榜 1–4 序号底：橙 / 紫 / 蓝 / 绿
- 输入条：`#F2F2F4`

### 页面接入

- `Hot`：`@State themeMode = HOT_DEFAULT_THEME_MODE`，UI 一律 `this.theme().xxx`
- 打开详情时携带 `params.themeMode`，详情页 `aboutToAppear` 读取，保证列表与详情主题一致
- **调试切换深色**：点击热点顶栏 **消息图标（✉️）** 可在 light/dark 间切换（仅本地调试；正式由上层接管后可删除）
- 也可改 `HOT_DEFAULT_THEME_MODE = 'dark'` 全局默认深色调试

### 热榜序号

浅色截图为彩色小方块序号（1 橙 2 紫 3 蓝 4 绿，≥5 灰色数字无底）。深色调试态仍可用前三强调色板。

## 验证方式

1. `assembleHap` → BUILD SUCCESSFUL
2. 运行后切 **热点**：白底黑字，与 Light/图1 一致
3. 切 **热榜**：彩色序号，对照 Light/图2
4. 点新闻进详情：白底正文/评论，对照 Light/图3、图4
5. 点顶栏 ✉️ 切换深色，再点新闻，详情应同为深色
6. 再点 ✉️ 回到浅色

## 已知限制 / 后续

- 封面/头像仍为渐变占位，未使用真实图
- 主题切换入口为调试用，**非产品功能**；上层提供全局主题后，删除点击切换，改为读全局 mode
- 未接系统 `colorMode` / `color.json` 资源分层
- Light 截图仅 4 张，剑星详情（原深色图5）无新浅色稿，沿用同一套主题 token

## 与上一文档关系

功能结构（全部 / 热榜 / 详情 / Mock）见 [20260724-hot-feed-detail.md](./20260724-hot-feed-detail.md)。  
本文只记录 **默认浅色 + 主题抽离**。
