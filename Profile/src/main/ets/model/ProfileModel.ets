/**
 * 个人中心数据模型
 * 说明：暂用本地 mock，后续可替换为接口数据。
 */

export interface ProfileStat {
  label: string;
  value: string;
}

export interface FeedItem {
  id: string;
  title: string;
  content: string;
  meta: string;
  likes: string;
  comments: string;
  tag: string;
  hasCover?: boolean;
}

export interface UserProfile {
  nickname: string;
  avatarChar: string;
  level: string;
  userId: string;
  signature: string;
  stats: ProfileStat[];
}

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

/** 平台定义 */
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

/** 当前登录用户 mock */
export const currentUser: UserProfile = {
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

/** 平台列表：steam / switch / ps / xbox / epic */
export const platformList: PlatformItem[] = [
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
const steamAccount: PlatformAccount = {
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

const psAccount: PlatformAccount = {
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

export function getBoundAccount(platformId: string): PlatformAccount | undefined {
  if (platformId === 'steam') {
    return steamAccount;
  }
  if (platformId === 'ps') {
    return psAccount;
  }
  return undefined;
}

/** 动态流 */
export const feedList: FeedItem[] = [
  {
    id: '1',
    title: '深夜独白 · 关于「等待」',
    content: '有些游戏不是通关了就结束，而是通关后才开始。像把一封写了很久的信，终于投进邮筒。',
    meta: '2 小时前',
    likes: '2.1k',
    comments: '386',
    tag: '灵感',
    hasCover: true,
  },
  {
    id: '2',
    title: '《黑神话：悟空》',
    content: '不是标签能概括的作品。镜头、节奏、Boss 设计都在说话：我们终于可以只谈游戏本身了。',
    meta: '昨天 · 9.6 分',
    likes: '8.7k',
    comments: '1.2k',
    tag: '评价',
    hasCover: true,
  },
  {
    id: '3',
    title: '本周在玩 · Hades II',
    content: 'Roguelike 的魅力在于「再来一把」的借口永远成立。这一把，只是为了多听一句台词。',
    meta: '3 天前 · 42h',
    likes: '956',
    comments: '128',
    tag: '在玩',
  },
  {
    id: '4',
    title: '什么才算好结局？',
    content: '好结局不一定是圆满。可以是遗憾刚好到可以回味的程度，可以是角色终于学会了告别。',
    meta: '一周前',
    likes: '4.3k',
    comments: '892',
    tag: '讨论',
  },
];
