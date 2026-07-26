/**
 * Profile API 桶导出
 */
export { ApiResult, apiOk, apiFail, MOCK_LATENCY_MS } from './ApiTypes';

export {
  fetchCurrentUser,
  updateCurrentUser,
  getCurrentUserSync,
} from './UserApi';

export {
  fetchPlatformList,
  fetchBoundAccount,
  bindPlatform,
  unbindPlatform,
  getPlatformListSync,
  getBoundAccountSync,
} from './PlatformApi';

export {
  fetchLibraryGames,
  fetchAllLibraryGames,
  fetchLibraryGameById,
  getLibraryGamesSync,
  getAllLibraryGamesSync,
  getLibraryGameByIdSync,
} from './LibraryApi';

export {
  fetchFeedList,
  fetchFeedDetail,
  getFeedListSync,
  getFeedDetailSync,
} from './FeedApi';

export {
  resolveLibraryToCatalogId,
  fetchCatalogGameById,
  fetchCatalogGameForLibraryId,
  fetchGameCommunityPosts,
  fetchGameDatabaseItems,
  fetchGameRegionPrices,
  getCatalogGameByIdSync,
  getCatalogGameForLibraryIdSync,
  getGameCommunityPostsSync,
  getGameDatabaseItemsSync,
  getGameRegionPricesSync,
} from './GameCatalogApi';

export {
  fetchProfileCover,
  getProfileCoverSync,
  getProfileBackgroundSync,
} from './MediaApi';

export {
  fetchMessageSessions,
  fetchMessageSessionById,
  fetchChatMessages,
  sendChatMessage,
  markSessionRead,
  receiveIncomingMessage,
  fetchUnreadTotal,
  getMessageSessionsSync,
  getMessageSessionByIdSync,
  getChatMessagesSync,
  markSessionReadSync,
  getUnreadTotalSync,
  formatUnreadBadge,
} from './MessageApi';
