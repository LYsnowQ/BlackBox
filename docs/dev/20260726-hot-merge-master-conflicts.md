# 20260726-hot-merge-master-conflicts

## 背景

`wgl` 合并 `master` 后编译失败：

1. `main_pages.json` 残留 `<<<<<<<` → JSON5 语法错误 `00305008`
2. Hot 模块目录结构冲突：本分支 `pages/Hot/*`，master 扁平 `pages/Hot.ets` 等

约束：只读对照 master，不改 master；本分支及时 commit、不 push。

## 冲突与处理

| 路径 | 策略 |
|------|------|
| `Hot/Index.ets` | 保留本分支：`pages/Hot/Hot` / `HotNewsDetail` / `HotTheme` |
| `Hot/src/main/ets/pages/Hot/*` | **ours** 业务目录（含剑星频道） |
| `Hot/src/main/ets/pages/Hot.ets` 等扁平文件 | **删除**（master 路径） |
| `Hot/src/main/ets/router/HotRoutes.ets` | 保留本分支注释 + `NEWS_DETAIL` |
| `entry/.../Hot/HotNewsDetail.ets` | 壳页 `HotNewsDetailComponent` |
| `entry/.../main_pages.json` | **双方 path 都保留**：`HotNewsDetail` + `Profile/Chat`（去重） |
| `entry/.../AppRoutes.ets` | Hot 详情 + Profile Chat 并存，去掉重复 `HOT_NEWS_DETAIL` |
| `docs/ROUTE_CONTRACT.md` | 两行都保留 |
| `entry/oh-package.json5` | 去掉重复 `"hot"` 键 |

## 验证

1. 仓库内无 `<<<<<<<` / `=======` / `>>>>>>>`
2. `main_pages.json` 可被 JSON 解析
3. Hot 仅 `pages/Hot/{Hot,HotNewsDetail,HotTheme}.ets`
4. DevEco Rebuild：PreBuild / CompileResource 不再因冲突标记失败

## 已知限制

- 未改 Profile / Gamelibrary 业务逻辑（随 merge 进入）
- 未 push
