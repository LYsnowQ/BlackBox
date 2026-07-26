/**
 * Profile 商城向游戏详情 API（自包含，不与 gamelibrary 包联动）
 *
 * GET /api/v1/profile/catalog/games/{id}
 * GET /api/v1/profile/catalog/games/{id}/community
 * GET /api/v1/profile/catalog/games/{id}/database
 * GET /api/v1/profile/catalog/games/{id}/region-prices
 * GET /api/v1/profile/catalog/resolve?libraryId=
 */
import { ApiResult, apiOk, apiFail } from './ApiTypes';
import {
  CommunityPost,
  DatabaseItem,
  GameItem,
  RegionPrice,
} from '../model/types/GameCatalogModel';
import {
  gameList,
  getGameById as mockGetGameById,
  resolveProfileLibraryToGameId as mockResolve,
} from '../model/mock/GameCatalogMock';
import {
  getGameCommunityPosts as mockCommunityPosts,
  getGameDatabaseItems as mockDatabaseItems,
  getGameRegionPrices as mockRegionPrices,
} from '../model/mock/GameDetailExtraMock';

/**
 * 个人库卡片 id（lg*）→ 商城详情 id
 */
export function resolveLibraryToCatalogId(libraryId: string): string {
  return mockResolve(libraryId);
}

/**
 * 按详情 id 取商城游戏
 * GET /api/v1/profile/catalog/games/{id}
 */
export function fetchCatalogGameById(id: string): ApiResult<GameItem | null> {
  const hit = mockGetGameById(id);
  if (hit === undefined) {
    return apiFail<GameItem | null>(404, '游戏不存在', null);
  }
  return apiOk(hit);
}

/**
 * 个人库 id 或详情 slug → 商城游戏（详情页主入口）
 * 解析失败时回退 palworld，保证详情可展示
 */
export function fetchCatalogGameForLibraryId(libraryOrCatalogId: string): ApiResult<GameItem | null> {
  const catalogId = resolveLibraryToCatalogId(libraryOrCatalogId);
  let game = mockGetGameById(catalogId);
  if (game === undefined) {
    game = mockGetGameById('palworld');
  }
  if (game === undefined && gameList.length > 0) {
    game = gameList[0];
  }
  if (game === undefined) {
    return apiFail<GameItem | null>(500, '目录为空', null);
  }
  return apiOk(game);
}

export function getCatalogGameForLibraryIdSync(libraryOrCatalogId: string): GameItem | undefined {
  const res = fetchCatalogGameForLibraryId(libraryOrCatalogId);
  if (res.code !== 0 || res.data === null) {
    return undefined;
  }
  return res.data;
}

export function getCatalogGameByIdSync(id: string): GameItem | undefined {
  const res = fetchCatalogGameById(id);
  if (res.code !== 0 || res.data === null) {
    return undefined;
  }
  return res.data;
}

/**
 * 社区帖
 * GET /api/v1/profile/catalog/games/{id}/community
 */
export function fetchGameCommunityPosts(gameId: string): ApiResult<CommunityPost[]> {
  return apiOk(mockCommunityPosts(gameId));
}

export function getGameCommunityPostsSync(gameId: string): CommunityPost[] {
  return fetchGameCommunityPosts(gameId).data;
}

/**
 * 数据库条目
 * GET /api/v1/profile/catalog/games/{id}/database
 */
export function fetchGameDatabaseItems(gameId: string): ApiResult<DatabaseItem[]> {
  return apiOk(mockDatabaseItems(gameId));
}

export function getGameDatabaseItemsSync(gameId: string): DatabaseItem[] {
  return fetchGameDatabaseItems(gameId).data;
}

/**
 * 全球区价
 * GET /api/v1/profile/catalog/games/{id}/region-prices
 */
export function fetchGameRegionPrices(gameId: string): ApiResult<RegionPrice[]> {
  return apiOk(mockRegionPrices(gameId));
}

export function getGameRegionPricesSync(gameId: string): RegionPrice[] {
  return fetchGameRegionPrices(gameId).data;
}
