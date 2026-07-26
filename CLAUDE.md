# BlackBox（小黑盒 · 鸿蒙）

HarmonyOS / ArkTS 仿「小黑盒」App。包名 `com.example.blackbox`，DevEco Studio 编译运行。数据全 mock，无真实网络。

## 本分支职责

- **只做首页**：关注 + 推荐（社区内容流，不是游戏库推荐）
- 浅色主题（白底），UI 以真实 App / `design/` 截图为准
- 其它 Tab（热点 / 发布 / 游戏库 / 我）由对应 HAR 或他人维护，**不要改他人业务**

## 模块化约定（与 master 对齐）

业务在 HAR，entry 只做壳、底栏与依赖：

| 包名 | 目录 | 职责 | 本分支 |
|---|---|---|---|
| `home` | `Home/` | 关注/推荐流、帖子详情 | **主战场** |
| `profile` | `Profile/` | 我的 Tab 与二级页 | 勿改业务 |
| `gamelibrary` | `Gamelibrary/` | 游戏库推荐/榜单/详情 | 勿改业务 |
| `hot` | `Hot/` | 热点（HAR 骨架；业务仍可能在 entry） | 勿改业务 |
| entry | `entry/` | `Index`、`main_pages`、各模块 `@Entry` 壳 | 最小增量 |

### Index 挂载示例

```ts
import { Home } from 'home';
import { RecommendTab, RankingTab } from 'gamelibrary';
import { Me } from 'profile';
```

- 二级页：`entry/.../pages/Home/PostDetail.ets` 壳 → `home.PostDetailPage`
- 禁止业务硬编码 `pages/...`，用 `*Routes` / `AppRoutes`（见 `docs/ROUTE_CONTRACT.md`）
- **改 `entry/oh-package.json5` 后必须 `ohpm install`**，否则 `Cannot find module 'home'|'profile'|'gamelibrary'`

## 避免 Git 冲突的约束

多人分模块并行。原则：**结构约定与主分支一致，业务代码放自己 HAR；共享文件只做最小增量。**

### 可以放心改（低冲突）

- `Home/**`（HAR 内 pages / model / router）
- entry 内 **仅** `pages/Home/*` 壳
- **新增** 资源：`entry/.../resources/base/media/`（扁平、新文件名）
- `design/Home/`、`docs/Home.md`

### 尽量少碰（高冲突）

| 文件 | 规则 |
|---|---|
| `entry/.../pages/Index.ets` | **能不改就不改**；必须改时只动首页 import/挂载，不重写底栏、不改默认 `bottomTabIndex`、不改游戏库 header 逻辑 |
| `main_pages.json` | **只追加、不重排、不删**；冲突时两边 path **都保留** |
| `entry/oh-package.json5` / `build-profile.json5` | 只追加本模块依赖 |
| 全局 `color.json` / `string.json` | 优先新增 key |

### 禁止改（他人模块）

- `Gamelibrary/**`、`Profile/**`、`Hot/**` 业务
- entry 下他人壳：`GameLibrary/`、`GameDetail/`、`Profile/`、`Hot/**`（除非只确认占位）
- 勿把首页数据写进游戏库 model

### 路由与页面注册

- Tab 内嵌组件不必写入 `main_pages.json`
- `router.pushUrl` 二级页：`*Routes` + entry `@Entry` 壳 + `main_pages` **末尾追加**
- 合并冲突：两边 path 都保留

### 合并前自检

1. 业务改动是否几乎都在 `Home/` HAR？  
2. entry 是否只剩壳 + 最小 Index/依赖增量？  
3. 未删除、未重排他人路由与底栏项  
4. 依赖变更是否已 ohpm install 且能编译  

## UI / 数据约定

- 浅色：背景 `#FFFFFF`，主文字 `#1A1A1A`，次要灰 `#B0B0B0`
- 数据全部 mock
- 运行时图片：`entry/src/main/resources/base/media/`（扁平）
- UI 参考：`design/Home/`，见 `design/README.md`

## 环境

- Windows + DevEco；终端 PowerShell 用 `pwsh`
- ohpm：`DevEco Studio/tools/ohpm/bin/ohpm.bat`
- 主分支 `master`；本职责分支 `home`（已与 master 模块化对齐）

## 增量交付：文档 + Git（强制）

**每完成一小部分可独立验证的功能**，必须立刻：

### 1. 同步开发文档

| 文档 | 何时更新 |
|---|---|
| `docs/Home.md` | **主文档**：进度、目录、变更记录、已知问题 |
| `docs/ROUTE_CONTRACT.md` | 路由 / 依赖模块变化时 |
| `design/README.md` | 设计图变化时 |
| `CLAUDE.md` | 协作 / 模块约定变化时 |

### 2. 同步 Git（本分支本地提交）

1. `git status` / `git diff`：改动在允许范围  
2. 只 stage 相关文件  
3. 中文 commit message  
4. **默认不 push**；推送仅当用户明确要求  

### 何谓「一小部分」

够演示或对照设计截图的一块即可；纯读代码不提交。
