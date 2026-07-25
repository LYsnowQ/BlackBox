/**
 * 个人游戏库 API
 *
 * GET /api/v1/profile/library/games?nav=&wishlistFilter=&ownedSort=&keyword=
 */
import { ApiResult, apiOk } from './ApiTypes';
import {
  LibraryGame,
  LibraryListQuery,
  LibraryNavKey,
  OwnedSortKey,
  WishlistFilterKey,
} from '../model/types/LibraryModel';
import { isLowestOrNew } from '../model/utils/LibraryFormat';
import { MOCK_LIBRARY_GAMES } from '../model/mock/LibraryMock';

function copyGame(g: LibraryGame): LibraryGame {
  const colors: string[] = [];
  for (let i = 0; i < g.coverColors.length; i++) {
    colors.push(g.coverColors[i]);
  }
  const out: LibraryGame = {
    id: g.id,
    title: g.title,
    coverColors: colors,
    totalHours: g.totalHours,
    twoWeekHours: g.twoWeekHours,
    achievementUnlocked: g.achievementUnlocked,
    achievementTotal: g.achievementTotal,
    inWishlist: g.inWishlist,
    owned: g.owned,
    inSteamWishlist: g.inSteamWishlist,
    onDiscount: g.onDiscount,
    isLowest: g.isLowest,
    lowestTag: g.lowestTag,
    myRating: g.myRating,
    price: g.price,
    originalPrice: g.originalPrice,
    appScore: g.appScore,
    unreleased: g.unreleased,
    releaseLabel: g.releaseLabel,
    followCount: g.followCount,
  };
  return out;
}

function filterByNav(
  src: LibraryGame[],
  nav: LibraryNavKey,
  wishlistFilter: WishlistFilterKey
): LibraryGame[] {
  const out: LibraryGame[] = [];
  for (let i = 0; i < src.length; i++) {
    const g = src[i];
    if (nav === 'wishlist') {
      if (!g.inWishlist) {
        continue;
      }
      if (wishlistFilter === 'discount' && !g.onDiscount) {
        continue;
      }
      if (wishlistFilter === 'lowest' && !isLowestOrNew(g)) {
        continue;
      }
      if (wishlistFilter === 'steam' && !g.inSteamWishlist) {
        continue;
      }
      out.push(copyGame(g));
    } else if (nav === 'owned') {
      if (g.owned) {
        out.push(copyGame(g));
      }
    } else if (nav === 'perfect') {
      if (g.owned && g.achievementTotal > 0 &&
        g.achievementUnlocked === g.achievementTotal) {
        out.push(copyGame(g));
      }
    } else if (nav === 'rated') {
      if (g.myRating !== undefined) {
        out.push(copyGame(g));
      }
    }
  }
  return out;
}

function applyKeyword(list: LibraryGame[], keyword: string): LibraryGame[] {
  const q = keyword.trim().toLowerCase();
  if (q.length === 0) {
    return list;
  }
  const hit: LibraryGame[] = [];
  for (let i = 0; i < list.length; i++) {
    if (list[i].title.toLowerCase().indexOf(q) >= 0) {
      hit.push(list[i]);
    }
  }
  return hit;
}

function sortOwned(list: LibraryGame[], sort: OwnedSortKey): LibraryGame[] {
  const copy: LibraryGame[] = [];
  for (let i = 0; i < list.length; i++) {
    copy.push(list[i]);
  }
  copy.sort((a: LibraryGame, b: LibraryGame) => {
    if (sort === 'twoWeek') {
      return b.twoWeekHours - a.twoWeekHours;
    }
    if (sort === 'achievement') {
      return b.achievementUnlocked - a.achievementUnlocked;
    }
    return b.totalHours - a.totalHours;
  });
  return copy;
}

/**
 * 查询个人库游戏列表
 * GET /api/v1/profile/library/games
 */
export function fetchLibraryGames(query: LibraryListQuery): ApiResult<LibraryGame[]> {
  const nav = query.nav;
  const wishlistFilter: WishlistFilterKey =
    query.wishlistFilter !== undefined ? query.wishlistFilter : 'discount';
  const ownedSort: OwnedSortKey =
    query.ownedSort !== undefined ? query.ownedSort : 'total';
  const keyword = query.keyword !== undefined ? query.keyword : '';

  let list = filterByNav(MOCK_LIBRARY_GAMES, nav, wishlistFilter);
  if (nav === 'owned' || nav === 'perfect') {
    list = applyKeyword(list, keyword);
    list = sortOwned(list, ownedSort);
  }
  return apiOk(list);
}

/**
 * 全量库（未筛选，调试用）
 * GET /api/v1/profile/library/games/all
 */
export function fetchAllLibraryGames(): ApiResult<LibraryGame[]> {
  const list: LibraryGame[] = [];
  for (let i = 0; i < MOCK_LIBRARY_GAMES.length; i++) {
    list.push(copyGame(MOCK_LIBRARY_GAMES[i]));
  }
  return apiOk(list);
}

/** 同步便捷 */
export function getLibraryGamesSync(query: LibraryListQuery): LibraryGame[] {
  return fetchLibraryGames(query).data;
}

export function getAllLibraryGamesSync(): LibraryGame[] {
  return fetchAllLibraryGames().data;
}
