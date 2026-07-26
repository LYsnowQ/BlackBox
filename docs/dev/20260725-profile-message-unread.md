# 20260725-Profile-消息未读角标

## 行为

| 场景 | 效果 |
|------|------|
| 会话有未读 | 列表行右侧红色数字角标（1–99，>99 为 `99+`） |
| 点击进入会话 | `markSessionRead` → `unreadCount = 0`，角标消失 |
| 收到新消息（mock） | `receiveIncomingMessage` → `unreadCount + 1`，刷新 preview/time |
| Me 页 ✉ | 展示全部会话未读合计 |

## API

- `markSessionRead(sessionId)` / `markSessionReadSync`
- `receiveIncomingMessage(sessionId, content)` — mock 对方消息
- `fetchUnreadTotal` / `getUnreadTotalSync`
- `formatUnreadBadge(count)`

会话状态保存在 `MessageApi` 的 `sessionRuntimes`（会话级未读 / 预览 / 时间）。

## 演示

1. 消息列表：**长按**某会话 → 模拟新消息，角标 +1  
2. **点击**该会话 → 进入聊天，角标清零  
3. 返回列表 → entry 壳 `onPageShow` 递增 `refreshToken` 刷新  
4. 聊天页：**长按标题** → 模拟新消息（当前会话内立即已读，仅追加气泡）

## 涉及文件

- `model/types/MessageModel.ets` — `unreadCount`
- `model/mock/MessageMock.ets` — 初始未读数
- `api/MessageApi.ets` — 运行时未读
- `pages/MessagesPage.ets` / `ChatPage.ets` / `Me.ets`
- `entry/.../pages/Profile/Messages.ets` — `refreshToken`
