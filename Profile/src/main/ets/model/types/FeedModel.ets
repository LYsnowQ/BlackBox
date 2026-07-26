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
