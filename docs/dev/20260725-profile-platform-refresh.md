# 20260725-Profile-平台卡片切换刷新

## 背景

平台资料卡片切换 Tab 时：
1. 未绑定输入框 placeholder 固定为 Switch 文案
2. 已绑定卡片的昵称 / 数据 / 好友不随平台更新

根因均为 ArkUI **同构子树节点复用**：`@Builder` 入参变化不一定驱动 Text / ForEach 重绘；`TextInput.placeholder` 尤其容易残留。

## 修复（PlatformPanel）

### 第一轮（不足）
- 仅 `@State` + `.key`：同为 bound 的 steam↔ps 仍可能复用

### 第二轮（当前）
- 展示字段全部 `@State`，切换走 `applyPlatform`
- 内容区 `ForEach([viewToken])`，token = `platformId_bound|free`，**销毁重建**
- 已绑定区拆成独立组件 `PlatformBoundBody` + `@Prop`（不用易复用的 @Builder 入参对象）
- 未绑定区读 `@State inputHint / platformName`，随 token 重建

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
