/**
 * 游戏库展示格式化 / 标签解析（纯函数，无 IO）
 */
import { LibraryGame, LowestTagType } from '../types/LibraryModel';

/** 解析史低标签 */
export function resolveLowestTag(game: LibraryGame): LowestTagType {
  if (game.lowestTag !== undefined) {
    return game.lowestTag;
  }
  if (game.isLowest) {
    return 'lowest';
  }
  return 'none';
}

/** 是否属于史低筛选（史低或新史低） */
export function isLowestOrNew(game: LibraryGame): boolean {
  const tag = resolveLowestTag(game);
  return tag === 'lowest' || tag === 'newLowest';
}

/** 关注人数缩写：≥1 万换单位 */
export function formatFollowCount(n: number): string {
  if (n < 10000) {
    return `${n}`;
  }
  if (n < 100000000) {
    const w = n / 10000;
    if (w >= 100) {
      return `${Math.floor(w)}万`;
    }
    if (w >= 10) {
      return `${Math.floor(w)}万`;
    }
    const one = Math.round(w * 10) / 10;
    if (one === Math.floor(one)) {
      return `${Math.floor(one)}万`;
    }
    return `${one}万`;
  }
  const y = n / 100000000;
  if (y >= 100) {
    return `${Math.floor(y)}亿`;
  }
  if (y >= 10) {
    return `${Math.floor(y)}亿`;
  }
  const oneY = Math.round(y * 10) / 10;
  if (oneY === Math.floor(oneY)) {
    return `${Math.floor(oneY)}亿`;
  }
  return `${oneY}亿`;
}

/** 价格展示 ¥xx */
export function formatPriceYuan(price: number): string {
  if (price === Math.floor(price)) {
    return `¥${Math.floor(price)}`;
  }
  return `¥${price.toFixed(1)}`;
}
