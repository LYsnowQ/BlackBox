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
