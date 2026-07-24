/**
 * 热点模块数据模型与 Mock
 * 说明：仅前端展示，数据全部为 mock。
 * Banner / 第一条新闻（news-steam-sale）已接真实图，其余列表缩略图仍可用渐变占位。
 */

/** 频道 Tab */
export interface HotChannel {
  id: string;
  name: string;
  /** all=全部 feed，rank=热榜，game=游戏频道（待开发） */
  type: 'all' | 'rank' | 'game';
}

/** 轮播 Banner（顶部动态展示栏） */
export interface HotBanner {
  id: string;
  title: string;
  cta: string;
  /** 无真实图时的渐变占位色 */
  gradientColors: [string, string];
  /** 顶部轮播真实图片（Hot/media：hot_banner_1~4） */
  coverImg?: ResourceStr;
}

/** 列表缩略图类型 */
export type HotThumbType = 'image' | 'deal' | 'video';

/** 新闻列表项 */
export interface HotNewsItem {
  id: string;
  title: string;
  timeLabel: string;
  tag: string;
  commentCount: number;
  thumbType: HotThumbType;
  /** 缩略图渐变占位色 */
  thumbColors: [string, string];
  /** 缩略图真实图（优先于渐变） */
  coverImg?: ResourceStr;
  /** 缩略图角标文字，如视频播放、折扣格等 */
  thumbLabel?: string;
  /** 折扣宫格（deal 类型） */
  dealCells?: DealCell[];
  /** 是否在「全部」列表展示 */
  showInAll: boolean;
  /** 关联频道 id，用于后续过滤（可选） */
  channelIds?: string[];
}

export interface DealCell {
  discount: string;
  price: string;
  highlight?: boolean;
}

/** 热榜项 */
export interface HotRankItem {
  id: string;
  rank: number;
  title: string;
  readLabel: string;
  tag: string;
  commentCount: number;
  thumbColors: [string, string];
  thumbLabel?: string;
  /** 对应详情新闻 id，可复用正文 mock */
  newsId?: string;
}

/** 正文内嵌游戏卡片 */
export interface HotGameCard {
  name: string;
  rating: string;
  priceLabel: string;
  badge?: string;
  ownLabel?: string;
  gradientColors: [string, string];
  favoriteLabel?: string;
  /** 封面真实图 */
  coverImg?: ResourceStr;
  /** 封面角标折扣，如 -50% */
  discountLabel?: string;
}

/** 正文段落 / 列表 */
export interface HotContentBlock {
  type: 'paragraph' | 'bullet' | 'heading' | 'image' | 'game';
  text?: string;
  bullets?: string[];
  imageLabel?: string;
  imageIndex?: string;
  imageColors?: [string, string];
  /** 正文配图真实资源 */
  imageSrc?: ResourceStr;
  game?: HotGameCard;
}

/** 作者信息 */
export interface HotAuthor {
  name: string;
  level: string;
  levelColor: string;
  timeLocation: string;
  verified?: boolean;
  isAuthor?: boolean;
  avatarColors: [string, string];
  avatarText: string;
  /** 头像真实图 */
  avatarImg?: ResourceStr;
}

/** 评论回复 */
export interface HotReply {
  userName: string;
  content: string;
  timeLocation: string;
}

/** 评论 */
export interface HotComment {
  id: string;
  author: HotAuthor;
  content: string;
  likeCount: number;
  isPinned?: boolean;
  replies?: HotReply[];
}

/** 新闻详情数据（勿与页面组件 HotNewsDetail 同名） */
export interface HotNewsDetailData {
  id: string;
  title: string;
  author: HotAuthor;
  platforms: string[];
  blocks: HotContentBlock[];
  likeCount: number;
  starCount: number;
  shareCount: number;
  commentCount: number;
  comments: HotComment[];
  gameCard?: HotGameCard;
}

// ---------- Mock 数据 ----------

export const hotChannels: HotChannel[] = [
  { id: 'all', name: '全部', type: 'all' },
  { id: 'rank', name: '热榜', type: 'rank' },
  { id: 'stellar', name: '剑星', type: 'game' },
  { id: 'steam', name: 'Steam', type: 'game' },
  { id: 'tactics', name: '战术小队', type: 'game' },
  { id: 'pubg', name: '绝地求生', type: 'game' },
];

export const hotBanners: HotBanner[] = [
  {
    id: 'b1',
    title: '风暴枪弹现已发售，首发限时优惠点击抢购',
    cta: '现已发售点击抢购',
    gradientColors: ['#2A1A3A', '#5C2A1A'],
    coverImg: $r('app.media.hot_banner_1'),
  },
  {
    id: 'b2',
    title: '战地风云 6 第 4 赛季：海战回归，参与活动赢载具外观',
    cta: '海战回归',
    gradientColors: ['#0F1B2B', '#1A4A6A'],
    coverImg: $r('app.media.hot_banner_2'),
  },
  {
    id: 'b3',
    title: '碧蓝幻想 Relink：Endless Ragnarok',
    cta: '立即了解',
    gradientColors: ['#3A1A5A', '#1A0A2A'],
    coverImg: $r('app.media.hot_banner_3'),
  },
  {
    id: 'b4',
    title: 'PUBG：KUN 的夏日空投，蔡徐坤全球代言人',
    cta: 'K SPECIAL DELIVERY',
    gradientColors: ['#0A1A2A', '#1A2A4A'],
    coverImg: $r('app.media.hot_banner_4'),
  },
];

export const hotNewsList: HotNewsItem[] = [
  {
    id: 'news-steam-sale',
    title: '(7.24) Steam发大力！85款精品佳作迎来骨折价，最低仅需3元',
    timeLabel: '42分钟前',
    tag: 'Steam',
    commentCount: 20,
    thumbType: 'deal',
    thumbColors: ['#1A3A1A', '#0A1A0A'],
    // 列表仍用折扣宫格；详情用 新闻1-图片* 与博主头像
    dealCells: [
      { discount: '-100%', price: '¥ 0.00', highlight: true },
      { discount: '-80%', price: '¥ 14.60' },
      { discount: '-80%', price: '¥ 19.60' },
      { discount: '-84%', price: '¥ 42.80' },
      { discount: '-85%', price: '¥ 14.70' },
      { discount: '-85%', price: '¥ 11.10' },
      { discount: '-90%', price: '¥ 15.80' },
    ],
    showInAll: true,
    channelIds: ['steam'],
  },
  {
    id: 'news-stellar-mod',
    title: '剑星可爱白色蓬蓬裙伊芙 mods + 安装教程',
    timeLabel: '8小时前',
    tag: '剑星',
    commentCount: 12,
    thumbType: 'image',
    thumbColors: ['#4A5568', '#2D3748'],
    thumbLabel: 'MOD',
    showInAll: true,
    channelIds: ['stellar'],
  },
  {
    id: 'news-shadow-blade',
    title: '版号已至！《影之刃零》WeGame商店开启预约！',
    timeLabel: '3小时前',
    tag: 'Steam',
    commentCount: 336,
    thumbType: 'image',
    thumbColors: ['#3A2A1A', '#1A1008'],
    thumbLabel: '影之刃零',
    showInAll: true,
    channelIds: ['steam'],
  },
  {
    id: 'news-gta-titan',
    title: '[GTA 活动攻略]：参与泰坦差事领取一次性丰厚奖励',
    timeLabel: '2小时前',
    tag: '侠盗猎车手V',
    commentCount: 22,
    thumbType: 'image',
    thumbColors: ['#5A3A1A', '#2A1A0A'],
    thumbLabel: 'THE TITAN JOB',
    showInAll: true,
  },
  {
    id: 'news-steam-end',
    title: '【7.23】仅剩1天！不少折扣即将结束！骨折价。154款佳作',
    timeLabel: '昨天23:33',
    tag: 'Steam',
    commentCount: 17,
    thumbType: 'image',
    thumbColors: ['#6A4A1A', '#3A2A0A'],
    thumbLabel: '史低合集',
    showInAll: true,
    channelIds: ['steam'],
  },
  {
    id: 'news-gta-weekly',
    title: 'GTAOL周更攻略：新超跑伊格纳斯巡逻上架，首次完成泰...',
    timeLabel: '10小时前',
    tag: 'GTA Online',
    commentCount: 116,
    thumbType: 'image',
    thumbColors: ['#1A2A3A', '#0A1520'],
    thumbLabel: '超跑',
    showInAll: true,
  },
  {
    id: 'news-stellar-video',
    title: '这个废土的金刚差异不是很大',
    timeLabel: '1小时前',
    tag: '剑星',
    commentCount: 5,
    thumbType: 'video',
    thumbColors: ['#3A2A2A', '#1A1010'],
    thumbLabel: '▶',
    showInAll: true,
    channelIds: ['stellar'],
  },
  {
    id: 'news-pubg-vote',
    title: '【票数第一！】意识DT跪求粉丝投票：昨晚情绪激动，说...',
    timeLabel: '7小时前',
    tag: '绝地求生',
    commentCount: 180,
    thumbType: 'image',
    thumbColors: ['#2A2A3A', '#101018'],
    thumbLabel: '票数第一',
    showInAll: true,
    channelIds: ['pubg'],
  },
];

export const hotRankList: HotRankItem[] = [
  {
    id: 'rank-1',
    rank: 1,
    title: '《龙之剑：觉醒》现已发售，¥98/¥144.9，限时...',
    readLabel: '11.1万阅读',
    tag: 'DragonSword...',
    commentCount: 666,
    thumbColors: ['#4A6A9A', '#2A3A5A'],
    newsId: 'news-steam-sale',
  },
  {
    id: 'rank-2',
    rank: 2,
    title: 'Steam现已支持跨地区送礼！你们想的我试过了，...',
    readLabel: '9.6万阅读',
    tag: 'Steam',
    commentCount: 341,
    thumbColors: ['#1A3A5A', '#0A1A2A'],
    thumbLabel: '跨区送礼',
    newsId: 'news-steam-sale',
  },
  {
    id: 'rank-3',
    rank: 3,
    title: 'rain淘汰Falcons赛后采访：Not Today🍺',
    readLabel: '16.2万阅读',
    tag: 'CS2',
    commentCount: 482,
    thumbColors: ['#3A3A3A', '#1A1A1A'],
  },
  {
    id: 'rank-4',
    rank: 4,
    title: '大半夜看得我荡气回肠！冯骥盛赞DeepSeek梁文锋...',
    readLabel: '14.7万阅读',
    tag: 'Steam',
    commentCount: 422,
    thumbColors: ['#4A4A4A', '#2A2A2A'],
  },
  {
    id: 'rank-5',
    rank: 5,
    title: '积分下乡！Falcons翻车不敌100T、一轮游出局！',
    readLabel: '9.5万阅读',
    tag: 'CS2',
    commentCount: 638,
    thumbColors: ['#1A4A3A', '#0A2A1A'],
    thumbLabel: '2:1',
  },
  {
    id: 'rank-6',
    rank: 6,
    title: '胖东来出新规：员工禁止互相借钱，违规取消奖金与...',
    readLabel: '11.5万阅读',
    tag: '盒友杂谈',
    commentCount: 510,
    thumbColors: ['#5A6A8A', '#2A3A4A'],
  },
  {
    id: 'rank-7',
    rank: 7,
    title: '《影之刃 零》过审！国行版号批示！',
    readLabel: '8.6万阅读',
    tag: '影之刃零',
    commentCount: 504,
    thumbColors: ['#3A2A4A', '#1A1020'],
    thumbLabel: '2026 / 10 / 29',
    newsId: 'news-shadow-blade',
  },
];

/** 第一条新闻作者（塔可松）共用字段 */
const authorTacosong: HotAuthor = {
  name: '塔可松',
  level: 'Lv10',
  levelColor: '#9B6BFF',
  timeLocation: '42分钟前·浙江',
  verified: true,
  avatarColors: ['#5A2A2A', '#2A1010'],
  avatarText: '塔',
  avatarImg: $r('app.media.hot_news1_avatar'),
};

const detailSteamSale: HotNewsDetailData = {
  id: 'news-steam-sale',
  title: '(7.24) Steam发大力！85款精品佳作迎来骨折价，最低仅需3元',
  author: authorTacosong,
  platforms: ['Steam'],
  // 对照真实 App 详情底栏
  likeCount: 837,
  starCount: 187,
  shareCount: 93,
  commentCount: 20,
  blocks: [
    {
      type: 'paragraph',
      text: '今年即将到来的Steam游戏节时间：（北京时间）',
    },
    {
      type: 'bullet',
      bullets: [
        'Steam夏日特卖：6月26日——7月10日',
        '社交推理游戏节：7月14日——7月17日',
        '火车游戏节：7月21日——7月28日',
        '赛博朋克游戏节：8月4日——8月11日',
      ],
    },
    {
      type: 'paragraph',
      text: '帮大家整理了70款史低，15款新史低，关注我带你第一时间了解游戏折扣！',
    },
    {
      type: 'heading',
      text: '史低佳作区',
    },
    {
      type: 'paragraph',
      text: '1',
    },
    {
      type: 'game',
      game: {
        name: '怪物猎人：世界',
        rating: '9.5',
        priceLabel: '¥35 券后价',
        badge: '史低',
        favoriteLabel: '79万',
        gradientColors: ['#4A3A2A', '#1A1008'],
        coverImg: $r('app.media.hot_news1_img1'),
        discountLabel: '-74%',
      },
    },
    {
      type: 'image',
      imageLabel: '怪物猎人：世界',
      imageIndex: '1/17',
      imageColors: ['#3A2A1A', '#1A1008'],
      imageSrc: $r('app.media.hot_news1_img2'),
    },
    {
      type: 'paragraph',
      text: '2',
    },
    {
      type: 'game',
      game: {
        name: '街头霸王6',
        rating: '9.5',
        priceLabel: '¥90 券后价',
        badge: '史低',
        favoriteLabel: '36.3万',
        gradientColors: ['#5A2A1A', '#2A1008'],
        coverImg: $r('app.media.hot_news1_img3'),
        discountLabel: '-50%',
      },
    },
    {
      type: 'image',
      imageLabel: '街头霸王6',
      imageIndex: '1/28',
      imageColors: ['#5A2A1A', '#1A0A08'],
      imageSrc: $r('app.media.hot_news1_img4'),
    },
    {
      type: 'paragraph',
      text: '3',
    },
    {
      type: 'game',
      game: {
        name: '生化危机4 重制版',
        rating: '9.9',
        priceLabel: '¥45 券后价',
        badge: '史低',
        favoriteLabel: '65.1万',
        gradientColors: ['#2A1A1A', '#100808'],
        coverImg: $r('app.media.hot_news1_img5'),
        discountLabel: '-75%',
      },
    },
    {
      type: 'image',
      imageLabel: '生化危机4 重制版',
      imageIndex: '1/11',
      imageColors: ['#2A1A1A', '#100808'],
      imageSrc: $r('app.media.hot_news1_img6'),
    },
  ],
  comments: [
    {
      id: 'c1',
      isPinned: true,
      author: {
        name: authorTacosong.name,
        level: authorTacosong.level,
        levelColor: authorTacosong.levelColor,
        timeLocation: authorTacosong.timeLocation,
        verified: true,
        isAuthor: true,
        avatarColors: authorTacosong.avatarColors,
        avatarText: authorTacosong.avatarText,
        avatarImg: authorTacosong.avatarImg,
      },
      content: '可以双击屏幕点点免费的👍吗',
      likeCount: 0,
    },
    {
      id: 'c2',
      author: {
        name: '天兮、、',
        level: 'Lv15',
        levelColor: '#E8A838',
        timeLocation: '16分钟前·河北',
        avatarColors: ['#2A2A3A', '#101018'],
        avatarText: '天',
      },
      content: '请问平板的话可以玩什么游戏啊，刚买上不太懂，有大佬给点建议吗？谢谢',
      likeCount: 0,
      replies: [
        {
          userName: '玩家90932805',
          content: '星露谷',
          timeLocation: '14分钟前·浙江',
        },
        {
          userName: '正在寻找开放结局',
          content: '刷视频 看实况 打音游',
          timeLocation: '7分钟前·浙江',
        },
      ],
    },
  ],
};

const detailStellarMod: HotNewsDetailData = {
  id: 'news-stellar-mod',
  title: '剑星可爱白色蓬蓬裙伊芙 mods + 安装教程',
  author: {
    name: 'CHENSTUDIOS',
    level: 'Lv13',
    levelColor: '#E8A838',
    timeLocation: '9小时前·广东',
    verified: true,
    avatarColors: ['#4A3A5A', '#2A1A3A'],
    avatarText: '宸',
  },
  platforms: ['剑星', 'Steam'],
  likeCount: 86,
  starCount: 141,
  shareCount: 9,
  commentCount: 12,
  gameCard: {
    name: '剑星',
    rating: '9.1',
    priceLabel: '¥242 券后价',
    ownLabel: '已拥有',
    gradientColors: ['#2A3A5A', '#101828'],
  },
  blocks: [
    {
      type: 'image',
      imageLabel: '伊芙 白色蓬蓬裙 · 正面 / 背面',
      imageIndex: '1/4',
      imageColors: ['#5A6A7A', '#2A3440'],
    },
    {
      type: 'paragraph',
      text: '本帖分享剑星可爱白色蓬蓬裙伊芙 MOD 安装方式与效果预览，支持正版客户端。',
    },
    {
      type: 'heading',
      text: '安装步骤',
    },
    {
      type: 'bullet',
      bullets: [
        '下载 MOD 压缩包并解压',
        '将文件放入游戏 mods 目录',
        '启动游戏后在外观界面启用',
      ],
    },
    {
      type: 'image',
      imageLabel: '伊芙 展示图',
      imageIndex: '2/4',
      imageColors: ['#4A5A6A', '#1A2430'],
    },
  ],
  comments: [
    {
      id: 'c1',
      author: {
        name: 'CHENSTUDIOS',
        level: 'Lv13',
        levelColor: '#E8A838',
        timeLocation: '9小时前·广东',
        verified: true,
        isAuthor: true,
        avatarColors: ['#4A3A5A', '#2A1A3A'],
        avatarText: '宸',
      },
      content: '有问题评论区留言，看到会回~',
      likeCount: 12,
    },
    {
      id: 'c2',
      author: {
        name: '星尘旅人',
        level: 'Lv8',
        levelColor: '#6BB8FF',
        timeLocation: '3小时前·上海',
        avatarColors: ['#2A3A4A', '#101820'],
        avatarText: '星',
      },
      content: '太可爱了，已安装成功，感谢分享！',
      likeCount: 5,
    },
  ],
};

/** 通用占位详情（无专属正文时使用） */
function buildPlaceholderDetail(item: HotNewsItem): HotNewsDetailData {
  return {
    id: item.id,
    title: item.title,
    author: {
      name: '黑盒编辑部',
      level: 'Lv12',
      levelColor: '#9B6BFF',
      timeLocation: `${item.timeLabel}·小黑盒`,
      verified: true,
      avatarColors: item.thumbColors,
      avatarText: '盒',
    },
    platforms: [item.tag],
    likeCount: 20 + item.commentCount,
    starCount: 8,
    shareCount: 6,
    commentCount: item.commentCount,
    blocks: [
      {
        type: 'image',
        imageLabel: item.thumbLabel ?? item.tag,
        imageIndex: '1/3',
        imageColors: item.thumbColors,
      },
      {
        type: 'paragraph',
        text: `${item.title}（本篇为前端 Mock 正文，仅用于界面展示。）`,
      },
      {
        type: 'paragraph',
        text: '更多详情与真实数据接入后将替换此占位内容。欢迎在评论区讨论。',
      },
    ],
    comments: [
      {
        id: 'p1',
        author: {
          name: '路过的盒友',
          level: 'Lv5',
          levelColor: '#6BB8FF',
          timeLocation: '刚刚·广东',
          avatarColors: ['#3A3A4A', '#1A1A22'],
          avatarText: '路',
        },
        content: '先占个沙发，等正式内容～',
        likeCount: 1,
      },
    ],
  };
}

const detailMap: Record<string, HotNewsDetailData> = {
  'news-steam-sale': detailSteamSale,
  'news-stellar-mod': detailStellarMod,
};

export function getHotNewsById(id: string): HotNewsDetailData | undefined {
  if (detailMap[id]) {
    return detailMap[id];
  }
  const listItem = hotNewsList.find((n) => n.id === id);
  if (listItem) {
    return buildPlaceholderDetail(listItem);
  }
  // 热榜无独立详情时，尽量映射到 newsId 或占位
  const rank = hotRankList.find((r) => r.id === id || r.newsId === id);
  if (rank) {
    if (rank.newsId && detailMap[rank.newsId]) {
      return detailMap[rank.newsId];
    }
    return buildPlaceholderDetail({
      id: rank.id,
      title: rank.title,
      timeLabel: rank.readLabel,
      tag: rank.tag,
      commentCount: rank.commentCount,
      thumbType: 'image',
      thumbColors: rank.thumbColors,
      thumbLabel: rank.thumbLabel,
      showInAll: false,
    });
  }
  return undefined;
}

export function getAllFeedNews(): HotNewsItem[] {
  return hotNewsList.filter((n) => n.showInAll);
}
