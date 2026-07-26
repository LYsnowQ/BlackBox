// Profile 模块对外导出
// entry 仅负责路由壳挂载，业务 UI / 模型均在此模块

export { Me } from './src/main/ets/pages/Me';
export { SettingsPage } from './src/main/ets/pages/SettingsPage';
export { MessagesPage } from './src/main/ets/pages/MessagesPage';
export { ChatPage } from './src/main/ets/pages/ChatPage';
export { ScanPage } from './src/main/ets/pages/ScanPage';
export { EditProfilePage } from './src/main/ets/pages/EditProfilePage';
export { FeedDetailPage } from './src/main/ets/pages/FeedDetailPage';
export { ProfileGameDetailPage } from './src/main/ets/pages/ProfileGameDetailPage';
export { AccountSecurityPage } from './src/main/ets/pages/AccountSecurityPage';
export { PrivacySettingsPage } from './src/main/ets/pages/PrivacySettingsPage';
export { BlacklistPage } from './src/main/ets/pages/BlacklistPage';
export { NotificationSettingsPage } from './src/main/ets/pages/NotificationSettingsPage';
export { DarkModePage } from './src/main/ets/pages/DarkModePage';
export { AboutPage } from './src/main/ets/pages/AboutPage';

/** 路由契约：与 entry main_pages / 壳页面路径对齐 */
export { ProfileRoutes } from './src/main/ets/router/ProfileRoutes';

/** API 桶（业务侧优先从此接入；mock 实现可替换为真实网络） */
export {
  fetchCurrentUser,
  updateCurrentUser,
  fetchPlatformList,
  fetchBoundAccount,
  bindPlatform,
  fetchLibraryGames,
  fetchLibraryGameById,
  fetchFeedList,
  fetchFeedDetail,
  fetchCatalogGameById,
  fetchCatalogGameForLibraryId,
  fetchGameCommunityPosts,
  fetchGameDatabaseItems,
  fetchGameRegionPrices,
  fetchMessageSessions,
  fetchChatMessages,
  sendChatMessage,
} from './src/main/ets/api/index';
