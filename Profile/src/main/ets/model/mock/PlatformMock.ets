/**
 * 平台绑定 mock 数据
 */
import {
  PlatformAccount,
  PlatformFriend,
  PlatformItem,
} from '../types/PlatformModel';

/** 平台列表：steam / switch / ps / xbox / epic */
export const MOCK_PLATFORM_LIST: PlatformItem[] = [
  {
    id: 'steam',
    name: 'steam',
    accent: '#66C0F4',
    bgTop: '#1B2838',
    bgBottom: '#171A21',
    textOnBg: '#C7D5E0',
    textMuted: 'rgba(199,213,224,0.55)',
    surface: 'rgba(255,255,255,0.08)',
    inputHint: '请输入 Steam ID',
  },
  {
    id: 'switch',
    name: 'switch',
    accent: '#E60012',
    bgTop: '#2D2D2D',
    bgBottom: '#1A1A1A',
    textOnBg: '#F0F0F0',
    textMuted: 'rgba(240,240,240,0.55)',
    surface: 'rgba(255,255,255,0.08)',
    inputHint: '请输入 Switch 好友代号',
  },
  {
    id: 'ps',
    name: 'ps',
    accent: '#0070D1',
    bgTop: '#003087',
    bgBottom: '#001F54',
    textOnBg: '#E8F0FF',
    textMuted: 'rgba(232,240,255,0.55)',
    surface: 'rgba(255,255,255,0.10)',
    inputHint: '请输入 PSN ID',
  },
  {
    id: 'xbox',
    name: 'xbox',
    accent: '#107C10',
    bgTop: '#107C10',
    bgBottom: '#0A4A0A',
    textOnBg: '#E8FFE8',
    textMuted: 'rgba(232,255,232,0.55)',
    surface: 'rgba(255,255,255,0.12)',
    inputHint: '请输入 Xbox Gamertag',
  },
  {
    id: 'epic',
    name: 'epic',
    accent: '#FFFFFF',
    bgTop: '#2A2A2A',
    bgBottom: '#121212',
    textOnBg: '#F5F5F5',
    textMuted: 'rgba(245,245,245,0.55)',
    surface: 'rgba(255,255,255,0.08)',
    inputHint: '请输入 Epic 显示名称',
  },
];

function sortFriendsByNickname(list: PlatformFriend[]): PlatformFriend[] {
  const copy: PlatformFriend[] = [];
  for (let i = 0; i < list.length; i++) {
    copy.push(list[i]);
  }
  copy.sort((a: PlatformFriend, b: PlatformFriend) => {
    if (a.nickname < b.nickname) {
      return -1;
    }
    if (a.nickname > b.nickname) {
      return 1;
    }
    return 0;
  });
  return copy;
}

/** 已绑定账号 mock：steam / ps 已绑定，其余未绑定 */
const MOCK_STEAM_ACCOUNT: PlatformAccount = {
  platformId: 'steam',
  nickname: 'MistTide',
  avatarChar: 'S',
  level: 'Lv.72',
  accountValue: '¥12,480',
  playTime: '3,842h',
  gameCount: '186',
  friends: sortFriendsByNickname([
    { id: 's1', nickname: 'Aria', avatarChar: 'A', avatarColor: '#4A90D9' },
    { id: 's2', nickname: 'Blade', avatarChar: 'B', avatarColor: '#E07A3D' },
    { id: 's3', nickname: 'Cipher', avatarChar: 'C', avatarColor: '#7B68A6' },
    { id: 's4', nickname: 'Dawn', avatarChar: 'D', avatarColor: '#2BC48A' },
    { id: 's5', nickname: 'Echo', avatarChar: 'E', avatarColor: '#D94A6A' },
    { id: 's6', nickname: 'Frost', avatarChar: 'F', avatarColor: '#5B9BD5' },
    { id: 's7', nickname: 'Gale', avatarChar: 'G', avatarColor: '#8B7355' },
    { id: 's8', nickname: 'Hex', avatarChar: 'H', avatarColor: '#3A8B7A' },
  ]),
};

const MOCK_PS_ACCOUNT: PlatformAccount = {
  platformId: 'ps',
  nickname: 'Tide_PS5',
  avatarChar: 'P',
  level: 'Lv.31',
  accountValue: '¥3,260',
  playTime: '428h',
  gameCount: '42',
  friends: sortFriendsByNickname([
    { id: 'p1', nickname: 'Nova', avatarChar: 'N', avatarColor: '#0070D1' },
    { id: 'p2', nickname: 'Orbit', avatarChar: 'O', avatarColor: '#5C7CFA' },
    { id: 'p3', nickname: 'Pixel', avatarChar: 'P', avatarColor: '#845EF7' },
    { id: 'p4', nickname: 'Quark', avatarChar: 'Q', avatarColor: '#339AF0' },
    { id: 'p5', nickname: 'Rift', avatarChar: 'R', avatarColor: '#22B8CF' },
  ]),
};

/** 按平台 id 取已绑定账号 */
export function getMockBoundAccount(platformId: string): PlatformAccount | undefined {
  if (platformId === 'steam') {
    return MOCK_STEAM_ACCOUNT;
  }
  if (platformId === 'ps') {
    return MOCK_PS_ACCOUNT;
  }
  return undefined;
}

/** 已绑定平台 id 列表 */
export function getMockBoundPlatformIds(): string[] {
  return ['steam', 'ps'];
}
