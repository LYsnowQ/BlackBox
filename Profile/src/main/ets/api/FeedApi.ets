/**
 * 个人动态 API
 *
 * GET /api/v1/profile/feeds
 */
import { ApiResult, apiOk } from './ApiTypes';
import { FeedItem, FeedListQuery } from '../model/types/FeedModel';
import { MOCK_FEED_LIST } from '../model/mock/FeedMock';

function copyFeed(item: FeedItem): FeedItem {
  return {
    id: item.id,
    title: item.title,
    content: item.content,
    meta: item.meta,
    likes: item.likes,
    comments: item.comments,
    tag: item.tag,
    hasCover: item.hasCover,
  };
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
