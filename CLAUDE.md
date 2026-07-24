# BlackBox（小黑盒 · 鸿蒙）

HarmonyOS / ArkTS 仿「小黑盒」App。包名 `com.example.blackbox`，DevEco Studio 编译运行。数据全 mock，无真实网络。

## 本分支职责

- **只做首页**：关注 + 推荐（社区内容流，不是游戏库推荐）
- 浅色主题（白底），UI 以真实 App / `design/` 截图为准
- 其它 Tab（热点 / 发布 / 游戏库 / 我）保持占位或他人实现，**不要改**

## 避免 Git 冲突的约束

多人分模块并行（首页 / 热点 / 游戏库等）。原则：**结构约定与主分支一致，业务代码放自己目录；共享文件只做最小增量。**

### 可以放心改（低冲突）

- `entry/src/main/ets/pages/Home/**` — 首页 UI 与子组件
- 首页专用 model / mock（如 `model/HomeModel.ets`、`mock/` 下首页数据）
- **新增** 资源文件（新文件名）：`resources/base/media/` 下首页素材
- 设计对照：`design/Home/`（UI 截图，不参与编译）

### 尽量少碰（高冲突）

| 文件 | 规则 |
|---|---|
| `pages/Index.ets` | 底栏与 Tab 挂载入口。**能不改就不改**；必须改时只动首页挂载点，不重写底栏、不改默认 `bottomTabIndex`、不改游戏库 header |
| `resources/base/profile/main_pages.json` | 路由注册表。**只追加、不重排、不删**已有 path |
| `module.json5` / `AppScope/app.json5` | 全局配置，无必要不改 |
| 全局 `color.json` / `string.json` | 优先新增 key，避免改他人已用的值 |

### 禁止改（他人模块）

- `pages/GameLibrary/**`、`pages/GameDetail/**`
- `pages/Hot/**`、`pages/Me/**`（除非只是确认占位未动）
- `model/GameModel.ets` 等游戏库数据（首页用自己的 model）

### 路由与页面注册

- 首页关注/推荐若是 `Index` 内嵌的 `@Component`（当前 `Home` 模式），**不必**写入 `main_pages.json`
- 仅当需要 `router.pushUrl` 的二级页（帖子详情、用户主页等）时，向 `main_pages.json` 的 `src` **末尾追加** path
- 合并冲突时：两边新增的 path **都保留**

### 目录约定（与主分支对齐）

```
entry/src/main/ets/
├── pages/
│   ├── Index.ets          # 共享入口，少动
│   ├── Home/              # 本分支主战场
│   ├── Hot/               # 他人
│   ├── GameLibrary/       # 他人
│   ├── GameDetail/        # 他人
│   └── Me/                # 他人
└── model/                 # 按模块拆文件，勿往 GameModel 塞首页数据
```

- 新建组件放在 `pages/Home/` 下，命名避免与 `GameLibrary/RecommendTab` 等路径混淆（可用 `FollowFeed`、`HomeRecommend` 等）
- 资源引用方式与现有一致：`$r('app.media.xxx')`
- 不要为「和 master 一致」去重构他人代码；定期 rebase/merge 主分支即可

### 合并前自检

1. `git status`：改动是否几乎都在 `Home/` + 自有 mock/资源？
2. 若动了 `Index.ets` / `main_pages.json`：diff 是否足够小、可手搓合并？
3. 未删除、未重排他人的路由 path 与底栏项

## UI / 数据约定

- 浅色：背景 `#FFFFFF`，主文字 `#1A1A1A`，次要灰 `#B0B0B0` 等，与现有游戏库风格协调
- 数据全部 mock，不接真实 API
- 运行时图片放 `entry/src/main/resources/base/media/`（扁平文件）
- UI 参考截图放 `design/Home/`，见 `design/README.md`

## 环境

- Windows + DevEco；终端 PowerShell 用 `pwsh`
- 主分支一般为 `master`；本职责分支为 `home`

## 增量交付：文档 + Git（强制）

**每完成一小部分可独立验证的功能**（例如：顶栏切好、推荐列表 mock 出来、关注用户条可点），**不要等用户催**，必须立刻做完下面两步再结束本轮或接下一块。

### 1. 同步开发文档

| 文档 | 何时更新 |
|---|---|
| `docs/Home.md` | **主文档**。更新进度表状态、目录/关键文件（若有新增）、变更记录（新在上）、已知问题 |
| `design/README.md` | 仅当设计图增删改或对照说明变化时 |
| 根 `README.md` | 仅当需要对外一句话说明项目时（可选，不强制） |
| `CLAUDE.md` | 仅当协作约束、目录约定、职责变化时 |

变更记录建议格式：

```text
- YYYY-MM-DD · 一句话摘要 · 主要路径 · commit:<短 hash 或待提交>
```

文档只写**事实与进度**，不写长篇设计辩论；路径与真实仓库一致。

### 2. 同步 Git（本分支本地提交）

完成一小块且文档已更新后，**自动在本分支 `home` 做一次本地 commit**（用户已授权此节奏，无需再问「要不要提交」）：

1. `git status` / `git diff`：确认改动几乎都在允许范围内（`Home/`、自有 mock/model/资源、`docs/`、`design/`、必要的最小 `Index`/`main_pages` 增量）
2. 只 stage 相关文件；**不要**提交密钥、本地 IDE 垃圾、`oh_modules` 等
3. 提交信息用中文、说清「做了什么」，例如：`首页：推荐 Tab 圈子横滑与 mock 列表`
4. commit 成功后，把 `docs/Home.md` 变更记录里的 hash 补全（若文档与代码同一次提交，可在 message 或下一条小改里对齐；优先同一次 commit 写好文档）

**默认不 `git push`、不改 remote、不 force**。推送、PR、merge 到 `master` 仅当用户明确要求。

### 何谓「一小部分」

- 够演示或对照 `design/Home/` 某一截图的一块 UI/数据即可
- 不要攒多个互不相关的功能再一次性交；也避免无意义的空提交
- 纯探索/读代码、未改仓库时：**不**提交

### 自检（提交前）

1. 功能点在模拟器或对照设计上可讲清楚
2. `docs/Home.md` 进度与变更记录已反映本次结果
3. `git status` 无误提交文件；diff 符合「避免冲突」约束
