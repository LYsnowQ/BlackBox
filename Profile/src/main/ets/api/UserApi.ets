/**
 * 用户 / 个人资料 API
 *
 * 路径约定（未来真实后端）：
 * GET  /api/v1/profile/me
 * PUT  /api/v1/profile/me
 */
import { ApiResult, apiFail, apiOk } from './ApiTypes';
import { ProfileStat, UpdateProfileRequest, UserProfile } from '../model/types/UserModel';
import { MOCK_CURRENT_USER } from '../model/mock/UserMock';

/** 本地可变副本（mock 会话内写回） */
let sessionUser: UserProfile = cloneUser(MOCK_CURRENT_USER);

function cloneUser(src: UserProfile): UserProfile {
  const stats: ProfileStat[] = [];
  for (let i = 0; i < src.stats.length; i++) {
    stats.push({ label: src.stats[i].label, value: src.stats[i].value });
  }
  return {
    nickname: src.nickname,
    avatarChar: src.avatarChar,
    level: src.level,
    userId: src.userId,
    signature: src.signature,
    stats: stats,
  };
}

/**
 * 获取当前登录用户资料
 * GET /api/v1/profile/me
 */
export function fetchCurrentUser(): ApiResult<UserProfile> {
  return apiOk(cloneUser(sessionUser));
}

/**
 * 更新当前用户资料
 * PUT /api/v1/profile/me
 */
export function updateCurrentUser(req: UpdateProfileRequest): ApiResult<UserProfile> {
  if (req.nickname !== undefined) {
    const name = req.nickname.trim();
    if (name.length === 0) {
      return apiFail(4001, '昵称不能为空', cloneUser(sessionUser));
    }
    if (name.length > 20) {
      return apiFail(4002, '昵称过长', cloneUser(sessionUser));
    }
    sessionUser.nickname = name;
  }
  if (req.signature !== undefined) {
    sessionUser.signature = req.signature;
  }
  return apiOk(cloneUser(sessionUser));
}

/**
 * 同步读（UI 初始化便捷方法，等同 fetch 成功 data）
 * 新页面优先用 fetchCurrentUser
 */
export function getCurrentUserSync(): UserProfile {
  return cloneUser(sessionUser);
}
