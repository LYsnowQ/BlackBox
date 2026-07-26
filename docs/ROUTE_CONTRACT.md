# 路由契约（Route Contract）

模块化后，**路径字符串只在契约中定义一次**。业务代码禁止硬编码 `pages/...`。

## 原则

1. **entry 注册**：`main_pages.json` + `@Entry` 壳页面路径 = 契约常量值  
2. **HAR 声明**：各业务模块 `*Routes` 为本模块权威来源  
3. **entry 汇总**：`AppRoutes` 镜像全量路径，供 entry 内跳转与壳页对照  
4. **命名**：`pages/{Module}/{Page}`，与 `entry/src/main/ets/pages/` 目录一致  

## 契约文件

| 模块 | 契约 | 包名 |
|------|------|------|
| entry | `entry/src/main/ets/router/AppRoutes.ets` | — |
| Profile | `Profile/src/main/ets/router/ProfileRoutes.ets` | `profile` |
| Gamelibrary | `Gamelibrary/src/main/ets/router/GameLibraryRoutes.ets` | `gamelibrary` |
| Home | `Home/src/main/ets/router/HomeRoutes.ets` | `home` |
| Hot | `Hot/src/main/ets/router/HotRoutes.ets` | `hot` |

## 当前路径表

| 常量 | 路径 | 说明 |
|------|------|------|
| `AppRoutes.INDEX` | `pages/Index` | 主框架 / 底部 Tab |
| `AppRoutes.GAME_LIBRARY` | `pages/GameLibrary/GameLibrary` | 游戏库独立页（若使用） |
| `AppRoutes.GAME_DETAIL` / `GameLibraryRoutes.GAME_DETAIL` | `pages/GameDetail/GameDetail` | 游戏详情 `params: { id }` |
| `AppRoutes.HOME_POST_DETAIL` / `HomeRoutes.POST_DETAIL` | `pages/Home/PostDetail` | 帖子详情 `params: { id, tab? }` |
| `AppRoutes.HOT_NEWS_DETAIL` / `HotRoutes.NEWS_DETAIL` | `pages/Hot/HotNewsDetail` | 热点新闻详情 `params: { id, themeMode? }` |
| `AppRoutes.PROFILE_SETTINGS` / `ProfileRoutes.SETTINGS` | `pages/Profile/Settings` | 设置 |
| `AppRoutes.PROFILE_MESSAGES` / `ProfileRoutes.MESSAGES` | `pages/Profile/Messages` | 消息 |
| `AppRoutes.PROFILE_SCAN` / `ProfileRoutes.SCAN` | `pages/Profile/Scan` | 扫一扫 |
| `AppRoutes.PROFILE_EDIT` / `ProfileRoutes.EDIT_PROFILE` | `pages/Profile/EditProfile` | 编辑资料 |
| `AppRoutes.PROFILE_CHAT` / `ProfileRoutes.CHAT` | `pages/Profile/Chat` | 消息聊天 `params: { id }` |

## 使用示例

```ts
// Home 模块内
import { HomeRoutes } from '../router/HomeRoutes';
router.pushUrl({ url: HomeRoutes.POST_DETAIL, params: { id } });

// entry 内
import { AppRoutes } from '../../router/AppRoutes';
router.pushUrl({ url: AppRoutes.GAME_DETAIL, params: { id } });
```

## 新增路由 checklist

1. 在对应模块 `*Routes` 增加常量  
2. 在 `AppRoutes` 同步镜像（若 entry 需要）  
3. 在 `entry/src/main/ets/pages/...` 增加 `@Entry` 壳（HAR 无法注册路由）  
4. 写入 `entry/src/main/resources/base/profile/main_pages.json`  
5. 业务页只引用契约常量，不写裸字符串  
