/**
 * 用户 / 个人资料 · 类型定义
 */

export interface ProfileStat {
  label: string;
  value: string;
}

export interface UserProfile {
  nickname: string;
  avatarChar: string;
  level: string;
  userId: string;
  signature: string;
  stats: ProfileStat[];
}

/** 更新个人资料请求 */
export interface UpdateProfileRequest {
  nickname?: string;
  signature?: string;
}
