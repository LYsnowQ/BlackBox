/**
 * 个人游戏库 · 类型定义
 */

/** 主分区：心愿单 / 拥有游戏 / 完美通关 / 我的评分 */
export type LibraryNavKey = 'wishlist' | 'owned' | 'perfect' | 'rated';

/** 拥有 / 完美通关 下的排序 */
export type OwnedSortKey = 'total' | 'twoWeek' | 'achievement';

/** 心愿单筛选 */
export type WishlistFilterKey = 'discount' | 'lowest' | 'steam';

/** 史低标签类型：无 / 史低 / 新史低 */
export type LowestTagType = 'none' | 'lowest' | 'newLowest';

/** 个人库游戏条目 */
export interface LibraryGame {
  id: string;
  title: string;
  /** 封面占位渐变（无 coverImg 时使用） */
  coverColors: string[];
  /**
   * 封面资源键（Profile 自有 media，见 ProfileMedia / MediaApi）
   * 列表 mock 只存 key；API 组装时解析为 coverImg
   */
  coverKey?: string;
  /** 封面图 Resource（由 LibraryApi 根据 coverKey 解析填充） */
  coverImg?: ResourceStr;
  /** 总时长（小时） */
  totalHours: number;
  /** 近两周时长（小时） */
  twoWeekHours: number;
  /** 已解锁成就 */
  achievementUnlocked: number;
  /** 成就总数 */
  achievementTotal: number;
  /** 是否在心愿单 */
  inWishlist: boolean;
  /** 是否拥有 */
  owned: boolean;
  /** 是否在 Steam 愿望单 */
  inSteamWishlist: boolean;
  /** 是否正在折扣 */
  onDiscount: boolean;
  /** 是否史低（兼容旧逻辑） */
  isLowest: boolean;
  /** 史低标签：优先于 isLowest 展示 */
  lowestTag?: LowestTagType;
  /** 我的评分（有值表示点评过） */
  myRating?: number;
  /** 现价（元） */
  price?: number;
  /** 原价（元） */
  originalPrice?: number;
  /** 小黑盒评分 */
  appScore?: number;
  /** 未发售 */
  unreleased?: boolean;
  /** 未发售文案：即将宣布 / 2025 等 */
  releaseLabel?: string;
  /** 关注人数（Steam 愿望单未发售） */
  followCount?: number;
}

/** 游戏库列表查询 */
export interface LibraryListQuery {
  nav: LibraryNavKey;
  wishlistFilter?: WishlistFilterKey;
  ownedSort?: OwnedSortKey;
  keyword?: string;
}
