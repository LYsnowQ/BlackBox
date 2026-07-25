# 路由契约（Route Contract）

模块化后，**路径字符串只在契约中定义一次**。业务代码禁止硬编码 `pages/...`。

## 原则

1. **entry 注册**：`main_pages.json` + `@Entry` 壳页面路径 = 契约常量值  
2. **HAR 声明**：各业务模块 `*Routes` 为本模块权威来源  
3. **entry 汇总**：`AppRoutes` 镜像全量路径，供 entry 内跳转与壳页对照  
4. **命名**：`pages/{Module}/{Page}`，与 `entry/src/main/ets/pages/` 目录一致  
5. **依赖**：entry 通过 `oh-package.json5` 引用本地 HAR（`file:../Xxx`），改依赖后 `ohpm install`

## 契约文件

| 模块 | 契约 | 包名 | 业务位置 |
|------|------|------|----------|
| entry | `entry/src/main/ets/router/AppRoutes.ets` | — | 壳 + Index |
| Home | `Home/src/main/ets/router/HomeRoutes.ets` | `home` | `Home/src/main/ets/**` |
| Profile | `Profile/src/main/ets/router/ProfileRoutes.ets` | `profile` | `Profile/src/main/ets/**` |
| Gamelibrary | `Gamelibrary/src/main/ets/router/GameLibraryRoutes.ets` | `gamelibrary` | `Gamelibrary/src/main/ets/**` |
| Hot | `Hot/src/main/ets/router/HotRoutes.ets` | `hot` | 业务多仍在 entry Hot（待迁） |

## main_pages.json 当前注册（entry）

| 路径 | 说明 |
|------|------|
| `pages/Index` | 主框架 / 底部 Tab |
| `pages/GameLibrary/GameLibrary` | 游戏库独立页壳 |
| `pages/GameDetail/GameDetail` | 游戏详情壳 |
| `pages/Home/PostDetail` | 帖子详情壳 |
| `pages/Profile/Settings` | 设置 |
| `pages/Profile/Messages` | 消息 |
| `pages/Profile/Scan` | 扫一扫 |
| `pages/Profile/EditProfile` | 编辑资料 |
| `pages/Home/Search` | 首页搜索壳 |

冲突合并时：**只追加、不重排、不删**；两边新增 path **都保留**。

## 契约常量对照

| 常量 | 路径 | 说明 |
|------|------|------|
| `AppRoutes.INDEX` | `pages/Index` | 主框架 |
| `AppRoutes.GAME_LIBRARY` | `pages/GameLibrary/GameLibrary` | 游戏库页 |
| `AppRoutes.GAME_DETAIL` / `GameLibraryRoutes.GAME_DETAIL` | `pages/GameDetail/GameDetail` | 详情 `params: { id }` |
| `AppRoutes.HOME_POST_DETAIL` / `HomeRoutes.POST_DETAIL` | `pages/Home/PostDetail` | 帖子 `params: { id, tab? }` |
| `AppRoutes.HOME_SEARCH` / `HomeRoutes.SEARCH` | `pages/Home/Search` | 首页搜索 |
| `AppRoutes.PROFILE_SETTINGS` / `ProfileRoutes.SETTINGS` | `pages/Profile/Settings` | 设置 |
| `AppRoutes.PROFILE_MESSAGES` / `ProfileRoutes.MESSAGES` / `HomeRoutes.MESSAGES` | `pages/Profile/Messages` | 消息（首页顶栏复用） |
| `AppRoutes.PROFILE_SCAN` / `ProfileRoutes.SCAN` | `pages/Profile/Scan` | 扫一扫 |
| `AppRoutes.PROFILE_EDIT` / `ProfileRoutes.EDIT_PROFILE` | `pages/Profile/EditProfile` | 编辑资料 |

## Index 与包引用（现状）

```ts
import { Home } from 'home';
import { RecommendTab, RankingTab } from 'gamelibrary';
import { Me } from 'profile';
// Hot 仍可能来自 entry 本地组件
```

## 使用示例

```ts
// Home 模块内
import { HomeRoutes } from '../router/HomeRoutes';
router.pushUrl({ url: HomeRoutes.POST_DETAIL, params: { id } });

// entry 内
import { AppRoutes } from '../router/AppRoutes';
router.pushUrl({ url: AppRoutes.GAME_DETAIL, params: { id } });
```

## 新增路由 checklist

1. 在对应模块 `*Routes` 增加常量  
2. 在 `AppRoutes` 同步镜像（若 entry 需要）  
3. 在 `entry/src/main/ets/pages/...` 增加 `@Entry` 壳（HAR 无法注册路由）  
4. 写入 `main_pages.json`（末尾追加）  
5. 业务页只引用契约常量，不写裸字符串  
6. 若新 HAR：写入 `build-profile.json5` + `entry/oh-package.json5` 后 `ohpm install`  
