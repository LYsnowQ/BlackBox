# 20260725-Profile-API 与 Mock 分层

## 背景

`ProfileModel.ets` 混杂类型、mock 数据、查询函数，不利于后续接真实网络。需要结构化拆分。

## 目录结构

```
Profile/src/main/ets/
├── api/                         # 接口契约 + mock 实现
│   ├── ApiTypes.ets             # ApiResult / apiOk / apiFail
│   ├── UserApi.ets
│   ├── PlatformApi.ets
│   ├── LibraryApi.ets
│   ├── FeedApi.ets
│   ├── MessageApi.ets
│   └── index.ets
├── model/
│   ├── types/                   # 纯类型 / 请求 DTO
│   │   ├── UserModel.ets
│   │   ├── PlatformModel.ets
│   │   ├── LibraryModel.ets
│   │   ├── FeedModel.ets
│   │   └── MessageModel.ets
│   ├── mock/                    # 仅静态 mock 数据
│   │   ├── UserMock.ets
│   │   ├── PlatformMock.ets
│   │   ├── LibraryMock.ets
│   │   ├── FeedMock.ets
│   │   └── MessageMock.ets
│   ├── utils/
│   │   └── LibraryFormat.ets    # 展示格式化纯函数
│   └── ProfileModel.ets         # 兼容桶导出（旧路径）
└── pages/                       # UI 只依赖 api + types
```

## API 一览

| 方法 | 约定路径 | 说明 |
|------|----------|------|
| `fetchCurrentUser` | GET `/api/v1/profile/me` | 当前用户 |
| `updateCurrentUser` | PUT `/api/v1/profile/me` | 更新资料 |
| `fetchPlatformList` | GET `/api/v1/profile/platforms` | 平台定义 |
| `fetchBoundAccount` | GET `.../platforms/{id}/account` | 绑定账号，`data=null` 未绑 |
| `bindPlatform` | POST `.../platforms/{id}/bind` | 绑定 |
| `unbindPlatform` | DELETE `.../platforms/{id}/bind` | 解绑（mock 限会话） |
| `fetchLibraryGames` | GET `/api/v1/profile/library/games` | 游戏库筛选列表 |
| `fetchFeedList` | GET `/api/v1/profile/feeds` | 动态 |
| `fetchMessageSessions` | GET `/api/v1/profile/messages/sessions` | 会话列表 |
| `fetchMessageSessionById` | GET `.../sessions/{id}` | 会话详情 |
| `fetchChatMessages` | GET `.../sessions/{id}/messages` | 聊天记录 |
| `sendChatMessage` | POST `.../sessions/{id}/messages` | 发私信 |

统一响应：`ApiResult<T> { code, message, data }`，`code===0` 成功。

## 页面改造

| 页面 | 数据入口 |
|------|----------|
| DataTab | `getCurrentUserSync` |
| EditProfilePage | `getCurrentUserSync` / `updateCurrentUser` |
| PlatformPanel | `getPlatformListSync` / `getBoundAccountSync` / `bindPlatform` |
| GameLibrarySection | `getLibraryGamesSync` |
| DynamicTab | `getFeedListSync` |
| MessagesPage | `getMessageSessionsSync` |
| ChatPage | `getMessageSessionByIdSync` / `getChatMessagesSync` / `sendChatMessage` |

## 约定

1. **页面禁止**直接 import `model/mock/*`
2. **新逻辑**走 `api/*`；需要类型走 `model/types/*`
3. `ProfileModel.ets` 仅作兼容 re-export，逐步废弃直接读 mock 常量
4. 接真实网络时：只改 `api/*` 实现，UI 与 types 不动

## 验证

1. 个人资料 / 平台切换 / 游戏库筛选 / 消息聊天路径正常  
2. 编辑资料保存走 `updateCurrentUser`  
3. 绑定未绑平台走 `bindPlatform`  
4. 私信发送走 `sendChatMessage`  
