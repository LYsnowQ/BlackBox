/**
 * Profile 模块自有媒体资源
 *
 * 约定：
 * - 图片只放在 Profile/src/main/resources/base/media/
 * - 文件名统一 profile_ 前缀，避免与 entry / 其他 HAR 同名冲突
 * - 业务与 mock 只通过本工具或 API 取 Resource，禁止引用他人模块 media 名
 */

/** 封面资源键（与 profile_*.png 对应） */
export type ProfileCoverKey =
  | 'wukong'
  | 'palworld'
  | 'eldenring'
  | 'cyberpunk'
  | 'sekiro'
  | 'resident'
  | 'monster'
  | 'monster_rise'
  | 'party'
  | 'chain'
  | 'rise'
  | 'deeprock'
  | 'hitman'
  | 'rdr2'
  | 'overcooked'
  | 'fighter'
  | 'nba'
  | 'love_choice'
  | 'mita'
  | 'storm'
  | 'granblue'
  | 'apex'
  | 'p5r'
  | 'old_day_nun'
  | 'tomb'
  | 'background';

/**
 * 按键解析为 Profile 自有 Resource
 * 未知键回落 background
 */
export function resolveProfileCover(key: string | undefined): Resource {
  if (key === 'wukong') {
    return $r('app.media.profile_wukong');
  }
  if (key === 'palworld') {
    return $r('app.media.profile_palworld');
  }
  if (key === 'eldenring') {
    return $r('app.media.profile_eldenring');
  }
  if (key === 'cyberpunk') {
    return $r('app.media.profile_cyberpunk');
  }
  if (key === 'sekiro') {
    return $r('app.media.profile_sekiro');
  }
  if (key === 'resident') {
    return $r('app.media.profile_resident');
  }
  if (key === 'monster') {
    return $r('app.media.profile_monster');
  }
  if (key === 'monster_rise') {
    return $r('app.media.profile_monster_rise');
  }
  if (key === 'party') {
    return $r('app.media.profile_party');
  }
  if (key === 'chain') {
    return $r('app.media.profile_chain');
  }
  if (key === 'rise') {
    return $r('app.media.profile_rise');
  }
  if (key === 'deeprock') {
    return $r('app.media.profile_deeprock');
  }
  if (key === 'hitman') {
    return $r('app.media.profile_hitman');
  }
  if (key === 'rdr2') {
    return $r('app.media.profile_rdr2');
  }
  if (key === 'overcooked') {
    return $r('app.media.profile_overcooked');
  }
  if (key === 'fighter') {
    return $r('app.media.profile_fighter');
  }
  if (key === 'nba') {
    return $r('app.media.profile_nba');
  }
  if (key === 'love_choice') {
    return $r('app.media.profile_love_choice');
  }
  if (key === 'mita') {
    return $r('app.media.profile_mita');
  }
  if (key === 'storm') {
    return $r('app.media.profile_storm');
  }
  if (key === 'granblue') {
    return $r('app.media.profile_granblue');
  }
  if (key === 'apex') {
    return $r('app.media.profile_apex');
  }
  if (key === 'p5r') {
    return $r('app.media.profile_p5r');
  }
  if (key === 'old_day_nun') {
    return $r('app.media.profile_old_day_nun');
  }
  if (key === 'tomb') {
    return $r('app.media.profile_tomb');
  }
  return $r('app.media.profile_background');
}

/** 默认占位底图 */
export function profileBackground(): Resource {
  return $r('app.media.profile_background');
}
