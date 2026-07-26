/**
 * 个人动态 · 类型定义
 */

export interface FeedItem {
  id: string;
  title: string;
  content: string;
  meta: string;
  likes: string;
  comments: string;
  tag: string;
  hasCover?: boolean;
}

/** 动态列表查询 */
export interface FeedListQuery {
  /** 分页游标，首页不传 */
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
}

/** 动态详情（列表 FeedItem 的扩展） */
export interface FeedDetail {
  id: string;
  title: string;
  /** 列表摘要 */
  summary: string;
  /** 详情全文 */
  fullContent: string;
  meta: string;
  likes: string;
  comments: string;
  tag: string;
  hasCover: boolean;
  coverColors: string[];
  authorName: string;
  authorAvatarChar: string;
  authorLevel: string;
  publishTime: string;
  region: string;
  likeCount: number;
  commentCount: number;
  commentList: FeedComment[];
}
