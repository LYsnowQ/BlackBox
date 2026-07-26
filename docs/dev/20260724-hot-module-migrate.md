# 20260724-hot-module-migrate

## 背景

项目已将 **Profile / Gamelibrary** 业务迁入独立 HAR 模块，entry 只保留 `@Entry` 路由壳与主框架。  
热点（wgl）此前仍落在 `entry/src/main/ets/pages/Hot` 与 `entry/.../model/HotModel.ets`，与模块化约定不一致。  
本次将 **Hot 页面与模型统一迁入 `Hot` HAR**，对齐 [docs/ROUTE_CONTRACT.md](../ROUTE_CONTRACT.md)。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Hot/src/main/ets/pages/Hot/Hot.ets` | 热点 Tab 业务组件（自 entry 迁入） |
| `Hot/src/main/ets/pages/Hot/HotNewsDetail.ets` | 新闻详情业务组件（去掉 `@Entry`，改为 `export struct`） |
| `Hot/src/main/ets/pages/Hot/HotTheme.ets` | 主题色 light/dark |
| `Hot/src/main/ets/model/HotModel.ets` | 类型 + Mock + `getHotNewsById` / `getAllFeedNews` |
| `Hot/src/main/ets/router/HotRoutes.ets` | 路由契约 `NEWS_DETAIL` |
| `Hot/Index.ets` | 对外导出 `Hot` / `HotNewsDetail` / 模型 / 主题 / `HotRoutes` |
| `entry/src/main/ets/pages/Hot/HotNewsDetail.ets` | **路由壳**（`@Entry`，挂载 `hot.HotNewsDetail`） |
| `entry/src/main/ets/pages/Index.ets` | Tab 挂载改为 `import { Hot } from 'hot'` |
| `entry/oh-package.json5` | 增加依赖 `"hot": "file:../Hot"` |
| `entry/src/main/resources/base/profile/main_pages.json` | 注册 `pages/Hot/HotNewsDetail` |
| `entry/src/main/ets/router/AppRoutes.ets` | 镜像 `HOT_NEWS_DETAIL` |
| `docs/ROUTE_CONTRACT.md` | 路径表补充 Hot 详情 |

### 已删除（迁出 entry）

| 原路径 | 说明 |
|--------|------|
| `entry/src/main/ets/pages/Hot/Hot.ets` | 业务已在 HAR |
| `entry/src/main/ets/pages/Hot/HotTheme.ets` | 业务已在 HAR |
| `entry/src/main/ets/model/HotModel.ets` | 业务已在 HAR |

## 实现说明

### 1. 边界（与 Gamelibrary / Profile 一致）

| 层级 | 职责 |
|------|------|
| **Hot HAR** | 全部业务 UI、Mock 模型、主题、模块内 `pushUrl` 用的 `HotRoutes` |
| **entry** | `main_pages.json` 注册、`@Entry` 壳、`Index` 底部 Tab 挂载、`AppRoutes` 汇总 |

HAR **不能**注册路由页，因此独立路由页必须在 entry 留一层薄壳：

```ts
// entry/.../pages/Hot/HotNewsDetail.ets
import { HotNewsDetail as HotNewsDetailComponent } from 'hot';

@Entry
@Component
struct HotNewsDetail {
  build() {
    Column() {
      HotNewsDetailComponent()
    }
    .width('100%')
    .height('100%')
  }
}
```

> 注意：`@Entry` 的 `build` 根节点必须是容器组件，不能直接放自定义组件。

### 2. 路由契约

- 模块内权威：`HotRoutes.NEWS_DETAIL = 'pages/Hot/HotNewsDetail'`
- entry 镜像：`AppRoutes.HOT_NEWS_DETAIL`（同路径）
- `Hot.openNews` 改为 `router.pushUrl({ url: HotRoutes.NEWS_DETAIL, params: { id, themeMode } })`，禁止硬编码路径

### 3. 包依赖

- 工程级 `build-profile.json5` 已有 `Hot` 模块条目（此前骨架）
- `entry/oh-package.json5` 增加 `"hot": "file:../Hot"`（包名小写 `hot`，与 `profile` / `gamelibrary` 一致）
- 本地若 lock 未更新，在工程根或 entry 执行一次 `ohpm install`

### 4. 热点 Tab 不走 router

与迁前相同：`Index` 底部 Tab 直接挂载 `Hot()` 组件，不注册 `pages/Hot/Hot` 为独立路由页。

## 验证方式

1. `ohpm install`（entry 依赖 `hot` 后）
2. DevEco 编译 entry：无找不到 `hot` / 找不到 `HotModel` 等错误
3. 运行 App → 底部「热点」：全部 / 热榜 / 待开发占位正常
4. 点击新闻进入详情：正文 / 评论 / 返回正常
5. 详情顶栏与底栏主题仍随 `themeMode`（列表页 ✉️ 切换 light/dark 后进详情应带上 params）

## 已知限制 / 后续

- UI 参考截图仍在 `docs/ui-refs/02-hot/` 与历史路径说明中；`entry/.../Hot/Screen` 若存在仅作参考，不参与编译
- `Hot/src/main/ets/components/MainPage.ets` 仍为 HAR 脚手架占位，可后续删除或忽略
- Home 模块尚未迁完业务时，勿照搬本迁移改坏 Index 的 Home 引用
- 旧文档 `20260724-hot-feed-detail.md` / `20260724-hot-light-theme.md` 中路径仍写 entry，以本文为准

## 目录对照（迁后）

```
Hot/
  Index.ets                          # 导出
  src/main/ets/
    model/HotModel.ets
    pages/Hot/{Hot,HotNewsDetail,HotTheme}.ets
    router/HotRoutes.ets

entry/
  oh-package.json5                   # hot 依赖
  src/main/ets/
    pages/Index.ets                  # import { Hot } from 'hot'
    pages/Hot/HotNewsDetail.ets      # 仅路由壳
    router/AppRoutes.ets             # HOT_NEWS_DETAIL
  src/main/resources/.../main_pages.json
```
