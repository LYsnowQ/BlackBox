/**
 * 平台绑定 API
 *
 * GET  /api/v1/profile/platforms
 * GET  /api/v1/profile/platforms/{platformId}/account
 * POST /api/v1/profile/platforms/{platformId}/bind
 * DELETE /api/v1/profile/platforms/{platformId}/bind
 */
import { ApiResult, apiFail, apiOk } from './ApiTypes';
import {
  BindPlatformRequest,
  PlatformAccount,
  PlatformFriend,
  PlatformItem,
} from '../model/types/PlatformModel';
import {
  getMockBoundAccount,
  MOCK_PLATFORM_LIST,
} from '../model/mock/PlatformMock';

/** 会话内额外绑定（mock 写回） */
const sessionBoundExtra: PlatformAccount[] = [];

function findSessionBound(platformId: string): PlatformAccount | undefined {
  for (let i = 0; i < sessionBoundExtra.length; i++) {
    if (sessionBoundExtra[i].platformId === platformId) {
      return sessionBoundExtra[i];
    }
  }
  return undefined;
}

function cloneAccount(src: PlatformAccount): PlatformAccount {
  const friends: PlatformFriend[] = [];
  for (let i = 0; i < src.friends.length; i++) {
    friends.push(src.friends[i]);
  }
  const out: PlatformAccount = {
    platformId: src.platformId,
    nickname: src.nickname,
    avatarChar: src.avatarChar,
    level: src.level,
    accountValue: src.accountValue,
    playTime: src.playTime,
    gameCount: src.gameCount,
    friends: friends,
  };
  return out;
}

function emptyAccount(platformId: string): PlatformAccount {
  const out: PlatformAccount = {
    platformId: platformId,
    nickname: '',
    avatarChar: '?',
    level: '',
    accountValue: '—',
    playTime: '—',
    gameCount: '—',
    friends: [],
  };
  return out;
}

/**
 * 平台定义列表
 * GET /api/v1/profile/platforms
 */
export function fetchPlatformList(): ApiResult<PlatformItem[]> {
  const list: PlatformItem[] = [];
  for (let i = 0; i < MOCK_PLATFORM_LIST.length; i++) {
    list.push(MOCK_PLATFORM_LIST[i]);
  }
  return apiOk(list);
}

/**
 * 查询某平台绑定账号；未绑定 data = null
 * GET /api/v1/profile/platforms/{platformId}/account
 */
export function fetchBoundAccount(platformId: string): ApiResult<PlatformAccount | null> {
  const session = findSessionBound(platformId);
  if (session !== undefined) {
    return apiOk(cloneAccount(session));
  }
  const mock = getMockBoundAccount(platformId);
  if (mock !== undefined) {
    return apiOk(cloneAccount(mock));
  }
  return apiOk(null as PlatformAccount | null);
}

/**
 * 绑定平台账号
 * POST /api/v1/profile/platforms/{platformId}/bind
 */
export function bindPlatform(req: BindPlatformRequest): ApiResult<PlatformAccount> {
  const platformId = req.platformId;
  const accountId = req.accountId.trim();
  if (accountId.length === 0) {
    return apiFail(4001, '账号不能为空', emptyAccount(platformId));
  }

  const existing = getMockBoundAccount(platformId);
  if (existing !== undefined) {
    return apiOk(cloneAccount(existing));
  }
  const session = findSessionBound(platformId);
  if (session !== undefined) {
    return apiOk(cloneAccount(session));
  }

  let platformName = platformId;
  for (let i = 0; i < MOCK_PLATFORM_LIST.length; i++) {
    if (MOCK_PLATFORM_LIST[i].id === platformId) {
      platformName = MOCK_PLATFORM_LIST[i].name;
      break;
    }
  }
  const first = platformName.length > 0 ? platformName.substring(0, 1).toUpperCase() : '?';
  const created: PlatformAccount = {
    platformId: platformId,
    nickname: accountId,
    avatarChar: first,
    level: '',
    accountValue: '—',
    playTime: '—',
    gameCount: '—',
    friends: [],
  };
  sessionBoundExtra.push(created);
  return apiOk(cloneAccount(created));
}

/**
 * 解绑平台（mock 仅清会话绑定）
 * DELETE /api/v1/profile/platforms/{platformId}/bind
 */
export function unbindPlatform(platformId: string): ApiResult<boolean> {
  for (let i = 0; i < sessionBoundExtra.length; i++) {
    if (sessionBoundExtra[i].platformId === platformId) {
      const next: PlatformAccount[] = [];
      for (let j = 0; j < sessionBoundExtra.length; j++) {
        if (j !== i) {
          next.push(sessionBoundExtra[j]);
        }
      }
      sessionBoundExtra.length = 0;
      for (let k = 0; k < next.length; k++) {
        sessionBoundExtra.push(next[k]);
      }
      return apiOk(true);
    }
  }
  if (getMockBoundAccount(platformId) !== undefined) {
    return apiFail(4031, '预置绑定账号不可解绑（mock）', false);
  }
  return apiOk(true);
}

/** 同步便捷：列表 */
export function getPlatformListSync(): PlatformItem[] {
  return fetchPlatformList().data;
}

/** 同步便捷：绑定账号 */
export function getBoundAccountSync(platformId: string): PlatformAccount | undefined {
  const res = fetchBoundAccount(platformId);
  if (res.data === null) {
    return undefined;
  }
  return res.data;
}
