/**
 * 用户资料 mock 数据
 */
import { UserProfile } from '../types/UserModel';

/** 当前登录用户 */
export const MOCK_CURRENT_USER: UserProfile = {
  nickname: '雾里听潮',
  avatarChar: '盒',
  level: 'Lv.48',
  userId: '10086',
  signature: '不急着通关人生，只想把每一局都玩出回味。',
  stats: [
    { label: '关注', value: '128' },
    { label: '粉丝', value: '1.6万' },
    { label: '获赞', value: '3.2万' },
    { label: '收藏', value: '86' },
    { label: '历史总览', value: '246' },
  ],
};
