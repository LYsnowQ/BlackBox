/**
 * 热点模块主题色
 * - 默认 light（对照 Screen/Light）
 * - dark 保留为调试配色；后期由上层主题接管时，改为读取全局 mode 即可
 *
 * 调试深色：将 HOT_DEFAULT_THEME_MODE 改为 'dark'
 */

export type HotThemeMode = 'light' | 'dark';

/** 产品默认浅色；仅本地调试深色时改为 'dark' */
export const HOT_DEFAULT_THEME_MODE: HotThemeMode = 'light';

export interface HotThemeColors {
  pageBg: string;
  title: string;
  textPrimary: string;
  textSecondary: string;
  textTertiary: string;
  tabActive: string;
  tabInactive: string;
  tabIndicator: string;
  icon: string;
  divider: string;
  cardBg: string;
  replyBg: string;
  inputBg: string;
  inputPlaceholder: string;
  followBg: string;
  followText: string;
  platformBg: string;
  authorTagBg: string;
  authorTagText: string;
  bottomBarBg: string;
  bottomBarBorder: string;
  actionIcon: string;
  link: string;
  emptyText: string;
  rankDefault: string;
  /** 热榜 1–4 序号底色（浅色截图：橙/紫/蓝/绿） */
  rankBadgeBg: string[];
  rankBadgeText: string;
  dealHighlightBg: string;
  dealHighlightText: string;
  dealCellBg: string;
  dealCellText: string;
  dealPanelBg: string;
  badgeLowestBg: string;
  badgeLowestText: string;
  ratingColor: string;
  pinBg: string;
  pinText: string;
  bulletColor: string;
}

export const HOT_THEME_LIGHT: HotThemeColors = {
  pageBg: '#FFFFFF',
  title: '#1A1A1A',
  textPrimary: '#1A1A1A',
  textSecondary: '#8A8A8A',
  textTertiary: '#B0B0B0',
  tabActive: '#1A1A1A',
  tabInactive: '#9A9A9A',
  tabIndicator: '#1A1A1A',
  icon: '#1A1A1A',
  divider: '#F0F0F0',
  cardBg: '#F7F7F8',
  replyBg: '#F5F6F8',
  inputBg: '#F2F2F4',
  inputPlaceholder: '#A0A0A0',
  followBg: '#1A1A1A',
  followText: '#FFFFFF',
  platformBg: '#F2F2F4',
  authorTagBg: '#EEEEEE',
  authorTagText: '#666666',
  bottomBarBg: '#FFFFFF',
  bottomBarBorder: '#F0F0F0',
  actionIcon: '#666666',
  link: '#2B6DE5',
  emptyText: '#B0B0B0',
  rankDefault: '#B0B0B0',
  rankBadgeBg: ['#FF9F1A', '#9B6BFF', '#4DA3FF', '#3DDC84'],
  rankBadgeText: '#FFFFFF',
  dealHighlightBg: '#7CFF4A',
  dealHighlightText: '#1A1A1A',
  dealCellBg: '#E8F8D8',
  dealCellText: '#3A6A20',
  dealPanelBg: '#F0F7E8',
  badgeLowestBg: '#1DBF73',
  badgeLowestText: '#FFFFFF',
  ratingColor: '#FF8A3A',
  pinBg: '#3A3A3A',
  pinText: '#FFFFFF',
  bulletColor: '#8A8A8A',
};

export const HOT_THEME_DARK: HotThemeColors = {
  pageBg: '#0D0D0D',
  title: '#FFFFFF',
  textPrimary: '#FFFFFF',
  textSecondary: '#6A6A6A',
  textTertiary: '#4A4A4A',
  tabActive: '#FFFFFF',
  tabInactive: '#8A8A8A',
  tabIndicator: '#FFFFFF',
  icon: '#FFFFFF',
  divider: '#1F1F1F',
  cardBg: '#1A1A1A',
  replyBg: '#161616',
  inputBg: '#1A1A1A',
  inputPlaceholder: '#6A6A6A',
  followBg: 'transparent',
  followText: '#FFFFFF',
  platformBg: '#1A1A1A',
  authorTagBg: '#2A2A2A',
  authorTagText: '#8A8A8A',
  bottomBarBg: '#0D0D0D',
  bottomBarBorder: '#1F1F1F',
  actionIcon: '#8A8A8A',
  link: '#4DA3FF',
  emptyText: '#4A4A4A',
  rankDefault: '#6A6A6A',
  rankBadgeBg: ['#FF5A3C', '#FF5A3C', '#FF5A3C', '#6A6A6A'],
  rankBadgeText: '#FFFFFF',
  dealHighlightBg: '#7CFF4A',
  dealHighlightText: '#1A1A1A',
  dealCellBg: 'rgba(40,80,30,0.85)',
  dealCellText: '#C8F5A0',
  dealPanelBg: '#0D1A0A',
  badgeLowestBg: 'rgba(61,220,132,0.15)',
  badgeLowestText: '#3DDC84',
  ratingColor: '#FF8A3A',
  pinBg: '#5A5A5A',
  pinText: '#FFFFFF',
  bulletColor: '#A0A0A0',
};

export function getHotTheme(mode: HotThemeMode = HOT_DEFAULT_THEME_MODE): HotThemeColors {
  return mode === 'dark' ? HOT_THEME_DARK : HOT_THEME_LIGHT;
}

/** 热榜序号底色；超出 1–4 用透明（仅文字） */
export function rankBadgeBackground(theme: HotThemeColors, rank: number): string {
  if (rank >= 1 && rank <= theme.rankBadgeBg.length) {
    return theme.rankBadgeBg[rank - 1];
  }
  return 'transparent';
}
