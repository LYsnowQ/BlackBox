# BlackBox

HarmonyOS 游戏社区客户端（小黑盒风格）。采用 **entry 路由壳 + 多 HAR 业务模块** 架构，支持各业务模块独立开发、接入与测试。

- **SDK**：HarmonyOS 6.1.1(24) / Stage 模型  
- **IDE**：DevEco Studio  
- **包管理**：ohpm  

---

## 目录

1. [架构总览](#1-架构总览)  
2. [仓库结构](#2-仓库结构)  
3. [模块职责](#3-模块职责)  
4. [接入业务模块（对接 entry）](#4-接入业务模块对接-entry)  
5. [独立模块开发指南](#5-独立模块开发指南)  
6. [独立测试](#6-独立测试)  
7. [路由契约](#7-路由契约)  
8. [常用命令](#8-常用命令)  
9. [相关文档](#9-相关文档)  

---

## 1. 架构总览

```
┌─────────────────────────────────────────────────────────┐
│  entry（HAP · 唯一入口）                                  │
│  · 底部 Tab 主框架 Index                                  │
│  · @Entry 路由壳页面（注册到 main_pages.json）            │
│  · AppRoutes 全量路径汇总                                 │
└───────────┬─────────────┬─────────────┬─────────────────┘
            │ ohpm 依赖    │             │
   ┌────────▼──┐  ┌───────▼──┐  ┌───────▼──┐  ┌──────────┐
   │  Profile  │  │   Home   │  │   Hot    │  │Gamelibrary│
   │  (HAR)    │  │  (HAR)   │  │  (HAR)   │  │  (HAR)   │
   │  个人中心  │  │  首页    │  │  热点    │  │  游戏库   │
   └───────────┘  └──────────┘  └──────────┘  └──────────┘
```

| 角色 | 类型 | 职责 |
|------|------|------|
| **entry** | HAP `entry` | 应用入口、Ability、页面路由注册、底部导航、挂载各 HAR 导出组件 |
| **业务模块** | HAR | 纯业务 UI / 模型 / 模块内路由契约；**不能**注册 `@Entry` 路由 |

**核心原则**

1. entry **只做路由与壳**：业务实现放在对应 HAR。  
2. 路径字符串只定义在 `*Routes` 契约中，禁止硬编码 `'pages/...'`。  
3. 模块间通过 ohpm `file:` 依赖 + `Index.ets` 导出通信，避免互相直引源码路径。  

---

## 2. 仓库结构

```
BlackBox/
├── AppScope/                 # 应用级资源
├── entry/                    # 主模块 HAP
│   ├── oh-package.json5      # 声明对各 HAR 的依赖
│   └── src/main/
│       ├── ets/
│       │   ├── entryability/
│       │   ├── router/AppRoutes.ets
│       │   └── pages/        # @Entry 壳 + 尚未迁出的页面
│       └── resources/base/profile/main_pages.json
├── Profile/                  # 个人中心 HAR（已接入示例）
├── Home/                     # 首页 HAR
├── Hot/                      # 热点 HAR
├── Gamelibrary/              # 游戏库 HAR
├── docs/
│   ├── ROUTE_CONTRACT.md     # 路由契约说明
│   └── STYLE_GUIDE.md        # 视觉风格
├── build-profile.json5       # 工程模块清单
└── oh-package.json5
```

每个 HAR 的典型布局：

```
{Module}/
├── Index.ets                 # 对外导出（组件 + Routes）
├── oh-package.json5          # name = 包名（小写，如 profile）
├── build-profile.json5
├── hvigorfile.ts
├── src/main/
│   ├── module.json5          # type: "har"
│   ├── ets/
│   │   ├── pages/            # 业务组件（无 @Entry）
│   │   ├── model/            # 数据模型（可选）
│   │   ├── components/       # 通用组件（可选）
│   │   └── router/*Routes.ets
│   └── resources/
└── src/test/                 # 单元测试
```

---

## 3. 模块职责

| 模块目录 | ohpm 包名 | 状态 | 职责 |
|----------|-----------|------|------|
| `entry` | — | 运行中 | 主框架、路由注册、Ability |
| `Profile` | `profile` | **已接入** | 个人中心 Tab、设置/消息/扫一扫/编辑资料 |
| `Home` | `home` | 脚手架 | 首页 Tab 内容（待迁入） |
| `Hot` | `hot` | 脚手架 | 热点 Tab 内容（待迁入） |
| `Gamelibrary` | `gamelibrary` | 脚手架 | 游戏库推荐/榜单、详情跳转契约 |

**Profile 已落地参考**（其他模块按同样方式对齐）：

| 导出 | 用途 |
|------|------|
| `Me` | 底部 Tab「我」内容，由 `Index` 挂载 |
| `SettingsPage` / `MessagesPage` / `ScanPage` / `EditProfilePage` | 子页业务，由 entry 壳挂载 |
| `ProfileRoutes` | 模块路由契约 |

entry 壳示例（`entry/src/main/ets/pages/Profile/Settings.ets`）：

```ts
import { SettingsPage } from 'profile';

@Entry
@Component
struct Settings {
  build() {
    SettingsPage()
  }
}
```

---

## 4. 接入业务模块（对接 entry）

以下以 **Home** 为例；`Hot` / `Gamelibrary` 同理。Profile 已完成，可作为对照。

### 4.1 确认工程已登记模块

根目录 `build-profile.json5` 的 `modules` 中需有对应项（DevEco 创建 HAR 时一般已写入）：

```json5
{
  "name": "Home",
  "srcPath": "./Home"
}
```

### 4.2 entry 声明依赖

编辑 `entry/oh-package.json5`：

```json5
{
  "name": "entry",
  "version": "1.0.0",
  "dependencies": {
    "profile": "file:../Profile",
    "home": "file:../Home",
    "hot": "file:../Hot",
    "gamelibrary": "file:../Gamelibrary"
  }
}
```

> 包名必须与 HAR 的 `oh-package.json5` 里 `"name"` 一致（小写）。

在工程根或 `entry` 下执行：

```bash
ohpm install
```

成功后 `entry/oh_modules/` 会出现指向各 HAR 的软链。

### 4.3 HAR 侧导出业务入口

在 `Home/Index.ets` 中导出要给 entry 用的组件与路由：

```ts
export { HomePage } from './src/main/ets/pages/HomePage';
export { HomeRoutes } from './src/main/ets/router/HomeRoutes';
```

### 4.4 entry 挂载 Tab 内容

`entry/src/main/ets/pages/Index.ets`：

```ts
import { HomePage } from 'home';
// ...
} else if (this.bottomTabIndex === 0) {
  HomePage()
}
```

### 4.5 注册子页面路由（如有）

HAR **不能**使用 `@Entry`。子页面必须在 entry 增加壳 + 写入 `main_pages.json`。

**① 路由契约**（`Home/src/main/ets/router/HomeRoutes.ets`）：

```ts
export class HomeRoutes {
  static readonly SEARCH: string = 'pages/Home/Search';
}
```

同步 `entry/src/main/ets/router/AppRoutes.ets`：

```ts
static readonly HOME_SEARCH: string = 'pages/Home/Search';
```

**② entry 壳** `entry/src/main/ets/pages/Home/Search.ets`：

```ts
import { SearchPage } from 'home';

// @Entry 的 build 根节点必须是容器（Column/Row/Stack 等），不能直接放自定义组件
@Entry
@Component
struct Search {
  build() {
    Column() {
      SearchPage()
    }
    .width('100%')
    .height('100%')
  }
}
```

**③** `entry/src/main/resources/base/profile/main_pages.json`：

```json
{
  "src": [
    "pages/Index",
    "pages/Home/Search"
  ]
}
```

**④** 业务内跳转只用契约：

```ts
import { HomeRoutes } from '../router/HomeRoutes';
router.pushUrl({ url: HomeRoutes.SEARCH });
```

### 4.6 接入 checklist

- [ ] `build-profile.json5` 含该模块  
- [ ] HAR `oh-package.json5` 的 `name` 正确  
- [ ] `entry/oh-package.json5` 增加 `file:../Xxx` 依赖  
- [ ] `ohpm install`  
- [ ] `Index.ets` 导出组件 / `*Routes`  
- [ ] entry 的 `Index` 或壳页面 `import { ... } from '包名'`  
- [ ] 子页：契约 → 壳 → `main_pages.json`  
- [ ] 全量编译运行验证  

---

## 5. 独立模块开发指南

### 5.1 开发边界

| 可以在 HAR 内做 | 必须在 entry 做 |
|-----------------|-----------------|
| `@Component` 业务 UI | `@Entry` 页面注册 |
| model / mock 数据 | `main_pages.json` |
| 模块内 `*Routes` 声明与 `pushUrl` | Ability / 权限申请 |
| 单元测试 `src/test` | 最终打包签名发布 |
| 样式与交互迭代 | 跨模块依赖编排 |

### 5.2 推荐开发流程

1. **在本模块目录改代码**  
   例如只改 `Profile/src/main/ets/pages/*`，不要把业务写回 `entry/pages`。

2. **通过 Index.ets 控制对外 API**  
   未导出的文件视为模块私有，entry 不应 import 深层路径。

3. **路由只改契约**  
   新增路径：先改 `*Routes` → 再改 entry 壳与 `main_pages` → 最后改跳转调用。

4. **与 entry 联调**  
   依赖 `file:` 后修改 HAR 源码即生效（软链），无需每次重新 publish。  
   若 ohpm 缓存异常，可在 `entry` 下重新 `ohpm install`。

5. **避免循环依赖**  
   HAR 之间尽量不互相依赖；共享能力后续可抽 `common` HAR。  
   当前业务 HAR **不要** 依赖 entry。

### 5.3 按模块说明

#### Profile（参考实现 · 已接入）

```
Profile/src/main/ets/
├── model/ProfileModel.ets
├── pages/
│   ├── Me.ets              # Tab 内容
│   ├── DataTab / DynamicTab / PlatformPanel
│   ├── SettingsPage.ets    # 子页内容（非 @Entry）
│   ├── MessagesPage.ets
│   ├── ScanPage.ets
│   └── EditProfilePage.ets
└── router/ProfileRoutes.ets
```

- 开发：直接改 `Profile/` 下文件。  
- 联调：运行 entry，底部切到「我」。  
- 子页：设置 / 消息 / 扫一扫 / 编辑资料，路径见 [路由契约](#7-路由契约)。

#### Home / Hot

- 当前为脚手架（`MainPage` 占位）。  
- 建议：将 `entry/src/main/ets/pages/Home/Home.ets`、`Hot/Hot.ets` 迁入对应 HAR 的 `pages/`，export 后在 `Index` 用 `import { ... } from 'home' | 'hot'` 替换。  
- 暂无子路由时，只需完成 §4.1–4.4。

#### Gamelibrary

- 建议迁入：推荐 Tab、榜单 Tab、游戏详情 UI。  
- 详情路径已在契约中：`GameLibraryRoutes.GAME_DETAIL` → `pages/GameDetail/GameDetail`。  
- 详情若仍带 `@Entry`，壳可留在 entry，UI 下沉到 HAR 的 `GameDetailPage`。

### 5.4 新建 HAR 模块（从零）

1. DevEco：**File → New → Module → Static Library (HAR)**，命名如 `Search`。  
2. 确认 `build-profile.json5` 与 `oh-package.json5`（`name` 小写）。  
3. 建立 `src/main/ets/pages`、`router`，编写 `Index.ets` 导出。  
4. 按 [§4](#4-接入业务模块对接-entry) 接入 entry。  

---

## 6. 独立测试

### 6.1 单元测试（HAR 自测，不依赖真机 UI）

每个 HAR 自带 Hypium 模板：

```
{Module}/src/test/
├── List.test.ets
└── LocalUnit.test.ets
```

**编写建议**

- 把可测逻辑抽到 **非 UI** 的 `.ets`（如 `model/`、`utils/`）。  
- UI 组件（`@Component`）不适合单元测试，用 mock 数据 + 纯函数测业务规则。

**运行（DevEco）**

1. 打开对应模块下的测试文件。  
2. 右键 → **Run** / 使用测试运行配置。  
3. 或对模块执行本地单元测试任务（以 IDE 中 hvigor 任务为准）。

**命令行示例**（路径随本机 DevEco 安装位置调整）：

```bash
# 在工程根目录，按模块编译/测（需本机 hvigor 环境）
hvigorw -p module=Profile@default -p product=default assembleHar
```

### 6.2 模块联调测试（推荐日常）

1. entry 已依赖该 HAR 且 `ohpm install` 成功。  
2. DevEco 选 **entry** 为运行目标，启动模拟器/真机。  
3. 验证：  
   - Tab 是否渲染 HAR 导出组件  
   - 子页跳转 / 返回  
   - 契约路径是否与 `main_pages` 一致  

### 6.3 路由壳冒烟清单

| 步骤 | 预期 |
|------|------|
| 冷启动 | 进入 `AppRoutes.INDEX` |
| 切到底部「我」 | 显示 `profile` 的 `Me` |
| 点设置 / 消息 / 扫一扫 | 进入对应壳页，UI 来自 Profile |
| 设置 → 编辑资料 | `ProfileRoutes.EDIT_PROFILE` |
| 返回键 | 逐级 `router.back()` |
| 游戏库进详情 | `AppRoutes.GAME_DETAIL` + `params.id` |

### 6.4 仅编译某个 HAR

不跑整包时，可只组装 HAR，确认模块自身无编译错误：

```bash
hvigorw -p module=Profile@default assembleHar
hvigorw -p module=Home@default assembleHar
hvigorw -p module=Hot@default assembleHar
hvigorw -p module=Gamelibrary@default assembleHar
```

entry 整包：

```bash
hvigorw -p module=entry@default -p product=default assembleHap
```

### 6.5 测试注意点

- HAR 修改后若 entry 仍用旧类型，先 **Rebuild** 或重新 `ohpm install`。  
- `main_pages.json` 路径与磁盘文件路径不一致会导致运行期白屏/找不到页面。  
- 契约常量改名后，全局搜索旧字符串，避免残留硬编码。  

---

## 7. 路由契约

详细说明见 [`docs/ROUTE_CONTRACT.md`](docs/ROUTE_CONTRACT.md)。

**当前路径速查**

| 常量 | 路径 |
|------|------|
| `AppRoutes.INDEX` | `pages/Index` |
| `AppRoutes.GAME_DETAIL` | `pages/GameDetail/GameDetail` |
| `ProfileRoutes.SETTINGS` | `pages/Profile/Settings` |
| `ProfileRoutes.MESSAGES` | `pages/Profile/Messages` |
| `ProfileRoutes.SCAN` | `pages/Profile/Scan` |
| `ProfileRoutes.EDIT_PROFILE` | `pages/Profile/EditProfile` |

**新增路由固定 5 步**

1. 模块 `*Routes` 加常量  
2. `AppRoutes` 镜像（entry 需要时）  
3. entry 增加 `@Entry` 壳  
4. 写入 `main_pages.json`  
5. 业务只引用契约常量  

---

## 8. 常用命令

```bash
# 安装 / 更新 entry 对 HAR 的本地依赖
cd entry && ohpm install

# 整包构建（DevEco 或 hvigorw）
hvigorw clean
hvigorw assembleApp

# 单 HAR 组装
hvigorw -p module=Profile@default assembleHar
```

ohpm / hvigor 一般位于 DevEco 安装目录，例如：

- `DevEco Studio/tools/ohpm/bin/ohpm`  
- `DevEco Studio/tools/hvigor/bin/hvigorw`  

---

## 9. 相关文档

| 文档 | 内容 |
|------|------|
| [`docs/ROUTE_CONTRACT.md`](docs/ROUTE_CONTRACT.md) | 路由契约原则、路径表、checklist |
| [`docs/STYLE_GUIDE.md`](docs/STYLE_GUIDE.md) | 全 App 视觉与文案气质 |

---

## 贡献约定（简）

1. **业务进 HAR，路由进 entry。**  
2. **路径只走 `*Routes`。**  
3. **对外 API 只从模块 `Index.ets` 导出。**  
4. **视觉遵循 `STYLE_GUIDE.md`。**  
5. **改契约必改壳与 `main_pages.json`，并做 §6.3 冒烟。**  
