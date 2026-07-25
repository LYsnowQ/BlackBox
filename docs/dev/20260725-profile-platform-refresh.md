# 20260725-Profile-平台卡片切换刷新

## 背景

平台资料卡片切换 Tab 时：
1. 未绑定输入框 placeholder 固定为 Switch 文案
2. 已绑定卡片的昵称 / 数据 / 好友不随平台更新

根因均为 ArkUI **同构子树节点复用**：`@Builder` 入参变化不一定驱动 Text / ForEach 重绘；`TextInput.placeholder` 尤其容易残留。

## 修复（PlatformPanel）

- 切换 / 绑定时 `syncPlatformView`：把平台 id、绑定态、账号字段、好友列表写入 **@State**
- 内容区 `.key(platformId + bound|free)` 强制重建
- 绑定输入框 `.key` + `@State bindPlaceholder`

## 全模块同类风险排查

| 位置 | 风险 | 结论 |
|------|------|------|
| `PlatformPanel` | 平台切换复用 | **已修** |
| `GameLibrarySection` | 筛选切换列表 | `navKey` 等为 @State，ForEach key 含筛选维度，**OK** |
| `Me` 数据/动态 | Tab 切换 | `if/else` 整树替换，**OK** |
| `ChatPage` | 会话消息 | `messages` 为 @State，**OK** |
| `MessagesPage` | 列表 | mock 静态，无运行时切换源，**低风险** |
| `DataTab` / `EditProfile` | 用户资料 | 未写回共享 model，编辑保存不反映到个人卡（产品债，非复用 bug） |
| `SettingsPage` / `ScanPage` | 静态 | **无** |

## 验证

1. steam（已绑）↔ ps（已绑）：昵称、时长、好友头像变化  
2. steam ↔ switch/xbox/epic（未绑）：出现对应 placeholder  
3. 在 switch 绑定任意 id：切到已绑卡片且展示输入名  
