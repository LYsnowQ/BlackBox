# 20260725-Profile-消息聊天页

## 背景

个人中心邮件/消息列表已有，需补齐会话详情（私信气泡 + 系统通知流），打通「我 → 消息 → 聊天」。

## 涉及文件

| 路径 | 说明 |
|------|------|
| `Profile/src/main/ets/model/ProfileModel.ets` | 会话 / 聊天 mock、查询函数 |
| `Profile/src/main/ets/pages/MessagesPage.ets` | 列表接 mock，点击进聊天 |
| `Profile/src/main/ets/pages/ChatPage.ets` | 聊天页业务 UI |
| `Profile/src/main/ets/router/ProfileRoutes.ets` | `CHAT` 契约 |
| `Profile/Index.ets` | 导出 `ChatPage` |
| `entry/src/main/ets/pages/Profile/Chat.ets` | 路由壳 |
| `entry/src/main/ets/router/AppRoutes.ets` | 镜像 `PROFILE_CHAT` |
| `entry/.../main_pages.json` | 末尾追加 `pages/Profile/Chat` |
| `docs/ROUTE_CONTRACT.md` | 契约表 |

## 实现说明

- 消息列表统一为 `MessageSession`（含私信与系统/互动/活动/订单）。
- 聊天页 `params: { id }`；私信 `type === 'chat'` 显示输入框，可本地追加气泡；系统类底部提示「系统消息不可回复」。
- 气泡：己方浅绿右对齐，对方白底 + 头像左对齐；`showTime` 控制时间分隔。
- 路由按契约五步：Routes → AppRoutes → 壳 → main_pages → 业务只引常量。

## 验证方式

1. 底部 Tab「我」→ 点 ✉ 进入消息列表。
2. 点「潮声未歇」等私信：进入聊天，可发送本地消息。
3. 点「系统通知 / 互动消息」：只读通知流，无输入框。
4. 返回栈：聊天 → 消息 → 我。

## 已知限制 / 后续

- 全部 mock，无真实推送/已读同步。
- 发送仅本地 state，离开页面后不持久化。
- 未做会话搜索、长按、图片消息。
