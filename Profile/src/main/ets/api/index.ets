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
  getLibraryGamesSync,
  getAllLibraryGamesSync,
} from './LibraryApi';

export {
  fetchFeedList,
  getFeedListSync,
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
