/**
 * 个人动态 · 类型定义
 * 列表 / 详情视觉对齐 Home 帖子卡与帖子详情（对照实现，不 import home）
 */

/** 动态配图（mediaKey 走 ProfileMedia / MediaApi） */
export interface FeedImage {
  /** Profile 封面键，空串表示纯色占位 */
  mediaKey: string;
  placeholderColor: string;
}

export interface FeedItem {
  id: string;
  title: string;
  /** 列表摘要 */
  content: string;
  meta: string;
  likes: string;
  comments: string;
  tag: string;
  /** hot | wiki | topic | 空 */
  tagTone?: string;
  hasCover?: boolean;
  /** 作者行（对齐首页帖子卡） */
  authorName: string;
  authorAvatarChar: string;
  authorAvatarColor: string;
  levelLabel: string;
  isOfficial?: boolean;
  images?: FeedImage[];
  imageCount?: number;
  /** right = 右图左文；grid = 下方多图 */
  imageLayout?: string;
  gameTag?: string;
  timeText?: string;
  likeCount?: number;
  commentCount?: number;
}

/** 动态列表查询 */
export interface FeedListQuery {
  cursor?: string;
  pageSize?: number;
}

/** 动态详情评论 */
export interface FeedComment {
  id: string;
  authorName: string;
  authorAvatarChar: string;
  authorAvatarColor: string;
  timeText: string;
  content: string;
  likeCount: number;
  levelLabel?: string;
  isAuthor?: boolean;
  region?: string;
}

/** 动态详情（列表 FeedItem 的扩展） */
export interface FeedDetail {
  id: string;
  title: string;
  summary: string;
  fullContent: string;
  /** 分段正文（详情优先用此渲染，空则回落 fullContent） */
  bodyParagraphs?: string[];
  meta: string;
  likes: string;
  comments: string;
  tag: string;
  tagTone?: string;
  hasCover: boolean;
  coverColors: string[];
  /** 头图 mediaKey，走 Profile 自有 media */
  coverMediaKey?: string;
  authorName: string;
  authorAvatarChar: string;
  authorAvatarColor?: string;
  authorLevel: string;
  isOfficial?: boolean;
  publishTime: string;
  region: string;
  likeCount: number;
  commentCount: number;
  starCount?: number;
  awardCount?: number;
  circles?: string[];
  topicTags?: string[];
  relatedSearch?: string;
  commentList: FeedComment[];
  images?: FeedImage[];
  imageLayout?: string;
}
