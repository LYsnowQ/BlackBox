# BlackBox（小黑盒 · 鸿蒙）

HarmonyOS / ArkTS 仿「小黑盒」App。包名 `com.example.blackbox`，DevEco Studio 编译运行。数据全 mock，无真实网络。

## 本分支职责

- **只做首页**：关注 + 推荐（社区内容流，不是游戏库推荐）
- 浅色主题（白底），UI 以真实 App / `design/` 截图为准
- 其它 Tab（热点 / 发布 / 游戏库 / 我）保持占位或他人实现，**不要改业务**

## 模块化约定

业务在 HAR，entry 只做壳与依赖：

| 包名 | 目录 | 职责 |
|---|---|---|
| `home` | `Home/` | **本分支主战场**：关注/推荐流、帖子详情 |
| `profile` | `Profile/` | 我的（他人） |
| `hot` / `gamelibrary` | `Hot/` `Gamelibrary/` | 骨架或他人业务 |
| entry | `entry/` | `Index` 底栏、`main_pages`、各模块 `@Entry` 壳 |

- Index 挂载：`import { Home } from 'home'`
- 二级页：`entry/.../pages/Home/PostDetail.ets` 壳 → `PostDetailPage`；路径见 `HomeRoutes` / `docs/ROUTE_CONTRACT.md`
- 禁止业务硬编码 `pages/...`，用 `*Routes` 常量

## 避免 Git 冲突的约束

多人分模块并行。原则：**结构约定与主分支一致，业务代码放自己 HAR；共享文件只做最小增量。**

### 可以放心改（低冲突）

- `Home/**`（HAR 内 pages / model / router）
- entry 内 **仅** `pages/Home/*` 壳文件
- **新增** 资源：`entry/.../resources/base/media/` 下首页素材（扁平、新文件名）
- 设计对照：`design/Home/`
- `docs/Home.md`

### 尽量少碰（高冲突）

| 文件 | 规则 |
|---|---|
| `pages/Index.ets` | **能不改就不改**；必须改时只动首页 import/挂载，不重写底栏、不改默认 `bottomTabIndex`、不改游戏库 header |
| `main_pages.json` | **只追加、不重排、不删**已有 path；冲突时两边新增 path **都保留** |
| `entry/oh-package.json5` / `build-profile.json5` | 只追加本模块依赖 |
| 全局 `color.json` / `string.json` | 优先新增 key |

### 禁止改（他人模块）

- `entry/.../GameLibrary/**`、`GameDetail/**`、`Hot/**`、`Profile/**` 壳与业务
- `Profile/`、`Gamelibrary/`、`Hot/` HAR 业务（除非协作约定）
- `model/GameModel.ets` 等游戏库数据

### 路由与页面注册

- Tab 内嵌组件（`Home`）不必写入 `main_pages.json`
- `router.pushUrl` 二级页：模块 `*Routes` + entry `@Entry` 壳 + `main_pages` **末尾追加**
- 合并冲突：两边 path 都保留

### 合并前自检

1. 业务改动是否几乎都在 `Home/` HAR？
2. entry 是否只剩壳 + 最小 Index/依赖增量？
3. 未删除、未重排他人的路由 path 与底栏项

## UI / 数据约定

- 浅色：背景 `#FFFFFF`，主文字 `#1A1A1A`，次要灰 `#B0B0B0`
- 数据全部 mock
- 运行时图片：`entry/src/main/resources/base/media/`（扁平）
- UI 参考：`design/Home/`，见 `design/README.md`

## 环境

- Windows + DevEco；终端 PowerShell 用 `pwsh`
- 主分支一般为 `master`；本职责分支为 `home`
- 依赖模块后需在工程执行 ohpm/DevEco 同步（`home`、`profile` 等）

## 增量交付：文档 + Git（强制）

**每完成一小部分可独立验证的功能**，必须立刻：

### 1. 同步开发文档

| 文档 | 何时更新 |
|---|---|
| `docs/Home.md` | **主文档**。进度、目录、变更记录、已知问题 |
| `docs/ROUTE_CONTRACT.md` | 路由增删时 |
| `design/README.md` | 设计图变化时 |
| `CLAUDE.md` | 协作/模块约定变化时 |

### 2. 同步 Git（本分支本地提交）

1. `git status` / `git diff`：改动在允许范围
2. 只 stage 相关文件
3. 中文 commit message
4. **默认不 push**；推送仅当用户明确要求

### 何谓「一小部分」

够演示或对照设计截图的一块即可；纯读代码不提交。
