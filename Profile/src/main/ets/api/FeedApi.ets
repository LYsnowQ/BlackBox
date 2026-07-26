/**
 * 个人动态 API
 *
 * GET /api/v1/profile/feeds
 * GET /api/v1/profile/feeds/{id}
 */
import { ApiResult, apiOk, apiFail } from './ApiTypes';
import { FeedComment, FeedDetail, FeedImage, FeedItem, FeedListQuery } from '../model/types/FeedModel';
import { MOCK_FEED_DETAILS, MOCK_FEED_LIST } from '../model/mock/FeedMock';

function copyImages(src?: FeedImage[]): FeedImage[] {
  const out: FeedImage[] = [];
  if (src === undefined) {
    return out;
  }
  for (let i = 0; i < src.length; i++) {
    const img: FeedImage = {
      mediaKey: src[i].mediaKey,
      placeholderColor: src[i].placeholderColor,
    };
    out.push(img);
  }
  return out;
}

function copyFeed(item: FeedItem): FeedItem {
  const out: FeedItem = {
    id: item.id,
    title: item.title,
    content: item.content,
    meta: item.meta,
    likes: item.likes,
    comments: item.comments,
    tag: item.tag,
    tagTone: item.tagTone,
    hasCover: item.hasCover,
    authorName: item.authorName,
    authorAvatarChar: item.authorAvatarChar,
    authorAvatarColor: item.authorAvatarColor,
    levelLabel: item.levelLabel,
    isOfficial: item.isOfficial,
    images: copyImages(item.images),
    imageCount: item.imageCount,
    imageLayout: item.imageLayout,
    gameTag: item.gameTag,
    timeText: item.timeText,
    likeCount: item.likeCount,
    commentCount: item.commentCount,
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
    levelLabel: c.levelLabel,
    isAuthor: c.isAuthor,
    region: c.region,
  };
  return out;
}

function copyStringList(src?: string[]): string[] {
  const out: string[] = [];
  if (src === undefined) {
    return out;
  }
  for (let i = 0; i < src.length; i++) {
    out.push(src[i]);
  }
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
    bodyParagraphs: copyStringList(d.bodyParagraphs),
    meta: d.meta,
    likes: d.likes,
    comments: d.comments,
    tag: d.tag,
    tagTone: d.tagTone,
    hasCover: d.hasCover,
    coverColors: colors,
    coverMediaKey: d.coverMediaKey,
    authorName: d.authorName,
    authorAvatarChar: d.authorAvatarChar,
    authorAvatarColor: d.authorAvatarColor,
    authorLevel: d.authorLevel,
    isOfficial: d.isOfficial,
    publishTime: d.publishTime,
    region: d.region,
    likeCount: d.likeCount,
    commentCount: d.commentCount,
    starCount: d.starCount,
    awardCount: d.awardCount,
    circles: copyStringList(d.circles),
    topicTags: copyStringList(d.topicTags),
    relatedSearch: d.relatedSearch,
    commentList: comments,
    images: copyImages(d.images),
    imageLayout: d.imageLayout,
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
  for (let j = 0; j < MOCK_FEED_LIST.length; j++) {
    const item = MOCK_FEED_LIST[j];
    if (item.id === id) {
      const fallback: FeedDetail = {
        id: item.id,
        title: item.title,
        summary: item.content,
        fullContent: item.content,
        bodyParagraphs: [item.content],
        meta: item.meta,
        likes: item.likes,
        comments: item.comments,
        tag: item.tag,
        tagTone: item.tagTone,
        hasCover: item.hasCover === true,
        coverColors: ['#E8E8EC', '#D0D0D4'],
        coverMediaKey: item.images !== undefined && item.images.length > 0
          ? item.images[0].mediaKey
          : undefined,
        authorName: item.authorName,
        authorAvatarChar: item.authorAvatarChar,
        authorAvatarColor: item.authorAvatarColor,
        authorLevel: item.levelLabel,
        isOfficial: item.isOfficial,
        publishTime: item.meta,
        region: '本地',
        likeCount: item.likeCount !== undefined ? item.likeCount : 0,
        commentCount: item.commentCount !== undefined ? item.commentCount : 0,
        starCount: 0,
        awardCount: 0,
        circles: [],
        topicTags: item.tag !== '' ? [item.tag] : [],
        commentList: [],
        images: copyImages(item.images),
        imageLayout: item.imageLayout,
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
