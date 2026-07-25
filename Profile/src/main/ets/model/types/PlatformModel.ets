/**
 * 平台绑定 · 类型定义
 */

/** 平台好友（仅头像展示） */
export interface PlatformFriend {
  id: string;
  nickname: string;
  avatarChar: string;
  avatarColor: string;
}

/** 已绑定的平台账号信息 */
export interface PlatformAccount {
  platformId: string;
  nickname: string;
  avatarChar: string;
  level: string;
  accountValue: string;
  playTime: string;
  gameCount: string;
  friends: PlatformFriend[];
}

/** 平台定义（含 UI token） */
export interface PlatformItem {
  id: string;
  name: string;
  accent: string;
  bgTop: string;
  bgBottom: string;
  textOnBg: string;
  textMuted: string;
  surface: string;
  inputHint: string;
}

/** 绑定平台请求 */
export interface BindPlatformRequest {
  platformId: string;
  accountId: string;
}
