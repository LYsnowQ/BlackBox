# 20260726-Profile-设置页样式与二级页补全

## 背景

设置列表卡片右侧箭头/辅助信息过于贴边；卡片使用 `width('100%') + margin left/right` 导致总宽度超出父容器，右侧被裁切后圆角看起来像直角。同时多数设置项点击无落地页。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Profile/.../pages/SettingsPage.ets` | 布局修复：外层 padding，卡片不再叠加横向 margin；补全跳转/清除缓存/退出 |
| `Profile/.../pages/AccountSecurityPage.ets` | 账号与安全 |
| `Profile/.../pages/PrivacySettingsPage.ets` | 隐私设置（开关） |
| `Profile/.../pages/BlacklistPage.ets` | 黑名单 mock |
| `Profile/.../pages/NotificationSettingsPage.ets` | 消息通知开关 |
| `Profile/.../pages/DarkModePage.ets` | 深色模式三选一（演示） |
| `Profile/.../pages/AboutPage.ets` | 关于小黑盒 |
| `Profile/.../router/ProfileRoutes.ets` | 6 条设置二级路由 |
| `Profile/Index.ets` | 导出新页面 |
| `entry/.../pages/Profile/*.ets` | 6 个 @Entry 壳 |
| `entry/.../router/AppRoutes.ets` | 镜像路径 |
| `entry/.../profile/main_pages.json` | **末尾追加** 6 条 path |
| `docs/ROUTE_CONTRACT.md` | 契约表 |

## 实现说明

### 布局

- **原因**：子节点 `width: 100%` 再加 `margin: { left: 16, right: 16 }` → 实际占位 `100% + 32`，右侧溢出；`borderRadius + clip` 只裁到父宽，视觉上左侧圆、右侧直角。
- **改法**：Scroll 内容区统一 `padding({ left: 16, right: 16 })`，卡片仅 `width('100%')` + `borderRadius(14)`；行内右侧 `padding right: 14`，箭头固定宽 16。

### 二级页

| 入口 | 路由 | 行为 |
|------|------|------|
| 编辑个人资料 | 已有 `EDIT_PROFILE` | 不变 |
| 账号与安全 | `ACCOUNT_SECURITY` | 列表 + toast 演示 |
| 隐私设置 | `PRIVACY` | Toggle 本地状态 |
| 黑名单 | `BLACKLIST` | mock 列表，可移出 |
| 消息通知 | `NOTIFICATION` | 总开关联动子项 |
| 清除缓存 | 弹窗确认 | 缓存文案置 `0 MB` |
| 深色模式 | `DARK_MODE` | 三选一，不改全局主题 |
| 关于小黑盒 | `ABOUT` | 版本与协议入口（演示） |
| 退出登录 | 弹窗确认 | toast 后返回 |

## 验证方式

1. 「我」→ 设置：分组卡片左右圆角对称，右侧箭头不贴屏幕边  
2. 点击各带箭头项可进入对应页并返回  
3. 清除缓存 / 退出登录弹窗可确认或取消  
4. `main_pages.json` 仅追加，未重排他人 path  

## 已知限制 / 后续

- 深色模式选择未写入全局主题 / AppStorage  
- 账号绑定、协议正文等仍为 toast / mock  
- 清除缓存为本地文案演示，无真实文件清理  
