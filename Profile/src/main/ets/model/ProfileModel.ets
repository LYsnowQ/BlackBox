/**
 * Profile 模型桶导出（兼容旧 import 路径）
 * 新代码请优先：types/* · mock/* · api/*
 */

// ── types ──
export {
  ProfileStat,
  UserProfile,
  UpdateProfileRequest,
} from './types/UserModel';

export {
  PlatformFriend,
  PlatformAccount,
  PlatformItem,
  BindPlatformRequest,
} from './types/PlatformModel';

export {
  LibraryNavKey,
  OwnedSortKey,
  WishlistFilterKey,
  LowestTagType,
  LibraryGame,
  LibraryListQuery,
} from './types/LibraryModel';

export {
  FeedItem,
  FeedListQuery,
  FeedComment,
  FeedDetail,
} from './types/FeedModel';

export {
  MessageSessionType,
  MessageSession,
  ChatMessage,
  SendChatMessageRequest,
  ChatSessionBundle,
} from './types/MessageModel';

// ── format utils ──
export {
  resolveLowestTag,
  isLowestOrNew,
  formatFollowCount,
  formatPriceYuan,
} from './utils/LibraryFormat';

// ── mock 直出（兼容旧页面直接读常量；新代码请走 api/*）──
export { MOCK_CURRENT_USER as currentUser } from './mock/UserMock';
export { MOCK_PLATFORM_LIST as platformList } from './mock/PlatformMock';
export { getMockBoundAccount as getBoundAccount } from './mock/PlatformMock';
export { MOCK_LIBRARY_GAMES as libraryGames } from './mock/LibraryMock';
export { MOCK_FEED_LIST as feedList } from './mock/FeedMock';
export {
  MOCK_MESSAGE_SESSIONS as messageSessions,
  getMockChatMessages as getChatMessages,
  getMockMessageSessionById as getMessageSessionById,
} from './mock/MessageMock';
