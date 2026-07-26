/**
 * 个人动态 API
 *
 * GET /api/v1/profile/feeds
 * GET /api/v1/profile/feeds/{id}
 */
import { ApiResult, apiOk, apiFail } from './ApiTypes';
import { FeedComment, FeedDetail, FeedItem, FeedListQuery } from '../model/types/FeedModel';
import { MOCK_FEED_DETAILS, MOCK_FEED_LIST } from '../model/mock/FeedMock';

function copyFeed(item: FeedItem): FeedItem {
  const out: FeedItem = {
    id: item.id,
    title: item.title,
    content: item.content,
    meta: item.meta,
    likes: item.likes,
    comments: item.comments,
    tag: item.tag,
    hasCover: item.hasCover,
  };
  return out;
}

function copyComment(c: FeedComment): FeedComment {
  const out: FeedComment = {
    id: c.id,
    authorName: c.authorName,
    authorAvatarChar: c.authorAvatarChar,
    authorAvatarColor: c.authorAvatarColor,
    timeText: c.timeText,
    content: c.content,
    likeCount: c.likeCount,
  };
  return out;
}

function copyFeedDetail(d: FeedDetail): FeedDetail {
  const comments: FeedComment[] = [];
  for (let i = 0; i < d.commentList.length; i++) {
    comments.push(copyComment(d.commentList[i]));
  }
  const colors: string[] = [];
  for (let i = 0; i < d.coverColors.length; i++) {
    colors.push(d.coverColors[i]);
  }
  const out: FeedDetail = {
    id: d.id,
    title: d.title,
    summary: d.summary,
    fullContent: d.fullContent,
    meta: d.meta,
    likes: d.likes,
    comments: d.comments,
    tag: d.tag,
    hasCover: d.hasCover,
    coverColors: colors,
    authorName: d.authorName,
    authorAvatarChar: d.authorAvatarChar,
    authorLevel: d.authorLevel,
    publishTime: d.publishTime,
    region: d.region,
    likeCount: d.likeCount,
    commentCount: d.commentCount,
    commentList: comments,
  };
  return out;
}

/**
 * 动态列表
 * GET /api/v1/profile/feeds?cursor=&pageSize=
 */
export function fetchFeedList(query?: FeedListQuery): ApiResult<FeedItem[]> {
  const pageSize = query !== undefined && query.pageSize !== undefined
    ? query.pageSize
    : 20;
  const list: FeedItem[] = [];
  const max = MOCK_FEED_LIST.length < pageSize ? MOCK_FEED_LIST.length : pageSize;
  for (let i = 0; i < max; i++) {
    list.push(copyFeed(MOCK_FEED_LIST[i]));
  }
  return apiOk(list);
}

export function getFeedListSync(): FeedItem[] {
  return fetchFeedList().data;
}

/**
 * 动态详情
 * GET /api/v1/profile/feeds/{id}
 */
export function fetchFeedDetail(id: string): ApiResult<FeedDetail | null> {
  for (let i = 0; i < MOCK_FEED_DETAILS.length; i++) {
    if (MOCK_FEED_DETAILS[i].id === id) {
      return apiOk(copyFeedDetail(MOCK_FEED_DETAILS[i]));
    }
  }
  // 兜底：从列表拼一份最小详情
  for (let j = 0; j < MOCK_FEED_LIST.length; j++) {
    const item = MOCK_FEED_LIST[j];
    if (item.id === id) {
      const fallback: FeedDetail = {
        id: item.id,
        title: item.title,
        summary: item.content,
        fullContent: item.content,
        meta: item.meta,
        likes: item.likes,
        comments: item.comments,
        tag: item.tag,
        hasCover: item.hasCover === true,
        coverColors: ['#E8E8EC', '#D0D0D4'],
        authorName: '雾里听潮',
        authorAvatarChar: '盒',
        authorLevel: 'Lv.48',
        publishTime: item.meta,
        region: '本地',
        likeCount: 0,
        commentCount: 0,
        commentList: [],
      };
      return apiOk(fallback);
    }
  }
  return apiFail<FeedDetail | null>(404, '动态不存在', null);
}

export function getFeedDetailSync(id: string): FeedDetail | undefined {
  const res = fetchFeedDetail(id);
  if (res.code !== 0 || res.data === null) {
    return undefined;
  }
  return res.data;
}
