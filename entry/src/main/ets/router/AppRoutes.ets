/**
 * App 路由契约（entry 汇总）
 *
 * 职责：
 * - entry 注册 main_pages / @Entry 壳时以此为准
 * - 跨模块跳转优先使用本文件常量
 * - 各业务 HAR 的 *Routes 为模块内权威来源，此处做汇总镜像
 *
 * 路径命名：pages/{Module}/{Page}，与 entry/src/main/ets/pages 目录一致
 */
export class AppRoutes {
  /** 主框架（底部 Tab） */
  static readonly INDEX: string = 'pages/Index';

  // ── Gamelibrary ──
  /** 游戏详情 params: { id: string } */
  static readonly GAME_DETAIL: string = 'pages/GameDetail/GameDetail';
  /** 游戏库独立页（若使用） */
  static readonly GAME_LIBRARY: string = 'pages/GameLibrary/GameLibrary';

  // ── Home ──
  /** 帖子详情 params: { id: string, tab?: 'comment' } */
  static readonly HOME_POST_DETAIL: string = 'pages/Home/PostDetail';
  /** 首页搜索 */
  static readonly HOME_SEARCH: string = 'pages/Home/Search';
  /** 用户主页 params: { name, avatarColor, avatarText, levelLabel?, authorId? } */
  static readonly HOME_USER_PROFILE: string = 'pages/Home/UserProfile';
  /** 配图预览 params: { postId: string, index?: number } */
  static readonly HOME_IMAGE_PREVIEW: string = 'pages/Home/ImagePreview';

  // ── Profile ──
  static readonly PROFILE_SETTINGS: string = 'pages/Profile/Settings';
  static readonly PROFILE_MESSAGES: string = 'pages/Profile/Messages';
  static readonly PROFILE_SCAN: string = 'pages/Profile/Scan';
  static readonly PROFILE_EDIT: string = 'pages/Profile/EditProfile';
}
