/**
 * Profile 媒体资源 API
 *
 * GET /api/v1/profile/media/cover?key=
 * 仅解析本 HAR media（profile_*），不依赖 entry / 其他模块资源表
 */
import { ApiResult, apiOk } from './ApiTypes';
import {
  profileBackground,
  resolveProfileCover,
} from '../model/utils/ProfileMedia';

/**
 * 按封面键取 Resource
 * GET /api/v1/profile/media/cover/{key}
 */
export function fetchProfileCover(key: string): ApiResult<Resource> {
  return apiOk(resolveProfileCover(key));
}

export function getProfileCoverSync(key: string | undefined): Resource {
  return resolveProfileCover(key);
}

export function getProfileBackgroundSync(): Resource {
  return profileBackground();
}
