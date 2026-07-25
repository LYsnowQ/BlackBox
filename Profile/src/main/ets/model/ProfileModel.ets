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

// ─────────────────────────────────────────────
// 平台下方 · 游戏库列表
// ─────────────────────────────────────────────

/** 主分区：心愿单 / 拥有游戏 / 完美通关 / 我的评分 */
export type LibraryNavKey = 'wishlist' | 'owned' | 'perfect' | 'rated';

/** 拥有 / 完美通关 下的排序：总时长 / 两周内 / 成就 */
export type OwnedSortKey = 'total' | 'twoWeek' | 'achievement';

/** 心愿单筛选 */
export type WishlistFilterKey = 'discount' | 'lowest' | 'steam';

/** 个人库游戏条目 */
export interface LibraryGame {
  id: string;
  title: string;
  /** 封面占位渐变 */
  coverColors: [string, string];
  /** 总时长（小时） */
  totalHours: number;
  /** 近两周时长（小时） */
  twoWeekHours: number;
  /** 已解锁成就 */
  achievementUnlocked: number;
  /** 成就总数 */
  achievementTotal: number;
  /** 是否在心愿单 */
  inWishlist: boolean;
  /** 是否拥有 */
  owned: boolean;
  /** 是否在 Steam 愿望单 */
  inSteamWishlist: boolean;
  /** 是否正在折扣 */
  onDiscount: boolean;
  /** 是否史低 */
  isLowest: boolean;
  /** 我的评分（有值表示点评过） */
  myRating?: number;
}

/** 个人库 mock */
export const libraryGames: LibraryGame[] = [
  {
    id: 'lg1',
    title: '黑神话：悟空',
    coverColors: ['#2A1810', '#8B4513'],
    totalHours: 86.5,
    twoWeekHours: 12.3,
    achievementUnlocked: 42,
    achievementTotal: 81,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: false,
    isLowest: false,
    myRating: 9.6,
  },
  {
    id: 'lg2',
    title: 'Hades II',
    coverColors: ['#1A0A2E', '#6B2D8B'],
    totalHours: 42.0,
    twoWeekHours: 18.7,
    achievementUnlocked: 28,
    achievementTotal: 28,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: true,
    isLowest: false,
    myRating: 9.2,
  },
  {
    id: 'lg3',
    title: '幻兽帕鲁',
    coverColors: ['#8FD3E8', '#5B9BD5'],
    totalHours: 320.0,
    twoWeekHours: 4.2,
    achievementUnlocked: 30,
    achievementTotal: 55,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: true,
    isLowest: true,
  },
  {
    id: 'lg4',
    title: '艾尔登法环',
    coverColors: ['#1C2833', '#5D6D7E'],
    totalHours: 178.0,
    twoWeekHours: 0,
    achievementUnlocked: 42,
    achievementTotal: 42,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: false,
    isLowest: false,
    myRating: 9.8,
  },
  {
    id: 'lg5',
    title: '赛博朋克 2077',
    coverColors: ['#F9E79F', '#D4AC0D'],
    totalHours: 65.2,
    twoWeekHours: 22.5,
    achievementUnlocked: 18,
    achievementTotal: 57,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: true,
    isLowest: true,
    myRating: 8.4,
  },
  {
    id: 'lg6',
    title: '空洞骑士：丝之歌',
    coverColors: ['#1A1A2E', '#4A4A6A'],
    totalHours: 0,
    twoWeekHours: 0,
    achievementUnlocked: 0,
    achievementTotal: 0,
    inWishlist: true,
    owned: false,
    inSteamWishlist: true,
    onDiscount: true,
    isLowest: false,
  },
  {
    id: 'lg7',
    title: 'Clair Obscur: Expedition 33',
    coverColors: ['#0D2137', '#1B4F72'],
    totalHours: 0,
    twoWeekHours: 0,
    achievementUnlocked: 0,
    achievementTotal: 0,
    inWishlist: true,
    owned: false,
    inSteamWishlist: true,
    onDiscount: false,
    isLowest: false,
  },
  {
    id: 'lg8',
    title: '死亡搁浅 2',
    coverColors: ['#E8D5B7', '#A67C52'],
    totalHours: 0,
    twoWeekHours: 0,
    achievementUnlocked: 0,
    achievementTotal: 0,
    inWishlist: true,
    owned: false,
    inSteamWishlist: false,
    onDiscount: true,
    isLowest: true,
  },
  {
    id: 'lg9',
    title: '只狼：影逝二度',
    coverColors: ['#4A0E0E', '#8B0000'],
    totalHours: 48.0,
    twoWeekHours: 0,
    achievementUnlocked: 34,
    achievementTotal: 34,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: false,
    isLowest: false,
    myRating: 9.5,
  },
  {
    id: 'lg10',
    title: '星空',
    coverColors: ['#0B0C10', '#1F2833'],
    totalHours: 112.0,
    twoWeekHours: 8.0,
    achievementUnlocked: 12,
    achievementTotal: 50,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: true,
    isLowest: false,
  },
  {
    id: 'lg11',
    title: '博德之门 3',
    coverColors: ['#2C1810', '#6B3A2A'],
    totalHours: 256.0,
    twoWeekHours: 1.5,
    achievementUnlocked: 54,
    achievementTotal: 54,
    inWishlist: false,
    owned: true,
    inSteamWishlist: false,
    onDiscount: false,
    isLowest: false,
    myRating: 9.7,
  },
  {
    id: 'lg12',
    title: '怪物猎人：荒野',
    coverColors: ['#1B4332', '#2D6A4F'],
    totalHours: 0,
    twoWeekHours: 0,
    achievementUnlocked: 0,
    achievementTotal: 0,
    inWishlist: true,
    owned: false,
    inSteamWishlist: true,
    onDiscount: false,
    isLowest: false,
  },
];

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

// ── 消息 / 私信 ──────────────────────────────────────────

/** 消息会话类型 */
export type MessageSessionType = 'chat' | 'system' | 'interaction' | 'activity' | 'order';

/** 消息列表项（邮件页） */
export interface MessageSession {
  id: string;
  title: string;
  preview: string;
  time: string;
  unread: boolean;
  /** 头像占位字 */
  avatarChar: string;
  /** 头像底色 */
  avatarColor: string;
  type: MessageSessionType;
}

/** 单条聊天消息 */
export interface ChatMessage {
  id: string;
  /** true = 当前用户发出 */
  isSelf: boolean;
  content: string;
  time: string;
  /** 是否在气泡上方展示时间分隔 */
  showTime?: boolean;
}

/** 消息列表 mock */
export const messageSessions: MessageSession[] = [
  {
    id: 'sys',
    title: '系统通知',
    preview: '你关注的游戏《黑神话：悟空》史低优惠已开启',
    time: '10:24',
    unread: true,
    avatarChar: '系',
    avatarColor: '#2BC48A',
    type: 'system',
  },
  {
    id: 'interact',
    title: '互动消息',
    preview: '有 3 人赞了你的评价',
    time: '昨天',
    unread: true,
    avatarChar: '互',
    avatarColor: '#5B8FF9',
    type: 'interaction',
  },
  {
    id: 'chat_tide',
    title: '潮声未歇',
    preview: '那把太刀的手感真的绝了，改天一起联机',
    time: '09:18',
    unread: true,
    avatarChar: '潮',
    avatarColor: '#6C8CFF',
    type: 'chat',
  },
  {
    id: 'chat_pixel',
    title: '像素旅人',
    preview: '独立游戏节那张单子我整理好了，发给你',
    time: '昨天',
    unread: false,
    avatarChar: '像',
    avatarColor: '#E8A54B',
    type: 'chat',
  },
  {
    id: 'activity',
    title: '官方活动',
    preview: '独立游戏节现已开启，精选作品 5 折起',
    time: '周一',
    unread: false,
    avatarChar: '活',
    avatarColor: '#C8C8CC',
    type: 'activity',
  },
  {
    id: 'chat_fog',
    title: '雾港守夜人',
    preview: '你上次说的那部剧情向，通关了吗？',
    time: '周日',
    unread: false,
    avatarChar: '雾',
    avatarColor: '#7B6C9E',
    type: 'chat',
  },
  {
    id: 'order',
    title: '订单提醒',
    preview: '你的订单已发货，请注意查收',
    time: '3/12',
    unread: false,
    avatarChar: '订',
    avatarColor: '#C8C8CC',
    type: 'order',
  },
];

/** 各会话聊天记录 mock（含系统类会话的通知流） */
const chatMessagesBySession: Record<string, ChatMessage[]> = {
  sys: [
    {
      id: 'sys1',
      isSelf: false,
      content: '欢迎回来。你关注的游戏有新动态时，会在这里提醒你。',
      time: '3/10 09:00',
      showTime: true,
    },
    {
      id: 'sys2',
      isSelf: false,
      content: '《黑神话：悟空》史低优惠已开启，点击游戏库查看详情。',
      time: '今天 10:24',
      showTime: true,
    },
  ],
  interact: [
    {
      id: 'ia1',
      isSelf: false,
      content: '「像素旅人」赞了你的评价《黑神话：悟空》。',
      time: '昨天 18:20',
      showTime: true,
    },
    {
      id: 'ia2',
      isSelf: false,
      content: '「潮声未歇」赞了你的评价《黑神话：悟空》。',
      time: '昨天 19:02',
    },
    {
      id: 'ia3',
      isSelf: false,
      content: '「雾港守夜人」赞了你的动态「深夜独白 · 关于等待」。',
      time: '昨天 21:40',
    },
  ],
  chat_tide: [
    {
      id: 'ct1',
      isSelf: false,
      content: '在吗？周末有空一起打吗？',
      time: '昨天 20:12',
      showTime: true,
    },
    {
      id: 'ct2',
      isSelf: true,
      content: '在的。打什么？',
      time: '昨天 20:15',
    },
    {
      id: 'ct3',
      isSelf: false,
      content: '《黑神话》或者 Deep Rock，都行。',
      time: '昨天 20:16',
    },
    {
      id: 'ct4',
      isSelf: true,
      content: '那把太刀我刚练顺手，可以带你过一趟。',
      time: '昨天 20:18',
    },
    {
      id: 'ct5',
      isSelf: false,
      content: '那把太刀的手感真的绝了，改天一起联机。',
      time: '今天 09:18',
      showTime: true,
    },
    {
      id: 'ct6',
      isSelf: true,
      content: '好，今晚九点见。',
      time: '今天 09:20',
    },
  ],
  chat_pixel: [
    {
      id: 'cp1',
      isSelf: false,
      content: '独立游戏节单子我筛了一版，偏叙事和像素。',
      time: '昨天 15:30',
      showTime: true,
    },
    {
      id: 'cp2',
      isSelf: true,
      content: '发我看看，最近正好想补几款短篇。',
      time: '昨天 15:42',
    },
    {
      id: 'cp3',
      isSelf: false,
      content: '独立游戏节那张单子我整理好了，发给你。',
      time: '昨天 16:05',
    },
    {
      id: 'cp4',
      isSelf: false,
      content: '《Cats and the Together》和那部纸嫁衣系列可以先看。',
      time: '昨天 16:06',
    },
  ],
  activity: [
    {
      id: 'ac1',
      isSelf: false,
      content: '独立游戏节现已开启，精选作品 5 折起。活动页可在商城入口查看。',
      time: '周一 11:00',
      showTime: true,
    },
  ],
  chat_fog: [
    {
      id: 'cf1',
      isSelf: false,
      content: '你上次说的那部剧情向，通关了吗？',
      time: '周日 22:08',
      showTime: true,
    },
    {
      id: 'cf2',
      isSelf: true,
      content: '通了。结局偏开放，挺适合回味。',
      time: '周日 22:30',
    },
    {
      id: 'cf3',
      isSelf: false,
      content: '那我周末开坑。有无雷点提醒？',
      time: '周日 22:31',
    },
    {
      id: 'cf4',
      isSelf: true,
      content: '节奏偏慢，前两章耐心看就好。',
      time: '周日 22:33',
    },
  ],
  order: [
    {
      id: 'od1',
      isSelf: false,
      content: '你的订单已发货，请注意查收。物流信息可在订单详情中查看。',
      time: '3/12 14:20',
      showTime: true,
    },
  ],
};

/** 按会话 id 取消息列表；未知 id 返回空数组 */
export function getChatMessages(sessionId: string): ChatMessage[] {
  const list = chatMessagesBySession[sessionId];
  if (!list) {
    return [];
  }
  return list.slice();
}

/** 按会话 id 取列表项元信息 */
export function getMessageSessionById(sessionId: string): MessageSession | undefined {
  for (let i = 0; i < messageSessions.length; i++) {
    if (messageSessions[i].id === sessionId) {
      return messageSessions[i];
    }
  }
  return undefined;
}
