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
  /** 列表右侧缩略图真实资源（优先于渐变） */
  coverImg?: ResourceStr;
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
    timeLabel: '昨天15:12',
    tag: '剑星',
    commentCount: 14,
    thumbType: 'image',
    thumbColors: ['#4A5568', '#2D3748'],
    thumbLabel: 'MOD',
    coverImg: $r('app.media.hot_news2_img1'),
    showInAll: true,
    channelIds: ['stellar'],
  },
  {
    id: 'news-hd2-report',
    title: '【HD2时报】鱿鱼发动100级入侵！',
    timeLabel: '昨天23:21',
    tag: '绝地潜兵2',
    commentCount: 56,
    thumbType: 'image',
    thumbColors: ['#4A1A1A', '#1A0808'],
    thumbLabel: 'HD2',
    // 列表缩略图：新闻3-列表缩略图.png
    coverImg: $r('app.media.hot_news3_thumb'),
    showInAll: true,
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

/** 热榜列表（对照 热榜总图 1–10） */
export const hotRankList: HotRankItem[] = [
  {
    id: 'rank-1',
    rank: 1,
    title: '装机噩耗！显卡即将迎来暴涨！华硕官涨、主播下架...',
    readLabel: '11.8万阅读',
    tag: '数码硬件',
    commentCount: 982,
    thumbColors: ['#1A2A1A', '#0A1A0A'],
    coverImg: $r('app.media.hot_rank1_img1'),
    newsId: 'news-gpu-price',
  },
  {
    id: 'rank-2',
    rank: 2,
    title: '获2.3亿元投资，网游改单机，他们把一款二游卖到...',
    readLabel: '11.1万阅读',
    tag: 'Steam',
    commentCount: 503,
    thumbColors: ['#3A4A6A', '#1A2438'],
    thumbLabel: '二游',
  },
  {
    id: 'rank-3',
    rank: 3,
    title: '老大，你的显卡升值了！英伟达宣布涨价！渠道封仓...',
    readLabel: '8.3万阅读',
    tag: '盒友杂谈',
    commentCount: 662,
    thumbColors: ['#1A3A5A', '#0A1A2A'],
    thumbLabel: '显卡涨价',
  },
  {
    id: 'rank-4',
    rank: 4,
    title: '26版西游记杀疯了！单周涨粉200万，全即兴',
    readLabel: '19.3万阅读',
    tag: '盒友杂谈',
    commentCount: 536,
    thumbColors: ['#6A3A2A', '#3A1A10'],
    thumbLabel: '西游记',
  },
  {
    id: 'rank-5',
    rank: 5,
    title: '《影之刃 零》过审！国行版号批示！',
    readLabel: '11.3万阅读',
    tag: '影之刃零',
    commentCount: 646,
    thumbColors: ['#3A2A4A', '#1A1020'],
    thumbLabel: '2026 / 10 / 29',
    newsId: 'news-shadow-blade',
  },
  {
    id: 'rank-6',
    rank: 6,
    title: '《昭和米国物语》将参加科隆游戏展，包含现场试玩...',
    readLabel: '9.3万阅读',
    tag: '昭和米国物语',
    commentCount: 492,
    thumbColors: ['#8A5A2A', '#4A2A10'],
    thumbLabel: '科隆',
  },
  {
    id: 'rank-7',
    rank: 7,
    title: '悲剧！外国抗癌主播惨遭盗窃，嫌疑人时隔一年终于...',
    readLabel: '12.2万阅读',
    tag: 'Steam',
    commentCount: 140,
    thumbColors: ['#4A2A3A', '#201018'],
    thumbLabel: '主播',
  },
  {
    id: 'rank-8',
    rank: 8,
    title: 'Falcons成为史上第二支赢得Major后在首个赛事中...',
    readLabel: '9.5万阅读',
    tag: 'CS2',
    commentCount: 271,
    thumbColors: ['#2A3A2A', '#101810'],
    thumbLabel: 'Major',
  },
  {
    id: 'rank-9',
    rank: 9,
    title: '40/50都开涨：据报道NVIDIA已提高了GDDR7...',
    readLabel: '7.1万阅读',
    tag: 'Steam',
    commentCount: 533,
    thumbColors: ['#1A2A3A', '#0A1520'],
    thumbLabel: 'GDDR7',
  },
  {
    id: 'rank-10',
    rank: 10,
    title: '电影《生化危机：爆发夜》全新预告发布，9月17日...',
    readLabel: '9.3万阅读',
    tag: '生化危机2重...',
    commentCount: 216,
    thumbColors: ['#3A1A1A', '#1A0808'],
    thumbLabel: '爆发夜',
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

/** 新闻2 作者 CHENSTUDIOS */
const authorChenStudios: HotAuthor = {
  name: 'CHENSTUDIOS',
  level: 'Lv13',
  levelColor: '#E8A838',
  timeLocation: '昨天15:12·广东',
  verified: true,
  avatarColors: ['#4A3A5A', '#2A1A3A'],
  avatarText: '宸',
  avatarImg: $r('app.media.hot_news2_avatar'),
};

const detailStellarMod: HotNewsDetailData = {
  id: 'news-stellar-mod',
  title: '剑星可爱白色蓬蓬裙伊芙 mods + 安装教程',
  author: authorChenStudios,
  platforms: ['剑星', 'Steam', 'steam游戏'],
  // 对照真实 App 详情底栏 / 评论数
  likeCount: 86,
  starCount: 141,
  shareCount: 9,
  commentCount: 14,
  gameCard: {
    name: '剑星',
    rating: '9.1',
    priceLabel: '¥242 券后价',
    ownLabel: '已拥有',
    gradientColors: ['#2A3A5A', '#101828'],
    coverImg: $r('app.media.hot_news2_game'),
  },
  blocks: [
    {
      type: 'image',
      imageLabel: '伊芙 白色蓬蓬裙 · 正面 / 背面',
      imageIndex: '1/5',
      imageColors: ['#5A6A7A', '#2A3440'],
      imageSrc: $r('app.media.hot_news2_img1'),
    },
    {
      type: 'image',
      imageLabel: '工业场景对比',
      imageIndex: '2/5',
      imageColors: ['#6A5A4A', '#3A2A20'],
      imageSrc: $r('app.media.hot_news2_img2'),
    },
    {
      type: 'image',
      imageLabel: '湖边场景',
      imageIndex: '3/5',
      imageColors: ['#4A7A6A', '#2A4A3A'],
      imageSrc: $r('app.media.hot_news2_img3'),
    },
    {
      type: 'image',
      imageLabel: '峡谷 · ver2.0',
      imageIndex: '4/5',
      imageColors: ['#8A7A5A', '#4A3A2A'],
      imageSrc: $r('app.media.hot_news2_img4'),
    },
    {
      type: 'image',
      imageLabel: '太空场景',
      imageIndex: '5/5',
      imageColors: ['#1A3A6A', '#0A1A3A'],
      imageSrc: $r('app.media.hot_news2_img5'),
    },
    {
      type: 'heading',
      text: '安装路径',
    },
    {
      type: 'paragraph',
      text: '\\StellarBlade\\SB\\Content\\Paks\\~mods\\',
    },
    {
      type: 'paragraph',
      text: '白色蓬蓬裙编号2990',
    },
    {
      type: 'heading',
      text: '已知可能遇到的问题',
    },
    {
      type: 'paragraph',
      text:
        '若模组已显示在 CNS 菜单中，却无法生成模型网格，大概率是存在其他模组与该模组使用了相同的区块 ID（Chunk ID）从而引发冲突。目前暂无可行修复方案，CNS 工具的开发者正在开发一款专用软件来解决此问题，但该过程需要一定时间。',
    },
  ],
  comments: [
    {
      id: 'sc1',
      author: {
        name: '哈哈哈嘻哈哈',
        level: 'Lv17',
        levelColor: '#E8A838',
        timeLocation: '昨天16:16·广西',
        avatarColors: ['#3A2A4A', '#1A1020'],
        avatarText: '哈',
      },
      content: '你怎么穿着母主的衣服',
      likeCount: 0,
      replies: [
        {
          userName: '幻梦之翼 模组乱码',
          content: '确实有点像…',
          timeLocation: '昨天16:30·河北',
        },
      ],
    },
    {
      id: 'sc2',
      author: {
        name: '玩家28355303',
        level: 'Lv5',
        levelColor: '#6BB8FF',
        timeLocation: '10小时前·辽宁',
        avatarColors: ['#2A3A4A', '#101820'],
        avatarText: '玩',
      },
      content: '剑星mod',
      likeCount: 0,
    },
    {
      id: 'sc3',
      author: {
        name: '鲤鱼也是鱼',
        level: 'Lv8',
        levelColor: '#6BB8FF',
        timeLocation: '昨天21:44·河北',
        avatarColors: ['#4A3A2A', '#201810'],
        avatarText: '鲤',
      },
      content: '为什么我找不到丝袜啊，只有过膝袜和花边袜',
      likeCount: 0,
    },
    {
      id: 'sc4',
      author: {
        name: '玩家86128639',
        level: 'Lv6',
        levelColor: '#6BB8FF',
        timeLocation: '昨天20:18·河北',
        avatarColors: ['#2A2A3A', '#101018'],
        avatarText: '玩',
      },
      content: '剑星伊芙蓬蓬裙mod',
      likeCount: 0,
    },
    {
      id: 'sc5',
      author: {
        name: '比奇堡风流往事',
        level: 'Lv9',
        levelColor: '#9B6BFF',
        timeLocation: '昨天19:45·澳大利亚',
        avatarColors: ['#3A4A2A', '#1A2010'],
        avatarText: '比',
      },
      content: '太可爱了吧',
      likeCount: 0,
    },
    {
      id: 'sc6',
      author: {
        name: '弯一折纸z',
        level: 'Lv7',
        levelColor: '#6BB8FF',
        timeLocation: '昨天19:30·河南',
        avatarColors: ['#4A2A3A', '#201018'],
        avatarText: '弯',
      },
      content: '剑星伊芙蓬蓬裙mod',
      likeCount: 1,
    },
    {
      id: 'sc7',
      author: {
        name: '黑神话-悟空',
        level: 'Lv10',
        levelColor: '#E8A838',
        timeLocation: '昨天16:50·陕西',
        avatarColors: ['#3A2A1A', '#1A1008'],
        avatarText: '黑',
      },
      content: '可爱',
      likeCount: 1,
    },
    {
      id: 'sc8',
      author: {
        name: 'Hao2e',
        level: 'Lv11',
        levelColor: '#E8A838',
        timeLocation: '昨天16:14·天津',
        avatarColors: ['#2A3A5A', '#101828'],
        avatarText: 'H',
      },
      content: '剑星伊芙蓬蓬裙mod',
      likeCount: 0,
    },
  ],
};

/** 新闻3 作者「绝地潜兵宣传部」 */
const authorHd2Propaganda: HotAuthor = {
  name: '绝地潜兵宣传部',
  level: 'Lv.17',
  levelColor: '#E53935',
  timeLocation: '昨天23:21·辽宁',
  verified: true,
  avatarColors: ['#3A4A5A', '#1A2430'],
  avatarText: '潜',
  avatarImg: $r('app.media.hot_news3_avatar'),
};

/** 新闻3：【HD2时报】鱿鱼发动100级入侵（对照 新闻3 正文及评论截图） */
const detailHd2Report: HotNewsDetailData = {
  id: 'news-hd2-report',
  title: '【HD2时报】鱿鱼发动100级入侵！',
  author: authorHd2Propaganda,
  platforms: ['绝地潜兵2'],
  likeCount: 210,
  starCount: 48,
  shareCount: 32,
  commentCount: 56,
  blocks: [
    {
      type: 'heading',
      text: '新战略机遇已发布',
    },
    {
      type: 'paragraph',
      text: '好消息，我们截获了情报并来到了卡戎主星。',
    },
    {
      type: 'paragraph',
      text: '坏消息，没时间为情报哀悼了，接下来登场的是情报碎片。',
    },
    {
      type: 'paragraph',
      text: '现在，全体潜兵需要在卡戎主星上击杀1亿只机器人以合成完整的情报🚀',
    },
    {
      type: 'image',
      imageLabel: '全新战略机遇',
      imageIndex: '1/4',
      imageColors: ['#1A1A1A', '#0A0A0A'],
      imageSrc: $r('app.media.hot_news3_img1'),
    },
    {
      type: 'paragraph',
      text: '而现在，距离战略机遇失效仅剩41h，完成度仍不足7%。',
    },
    {
      type: 'image',
      imageLabel: '战略机遇进度',
      imageIndex: '2/4',
      imageColors: ['#1A0A1A', '#0A0510'],
      imageSrc: $r('app.media.hot_news3_img2'),
    },
    {
      type: 'heading',
      text: '科埃佩萨IV保卫战大获全胜',
    },
    {
      type: 'paragraph',
      text: '敌人先前出动的入侵等级30的部队已被击溃，科埃佩萨IV已是超级地球的囊中之物。',
    },
    {
      type: 'image',
      imageLabel: '科埃佩萨IV 防御战',
      imageIndex: '3/4',
      imageColors: ['#2A2A3A', '#101018'],
      imageSrc: $r('app.media.hot_news3_img3'),
    },
    {
      type: 'heading',
      text: '鱿鱼发动100级入侵！',
    },
    {
      type: 'paragraph',
      text: '与此同时，一个无人在意的角落里，遭到光能者100级入侵的角宿二湾轻轻的碎了。',
    },
    {
      type: 'paragraph',
      text: '若潜兵们不及时制止，光能者的寂域将很快笼罩这颗星球。',
    },
    {
      type: 'image',
      imageLabel: '角宿二湾 解放战役',
      imageIndex: '4/4',
      imageColors: ['#4A2A3A', '#201018'],
      imageSrc: $r('app.media.hot_news3_img4'),
    },
  ],
  // 评论按 新闻3-正文及评论截图 热门区原文，不杜撰
  comments: [
    {
      id: 'h1',
      author: {
        name: '特尼昂的',
        level: 'Lv.16',
        levelColor: '#E53935',
        timeLocation: '昨天23:42·广东',
        avatarColors: ['#3A3A4A', '#1A1A22'],
        avatarText: '特',
      },
      content: '收不到，已回归平民生活🤪😁',
      likeCount: 39,
      replies: [
        {
          userName: '特尼昂的',
          content: '现在只喜欢带坦克停机坪铲飞鹅鹅可惜小车铲不飞了现在',
          timeLocation: '昨天23:43·广东',
        },
        {
          userName: '绝地潜兵宣传部',
          content: '退伍申请已驳回🚀',
          timeLocation: '9小时前·辽宁',
        },
      ],
    },
    {
      id: 'h2',
      author: {
        name: 'ASh14C',
        level: 'Lv.18',
        levelColor: '#E53935',
        timeLocation: '昨天23:52·广东',
        avatarColors: ['#1A1A1A', '#0A0A0A'],
        avatarText: 'A',
      },
      content: '南线无战事😎',
      likeCount: 19,
      replies: [
        {
          userName: '绝地潜兵宣传部',
          content: '好！既然如此 最高指挥部已决定将你送往角宿二湾度假了🫡',
          timeLocation: '9小时前·辽宁',
        },
      ],
    },
    {
      id: 'h3',
      author: {
        name: '商卿参宿',
        level: 'Lv.17',
        levelColor: '#E53935',
        timeLocation: '昨天23:32·湖北',
        avatarColors: ['#E8D0C0', '#8A6A5A'],
        avatarText: '商',
      },
      content: '南线占领者谁爱玩谁玩去吧，再见了，角小弟🐣',
      likeCount: 28,
      replies: [
        {
          userName: '绝地潜兵宣传部',
          content: '😭',
          timeLocation: '昨天23:32·辽宁',
        },
        {
          userName: 'WAIT_A_SEC_',
          content: '我宁愿去奥密克戎和生化斯坦也不想去打鱿鱼😭',
          timeLocation: '昨天23:33·广东',
        },
      ],
    },
    {
      id: 'h4',
      author: {
        name: 'RinYuki',
        level: 'Lv.9',
        levelColor: '#6BB8FF',
        timeLocation: '3小时前·浙江',
        avatarColors: ['#C0B0C0', '#6A5A6A'],
        avatarText: 'R',
      },
      content:
        '大家都不爱打南线占领者吗🤪？虽然怎么看都是必输的，但是打腻了跟机器人的超级地球内战，再打打外星乡巴佬正规军换换口味还是挺好玩的，穿上电甲电榴弹，有挑战还不至于太难',
      likeCount: 3,
      replies: [
        {
          userName: '绝地潜兵宣传部',
          content:
            '这个就是箭头设计的问题了😭东线西线各有各的爽点，唯独南线这个集大成者几乎没什么正反馈😭打倒是也能打，就是相当难受😭',
          timeLocation: '3小时前·辽宁',
        },
        {
          userName: '玩家30184470',
          content:
            '如果每把都是电榴弹机炮那确实挺无聊的，而且异界风暴导致沙尘暴常驻，炮台全废了',
          timeLocation: '1小时前·福建',
        },
      ],
    },
    {
      id: 'h5',
      author: {
        name: '白银山神秘帽子男',
        level: 'Lv.12',
        levelColor: '#9B6BFF',
        timeLocation: '昨天23:59·新加坡',
        avatarColors: ['#E0C0A0', '#8A6A40'],
        avatarText: '白',
      },
      content: '100级的南线入侵，那还是直接打到容都去吧',
      likeCount: 8,
      replies: [
        {
          userName: '绝地潜兵宣传部',
          content: '只要不动超级on sea就行😊',
          timeLocation: '9小时前·辽宁',
        },
      ],
    },
    {
      id: 'h6',
      author: {
        name: '漫步沙场',
        level: 'Lv.28',
        levelColor: '#1A1A1A',
        timeLocation: '5小时前·上海',
        avatarColors: ['#2A5A6A', '#103040'],
        avatarText: '漫',
      },
      content: '感觉机器人的地盘连一半都不到了，虫子地',
      likeCount: 5,
    },
  ],
};

/** 热榜1 作者「漂亮的秀色」 */
const authorPrettyShow: HotAuthor = {
  name: '漂亮的秀色',
  level: 'Lv14',
  levelColor: '#E8A838',
  timeLocation: '3小时前·广东',
  verified: true,
  avatarColors: ['#8A6A5A', '#4A3A2A'],
  avatarText: '秀',
  avatarImg: $r('app.media.hot_rank1_avatar'),
};

/** 热榜第1：装机噩耗 / 显卡暴涨（对照 热榜1-内容截图） */
const detailGpuPrice: HotNewsDetailData = {
  id: 'news-gpu-price',
  title: '装机噩耗！显卡即将迎来暴涨！华硕官涨、主播下架、厂商封仓',
  author: authorPrettyShow,
  platforms: ['数码硬件', '盒友杂谈'],
  likeCount: 1280,
  starCount: 356,
  shareCount: 210,
  commentCount: 982,
  blocks: [
    {
      type: 'paragraph',
      text:
        '一波来势汹汹的显卡涨价潮正在酝酿。据渠道消息和博主爆料，50系显卡将迎来官方涨价，部分型号涨幅不小。',
    },
    {
      type: 'image',
      imageLabel: 'RTX 显卡',
      imageIndex: '1/5',
      imageColors: ['#1A2A1A', '#0A1A0A'],
      imageSrc: $r('app.media.hot_rank1_img1'),
    },
    {
      type: 'paragraph',
      text:
        '已得到 NVIDIA 通知：接下来 8G 显存将会涨价 600，12G 涨价 900，16G 涨价 1200，并且立即生效。这个视频是最后一批涨价前的显卡，如有需要大家尽快入手吧。',
    },
    {
      type: 'image',
      imageLabel: '渠道涨价通知',
      imageIndex: '2/5',
      imageColors: ['#F5F5F5', '#E0E0E0'],
      imageSrc: $r('app.media.hot_rank1_img2'),
    },
    {
      type: 'paragraph',
      text: '渠道群内也陆续出现封仓、惜售通知：60TI 暂时芯片进不来，今日起公司封仓，马上要全部涨价。',
    },
    {
      type: 'image',
      imageLabel: '封仓通知',
      imageIndex: '3/5',
      imageColors: ['#F0F0F0', '#D8D8D8'],
      imageSrc: $r('app.media.hot_rank1_img3'),
    },
    {
      type: 'image',
      imageLabel: '涨价通知',
      imageIndex: '4/5',
      imageColors: ['#F0F0F0', '#D8D8D8'],
      imageSrc: $r('app.media.hot_rank1_img4'),
    },
    {
      type: 'paragraph',
      text:
        '综合多方信息，50 系主流型号（如 RTX 5070 / 5060 系列）的渠道报价与供货节奏都在收紧。若近期有装机或升级计划，建议关注官方与授权渠道动态，避免盲目追高。',
    },
    {
      type: 'image',
      imageLabel: 'NVIDIA',
      imageIndex: '5/5',
      imageColors: ['#101010', '#1A2A1A'],
      imageSrc: $r('app.media.hot_rank1_img5'),
    },
    {
      type: 'heading',
      text: '简要结论',
    },
    {
      type: 'bullet',
      bullets: [
        '渠道确认多档显存规格将同步上调报价',
        '部分厂商/代理已出现封仓、惜售',
        '装机用户宜对比多店与历史价，按需出手',
      ],
    },
  ],
  // 评论按 热榜1-内容截图 热门区原文录入，不杜撰
  comments: [
    {
      id: 'g1',
      author: {
        name: 'envy',
        level: 'Lv.18',
        levelColor: '#E53935',
        timeLocation: '昨天23:06·江苏',
        avatarColors: ['#3A1A1A', '#1A0808'],
        avatarText: 'e',
      },
      content: '有种让让游戏行业死翘翘，地球所有产业服务AI得了😊。',
      likeCount: 823,
      replies: [
        {
          userName: '安墨',
          content: 'AI让我买不起设备，AI还要抢我的工作😭',
          timeLocation: '昨天23:11·湖北',
        },
        {
          userName: '卡卡罗卜卜',
          content:
            '游戏那点份额真别拿出来说了，你要说说手机啥的还好点，听过举国造车，举国造手机，举国造AI，谁听过举国造游戏啊',
          timeLocation: '昨天23:36·内蒙古',
        },
      ],
    },
    {
      id: 'g2',
      author: {
        name: 'anjuxkx',
        level: 'Lv.20',
        levelColor: '#1A1A1A',
        timeLocation: '昨天23:10·吉林',
        avatarColors: ['#4A7AB0', '#2A4A70'],
        avatarText: 'a',
      },
      content: '臭打游戏的从30系开始就没过过几天好日子😭',
      likeCount: 429,
      replies: [
        {
          userName: '逸心安Miguel',
          content: '24年还好，我就双11装的，都不太贵。',
          timeLocation: '昨天23:17·陕西',
        },
        {
          userName: '牢川258',
          content: '前几年矿潮崩盘的时候不就挺好的，4090有半年时间都能原价买',
          timeLocation: '昨天23:40·湖南',
        },
      ],
    },
    {
      id: 'g3',
      author: {
        name: 'yuusaku',
        level: 'Lv.27',
        levelColor: '#1A1A1A',
        timeLocation: '13小时前·湖南',
        avatarColors: ['#5A6A7A', '#2A3440'],
        avatarText: 'y',
      },
      content: '这辈子不用换了 这个涨完涨那个左脚踩右脚螺旋升天涨 只有工资不见涨😑',
      likeCount: 363,
      replies: [
        {
          userName: 'しん',
          content: '给你们涨涨房租❤️',
          timeLocation: '8小时前·上海',
        },
        {
          userName: '云淡青',
          content: '回复 しん: 沪爷nb',
          timeLocation: '7小时前·陕西',
        },
      ],
    },
    {
      id: 'g4',
      author: {
        name: '只道花无十日红',
        level: 'Lv.10',
        levelColor: '#9B6BFF',
        timeLocation: '13小时前·吉林',
        avatarColors: ['#6A5A7A', '#3A2A4A'],
        avatarText: '只',
      },
      content:
        '涨吧涨吧，你们就涨吧！涨得整个DIY市场鸡飞狗跳，把这装机圈子搞黄了，老子无非把钱砸手里面就是！',
      likeCount: 214,
      replies: [
        {
          userName: '吃柠檬不说酸',
          content: '😭',
          timeLocation: '13小时前·河南',
        },
        {
          userName: '额上面有人',
          content: '我怎么磕巴的读完的评论😵‍💫',
          timeLocation: '9小时前·吉林',
        },
      ],
    },
    {
      id: 'g5',
      author: {
        name: '杜七说得对',
        level: 'Lv.18',
        levelColor: '#E53935',
        timeLocation: '15小时前·浙江',
        avatarColors: ['#3A3A4A', '#1A1A22'],
        avatarText: '杜',
      },
      content:
        '这是好事啊，天下苦这群啥鎏厂商的优化久矣，是时候该回归游戏应有的占用了。',
      likeCount: 157,
      replies: [
        {
          userName: 'lamSB',
          content: '赞同，让那些厂商舒服了这么多年力大砖飞，现在该他们还债的时候了😊',
          timeLocation: '7小时前·重庆',
        },
        {
          userName: '专业掉节操',
          content: '这么多条评论，你是最对的 哥们，还不如拉优化',
          timeLocation: '5小时前·广东',
        },
      ],
    },
    {
      id: 'g6',
      author: {
        name: 'auv1',
        level: 'Lv.16',
        levelColor: '#E53935',
        timeLocation: '14小时前·陕西',
        avatarColors: ['#4A3A2A', '#201810'],
        avatarText: 'a',
      },
      content: '玩辣钱要砸在手里了',
      likeCount: 184,
      replies: [
        {
          userName: '正在加载中.',
          content: '三瓜两枣的',
          timeLocation: '10小时前·北京',
        },
        {
          userName: '道行山下',
          content: '回复 正在加载中.: 京✌️ v50看看实力',
          timeLocation: '8小时前·河南',
        },
      ],
    },
    {
      id: 'g7',
      author: {
        name: 'KkGOD1',
        level: 'Lv.26',
        levelColor: '#1A1A1A',
        timeLocation: '12小时前·天津',
        avatarColors: ['#5A2A2A', '#2A1010'],
        avatarText: 'K',
      },
      content:
        '25年年初配电脑真是最好的选择了😭，谁能想到短短一年半，我的电脑就成了整个家中最贵的东西了😭，地震了都得带着她跑路😭',
      likeCount: 62,
      replies: [
        {
          userName: '华北理工大学招生办-',
          content: '我也是25年初的，配的4060，好像过了半年多，内存条就开始涨价了',
          timeLocation: '8小时前·河北',
        },
        {
          userName: '可这就是我',
          content: '😭😭😭',
          timeLocation: '8小时前·四川',
        },
      ],
    },
    {
      id: 'g8',
      author: {
        name: '青梅竹马不会输',
        level: 'Lv.16',
        levelColor: '#E53935',
        timeLocation: '11小时前·广东',
        avatarColors: ['#3A5A7A', '#1A2A3A'],
        avatarText: '青',
      },
      content:
        '无所谓，虚拟货币的时候不也吹无限涨价？记住经济学说的没有任何东西可以永远“涨价”的，十年二十年AI能锤那么久空中楼阁吗？',
      likeCount: 40,
      replies: [
        {
          userName: 'NormalNeko',
          content: '比特币现在没跌吧',
          timeLocation: '9小时前·广东',
        },
        {
          userName: '喵喵露利普贝当',
          content: '买台电脑能等十年吗 那很能等了',
          timeLocation: '9小时前·日本',
        },
      ],
    },
    {
      id: 'g9',
      author: {
        name: 'Flashbacks',
        level: 'Lv.22',
        levelColor: '#1A1A1A',
        timeLocation: '8小时前·北京',
        avatarColors: ['#E8C080', '#8A6A40'],
        avatarText: 'F',
      },
      content:
        '去年年初我做了一个梦，梦见未来电脑各种硬件被美国制裁，大陆将买不到电脑，于是配了一台台式，虽然这波并非制裁，但好歹也是在最便宜的时候买到电脑了',
      likeCount: 22,
      replies: [
        {
          userName: '玩家16702684',
          content:
            '也算是制裁了，但不制裁硬件涨的只会更快，毕竟就算你拿鞭子抽老黄，老黄也拿不出那么多计算卡出来',
          timeLocation: '8小时前·安徽',
        },
        {
          userName: '柿子李天下',
          content: '他要真敢制裁那真好了，直接放开了😊',
          timeLocation: '8小时前·北京',
        },
      ],
    },
    {
      id: 'g10',
      author: {
        name: '冯多鸡撒句嘞',
        level: 'Lv.30',
        levelColor: '#2A8A6A',
        timeLocation: '10小时前·浙江',
        avatarColors: ['#4A8AC0', '#1A4A70'],
        avatarText: '冯',
      },
      content: '1660用了8年了😭😭😭😭😭',
      likeCount: 19,
      replies: [
        {
          userName: '奔波儿坝',
          content: '1060还在用',
          timeLocation: '7小时前·陕西',
        },
      ],
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
        imageSrc: item.coverImg,
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
  'news-hd2-report': detailHd2Report,
  'news-gpu-price': detailGpuPrice,
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
      coverImg: rank.coverImg,
      showInAll: false,
    });
  }
  return undefined;
}

export function getAllFeedNews(): HotNewsItem[] {
  return hotNewsList.filter((n) => n.showInAll);
}
