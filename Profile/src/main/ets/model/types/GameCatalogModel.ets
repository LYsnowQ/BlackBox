/**
 * Profile 商城向游戏详情 · 类型定义
 *（自 Gamelibrary 复制，仅 Profile 模块使用）
 */

export interface HeaderToolItem {
  title: string;
  icon?: string;
  version?: string;
}

/** 商城/详情游戏条目 */
export interface GameItem {
  id: string;
  title: string;
  englishTitle: string;
  gradientColors: [string, string];
  coverImg?: ResourceStr;
  price: number;
  originalPrice?: number;
  lowestPrice?: number;
  discountPercent?: number;
  couponLabel?: string;
  lowestLabel?: string;
  rankLabel?: string;
  rankBoard?: string;
  tags: string[];
  secondaryTags?: string[];
  rating?: number;
  ratingColor?: string;
  ratingCount?: string;
  favoriteCount?: string;
  onlineNow?: string;
  yesterdayPeak?: string;
  peakRank?: string;
  monthAvgOnline?: string;
  monthAvgRank?: string;
  globalSalesRank?: string;
  blackBoxPlayers?: string;
  playersRank?: string;
  avgPlayTime?: string;
  playTimeRank?: string;
  goodRate?: string;
  wishlistCount?: string;
  awardLabel?: string;
  hasDeveloperIn?: boolean;
  deckSupport?: string;
  hasDatabaseTab?: boolean;
  headerTheme?: 'orange' | 'teal' | 'white';
  headerTools?: HeaderToolItem[];
  customTabs?: string[];
  intro?: string;
  platformIcon?: string;
}

export interface PostCommentReply {
  id?: string;
  authorName: string;
  authorAvatarBg?: string;
  content: string;
  timeAgo: string;
  location?: string;
  targetUser?: string;
}

export interface PostComment {
  id?: string;
  authorName: string;
  authorAvatarBg: string;
  authorLevel?: string;
  timeAgo: string;
  location?: string;
  content: string;
  likesCount: number;
  reply?: PostCommentReply;
  replies?: PostCommentReply[];
}

export interface PostGameCard {
  title: string;
  subTitle?: string;
  price: string;
  originalPrice?: string;
  discount?: string;
  lowestTag?: string;
  coverImg?: ResourceStr;
}

export interface CommunityPost {
  id: string;
  authorName: string;
  authorAvatarBg: string;
  authorLevel?: string;
  timeAgo: string;
  postDate?: string;
  location?: string;
  title: string;
  content: string;
  likesCount: number;
  commentsCount: number;
  tag?: string;
  coverImg?: ResourceStr;
  gameCard?: PostGameCard;
  toolName?: string;
  toolDesc?: string;
  relatedSearch?: string;
  comments?: PostComment[];
}

export interface DatabaseItem {
  id: string;
  name: string;
  category: string;
  rarity?: string;
  rarityColor?: string;
  desc: string;
  icon: string;
}

export interface RegionPrice {
  regionName: string;
  flagEmoji: string;
  priceLocal: string;
  priceCNY: string;
  isLowest?: boolean;
}
