/**
 * 游戏库模块数据模型
 */

export interface HeaderToolItem {
  title: string;
  icon?: string;
  version?: string;
}

export interface GameItem {
  id: string;
  title: string;               // 中文标题，如 "Palworld / 幻兽帕鲁"
  englishTitle: string;        // 英文/开发商名，用于详情页副标题
  gradientColors: [string, string]; // 封面占位渐变色
  coverImg?: ResourceStr;       // 封面真实图片资源
  price: number;                // 券后价 / 现价
  originalPrice?: number;       // 原价（有值时显示删除线）
  lowestPrice?: number;         // 史低价格（如 14.7, 6.7, 41.6）
  discountPercent?: number;     // 折扣百分比，如 30 表示 -30%
  couponLabel?: string;         // 例如 "领券95折"
  lowestLabel?: string;         // 例如 "新史低" / "史低"
  rankLabel?: string;           // 例如 "最受欢迎榜 No.1"
  rankBoard?: string;           // 榜单来源，例如 "商城热销榜 No.4"
  tags: string[];               // 游戏类型主要标签
  secondaryTags?: string[];      // 游戏次要标签（如 女性主角, 三人人称）
  rating?: number;              // 评分，如 9.5
  ratingColor?: string;         // 评分角标颜色
  ratingCount?: string;         // 评分人数，如 "2.0万人评分"
  favoriteCount?: string;       // 收藏数
  onlineNow?: string;           // 当前在线
  yesterdayPeak?: string;       // 昨日峰值在线
  peakRank?: string;            // 昨日峰值排名（如 "#496"）
  monthAvgOnline?: string;      // 本月平均在线（如 "2807"）
  monthAvgRank?: string;        // 本月平均在线排名（如 "#476"）
  globalSalesRank?: string;     // 全球销量排行（如 "#2"）
  blackBoxPlayers?: string;     // 小黑盒玩家数（如 "421.4万"）
  playersRank?: string;         // 小黑盒玩家排名（如 "#68"）
  avgPlayTime?: string;         // 平均游戏时间（如 "17.9h"）
  playTimeRank?: string;        // 平均时间排名（如 "#12094"）
  goodRate?: string;            // 全语言好评率（如 "94%"）
  wishlistCount?: string;       // 心愿单人数（如 "45.1w"）
  awardLabel?: string;          // 奖项标签（如 Steam大奖 2017 "维特鲁威的灵魂"奖）
  hasDeveloperIn?: boolean;     // 是否开发者入驻
  deckSupport?: string;         // Steam Deck 支持度 ('verified', 'playable', 'unsupported')
  hasDatabaseTab?: boolean;     // 是否包含数据库 Tab
  headerTheme?: 'orange' | 'teal' | 'white'; // 顶部主题风格 ('orange', 'teal', 'white')
  headerTools?: HeaderToolItem[]; // 顶部快捷工具卡片
  customTabs?: string[];        // 自定义 Tab 页签
  intro?: string;               // 游戏简介
  platformIcon?: string;        // 平台标识如 'steam'
}

export const gameList: GameItem[] = [
  {
    id: 'palworld',
    title: 'Palworld / 幻兽帕鲁',
    englishTitle: 'Palworld',
    gradientColors: ['#8FD3E8', '#5B9BD5'],
    coverImg: $r('app.media.Palworld'),
    price: 72,
    originalPrice: 108,
    lowestPrice: 72,
    discountPercent: 30,
    couponLabel: '领券95折',
    lowestLabel: '新史低',
    rankLabel: '最受欢迎榜 No.1',
    rankBoard: '优惠促销榜 No.1',
    tags: ['开放世界', '生存', '角色扮演'],
    secondaryTags: ['抓宠', '基建', '多人合作', '独立'],
    rating: 9.3,
    ratingColor: '#FF7A00',
    favoriteCount: '5.6万',
    onlineNow: '54.0万',
    yesterdayPeak: '77.9万',
    peakRank: '#2',
    monthAvgOnline: '62.3万',
    monthAvgRank: '#3',
    globalSalesRank: '#2',
    blackBoxPlayers: '693.6万',
    playersRank: '#5',
    avgPlayTime: '66.6h',
    playTimeRank: '#120',
    goodRate: '94%',
    ratingCount: '3.9万人评分',
    wishlistCount: '83.4w',
    hasDeveloperIn: true,
    deckSupport: 'playable',
    headerTheme: 'teal',
    headerTools: [
      { title: '实时地图', icon: '🗺️', version: '1.0正式版' },
      { title: '我的帕鲁', icon: '🧳', version: '1.0正式版' },
      { title: '帕鲁图鉴', icon: '📘', version: '1.0正式版' },
      { title: '孵蛋计算器', icon: '📊', version: '1.0正式版' },
      { title: '物品数据库', icon: '🗃️', version: '1.0正式版' },
    ],
    customTabs: ['游戏', '社区', '战绩', '图鉴', '统计'],
    intro: '在这片被称为"帕鲁"的神秘大陆上，你可以自由地探索、采集、战斗、建造——还能捕捉、饲养和并肩作战的奇异生物"帕鲁"们一起生活。',
  },
  {
    id: 'party-animals',
    title: '猛兽派对',
    englishTitle: 'Party Animals',
    gradientColors: ['#F5A623', '#D0021B'],
    coverImg: $r('app.media.party'),
    price: 53,
    originalPrice: 98,
    lowestPrice: 49,
    discountPercent: 40,
    couponLabel: '领券9折',
    rankBoard: '商城热销榜 No.9',
    tags: ['多人', '欢乐', '动作'],
    secondaryTags: ['休闲', '独立', '派对', '可爱', '物理'],
    rating: 7.6,
    ratingColor: '#B366FF',
    ratingCount: '6708人评分',
    onlineNow: '1769',
    yesterdayPeak: '7951',
    peakRank: '#207',
    monthAvgOnline: '5430',
    monthAvgRank: '#310',
    globalSalesRank: '#447',
    blackBoxPlayers: '264.7万',
    playersRank: '#141',
    avgPlayTime: '25.4h',
    playTimeRank: '#7848',
    goodRate: '81%',
    wishlistCount: '208.7w',
    hasDeveloperIn: true,
    deckSupport: 'verified',
    headerTheme: 'orange',
    headerTools: [
      { title: '猛兽战绩', icon: '🧰' },
      { title: '组队大厅', icon: '👥' },
      { title: '🛠️' },
    ],
    customTabs: ['游戏', '社区', '统计'],
    intro: '和你的朋友一起来一场畅快淋漓的派对吧！用100种不同的方式和朋友们打打闹闹，或者团结起来消灭对手...',
  },
  {
    id: 'chained-together',
    title: '链在一起',
    englishTitle: 'Chained Together',
    gradientColors: ['#D96A4A', '#8B3A2A'],
    coverImg: $r('app.media.chain'),
    price: 16,
    originalPrice: 22,
    lowestPrice: 17.6,
    discountPercent: 20,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    rankBoard: '商城热销榜 No.4',
    tags: ['合作', '冒险', '平台游戏'],
    secondaryTags: ['休闲', '独立', '模拟', '受虐'],
    rating: 9.4,
    ratingColor: '#FF7A00',
    ratingCount: '3648人评分',
    onlineNow: '1038',
    yesterdayPeak: '6676',
    peakRank: '#236',
    monthAvgOnline: '4820',
    monthAvgRank: '#390',
    globalSalesRank: '#259',
    blackBoxPlayers: '367.2万',
    playersRank: '#87',
    avgPlayTime: '6.2h',
    playTimeRank: '#43058',
    goodRate: '90%',
    wishlistCount: '32w',
    awardLabel: '金摇杆奖 2024 直播选择奖',
    deckSupport: 'verified',
    headerTheme: 'orange',
    headerTools: [
      { title: '组队工具', icon: '👥' },
      { title: '🛠️' },
    ],
    customTabs: ['游戏', '社区', '统计'],
    intro: '从地狱的深渊开始，与你的同伴紧紧地链在一起。通过协同跳跃和攀爬，克服重重困难逃离地狱。',
  },
  {
    id: 'rise-of-tomb-raider',
    title: '古墓丽影：崛起',
    englishTitle: 'Rise of the Tomb Raider™',
    gradientColors: ['#3A3A3A', '#171717'],
    coverImg: $r('app.media.rise'),
    price: 21,
    originalPrice: 147,
    lowestPrice: 14.7,
    discountPercent: 85,
    couponLabel: '领券95折',
    rankBoard: '大家都在玩',
    tags: ['动作', '冒险'],
    secondaryTags: ['女性主角', '单人', '第三人称', '开放世界'],
    rating: 9.5,
    ratingColor: '#FF7A00',
    ratingCount: '2.0万人评分',
    onlineNow: '1086',
    yesterdayPeak: '2483',
    peakRank: '#496',
    monthAvgOnline: '2807',
    monthAvgRank: '#476',
    blackBoxPlayers: '421.4万',
    playersRank: '#68',
    avgPlayTime: '17.9h',
    playTimeRank: '#12094',
    goodRate: '94%',
    wishlistCount: '45.1w',
    awardLabel: 'Steam大奖 2017 "维特鲁威的灵魂"奖',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '《古墓丽影：崛起》解开一个古老谜团，这使劳拉必须在邪恶组织“圣三一”之前探索西伯利亚最危险和最偏远的区域。',
  },
  {
    id: 'deep-rock-galactic',
    title: '深岩银河',
    englishTitle: 'Deep Rock Galactic',
    gradientColors: ['#4A2E10', '#1C1005'],
    coverImg: $r('app.media.deeprock'),
    price: 29,
    originalPrice: 99,
    lowestPrice: 29,
    discountPercent: 70,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    rankBoard: '商城热销榜 No.15',
    tags: ['合作', 'PvE', '第一人称射击'],
    secondaryTags: ['矮人', '挖矿', '太空', 'Procedural Generation'],
    rating: 9.7,
    ratingColor: '#FF7A00',
    ratingCount: '1.5万人评分',
    onlineNow: '1.2万',
    yesterdayPeak: '2.4万',
    peakRank: '#65',
    monthAvgOnline: '1.8万',
    monthAvgRank: '#72',
    globalSalesRank: '#88',
    blackBoxPlayers: '198.5万',
    playersRank: '#195',
    avgPlayTime: '54.2h',
    playTimeRank: '#420',
    goodRate: '97%',
    wishlistCount: '62.5w',
    awardLabel: 'Steam大奖 2021 "爱的付出"奖提名',
    deckSupport: 'verified',
    headerTheme: 'orange',
    headerTools: [
      { title: '职业指南', icon: '⛏️' },
      { title: '🛠️' },
    ],
    customTabs: ['游戏', '社区', '统计'],
    intro: '《深岩银河》是一款 1-4 人的第一人称合作射击游戏，展现了酷炫的矮人战士、100% 可破坏的环境、随机生成的洞穴以及由外星怪物构成的无穷无尽的大军。',
  },
  {
    id: 'hitman-woa',
    title: '杀手：暗杀世界',
    englishTitle: 'HITMAN World of Assassination',
    gradientColors: ['#B22222', '#1C0505'],
    coverImg: $r('app.media.hitman'),
    price: 100,
    originalPrice: 250,
    lowestPrice: 100,
    discountPercent: 60,
    couponLabel: '领券95折',
    lowestLabel: '史低',
    rankBoard: '商城热销榜 No.20',
    tags: ['潜行', '刺客', '动作'],
    secondaryTags: ['单人', '沙盒', '策略', '第三人称'],
    rating: 9.2,
    ratingColor: '#FF7A00',
    ratingCount: '8920人评分',
    onlineNow: '3450',
    yesterdayPeak: '8910',
    peakRank: '#180',
    monthAvgOnline: '6200',
    monthAvgRank: '#210',
    blackBoxPlayers: '154.2万',
    playersRank: '#260',
    avgPlayTime: '38.6h',
    playTimeRank: '#890',
    goodRate: '90%',
    wishlistCount: '38.2w',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '进入终极刺客的世界。《杀手：暗杀世界》汇集了《杀手》、《杀手2》和《杀手3》的精粹内容，包括主要战役、契约模式、演练场和Freelancer模式。',
  },
  {
    id: 'rdr2',
    title: '荒野大镖客：救赎2',
    englishTitle: 'Red Dead Redemption 2',
    gradientColors: ['#8B0000', '#2B0000'],
    coverImg: $r('app.media.rdr2'),
    price: 92,
    originalPrice: 279,
    lowestPrice: 92,
    discountPercent: 67,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    rankLabel: '神作必玩 No.1',
    rankBoard: '商城热销榜 No.2',
    tags: ['开放世界', '剧情', '西部'],
    secondaryTags: ['动作', '角色扮演', '单人', '大师级声画'],
    rating: 9.8,
    ratingColor: '#FF7A00',
    ratingCount: '28.4万人评分',
    onlineNow: '3.4万',
    yesterdayPeak: '4.9万',
    peakRank: '#12',
    monthAvgOnline: '4.1万',
    monthAvgRank: '#15',
    globalSalesRank: '#8',
    blackBoxPlayers: '920.5万',
    playersRank: '#1',
    avgPlayTime: '85.4h',
    playTimeRank: '#45',
    goodRate: '96%',
    wishlistCount: '142w',
    awardLabel: 'Game Awards 最佳剧情/最佳音乐',
    deckSupport: 'playable',
    intro: '亚瑟·摩根和范德林德帮众是一群逃亡在外的亡命之徒。联邦侦探和全国顶尖的赏金猎人在他们身后穷追不合，亚瑟一行人必须选择在蛮荒的美国腹地奔逃、劫掠与挣扎求生。',
  },
  {
    id: 'overcooked2',
    title: '胡闹厨房2',
    englishTitle: 'Overcooked! 2',
    gradientColors: ['#FF9800', '#F57C00'],
    coverImg: $r('app.media.OverCooked'),
    price: 24,
    originalPrice: 98,
    lowestPrice: 24,
    discountPercent: 75,
    couponLabel: '领券95折',
    tags: ['多人', '本地合作', '在线合作'],
    secondaryTags: ['友谊撕裂', '休闲', '独立', '策略'],
    rating: 9.1,
    ratingColor: '#FF7A00',
    ratingCount: '4.5万人评分',
    onlineNow: '4210',
    yesterdayPeak: '9850',
    peakRank: '#180',
    monthAvgOnline: '7400',
    monthAvgRank: '#210',
    blackBoxPlayers: '530.1万',
    playersRank: '#42',
    avgPlayTime: '14.2h',
    playTimeRank: '#18900',
    goodRate: '91%',
    wishlistCount: '68w',
    deckSupport: 'verified',
    intro: '《胡闹厨房》带着全新的烹饪行动重回洋葱王国！重返洋葱王国，组建亲朋好友团队，在经典或全新的厨房环境中展开饕餮盛宴。',
  },
  {
    id: 'resident-evil-4',
    title: '生化危机4 重制版',
    englishTitle: 'Resident Evil 4',
    gradientColors: ['#37474F', '#212121'],
    coverImg: $r('app.media.resident'),
    price: 45,
    originalPrice: 198,
    lowestPrice: 45,
    discountPercent: 75,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['恐怖', '动作', '生存恐怖'],
    secondaryTags: ['单人', '第三人称', '重制', '丧尸'],
    rating: 9.6,
    ratingColor: '#FF7A00',
    ratingCount: '8.2万人评分',
    onlineNow: '6850',
    yesterdayPeak: '1.2万',
    peakRank: '#140',
    monthAvgOnline: '9400',
    monthAvgRank: '#165',
    blackBoxPlayers: '380.4万',
    playersRank: '#75',
    avgPlayTime: '22.8h',
    playTimeRank: '#9400',
    goodRate: '97%',
    wishlistCount: '95w',
    awardLabel: 'Game Awards 2023 年度最佳游戏提名',
    deckSupport: 'verified',
    intro: '前所未有的生存恐怖体验。特务里昂·S·甘迺迪被派去营救被绑架的总统千金。在恐怖的村庄里，展开一场生死营救。',
  },
  {
    id: 'monster-hunter-world',
    title: '怪物猎人：世界',
    englishTitle: 'Monster Hunter: World',
    gradientColors: ['#2E7D32', '#1B5E20'],
    coverImg: $r('app.media.monster'),
    price: 35,
    originalPrice: 148,
    lowestPrice: 35,
    discountPercent: 74,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['合作', '多人', '动作'],
    secondaryTags: ['狩猎', '刷宝', '角色扮演', '第三人称'],
    rating: 9.4,
    ratingColor: '#FF7A00',
    ratingCount: '11.2万人评分',
    onlineNow: '2.8万',
    yesterdayPeak: '4.5万',
    peakRank: '#24',
    monthAvgOnline: '3.2万',
    monthAvgRank: '#28',
    globalSalesRank: '#12',
    blackBoxPlayers: '740.8万',
    playersRank: '#12',
    avgPlayTime: '128.5h',
    playTimeRank: '#18',
    goodRate: '92%',
    wishlistCount: '110w',
    deckSupport: 'verified',
    intro: '在全新的世界中，勇敢地狩猎巨型怪物，利用地形和各种武器展开史诗般的大战斗。感受终极狩猎动作游戏的魅力！',
  },
  {
    id: 'monster-hunter-rise',
    title: '怪物猎人：崛起',
    englishTitle: 'Monster Hunter Rise',
    gradientColors: ['#1565C0', '#0D47A1'],
    coverImg: $r('app.media.monster_rise'),
    price: 36,
    originalPrice: 198,
    lowestPrice: 36,
    discountPercent: 80,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['动作', '在线合作', '狩猎'],
    secondaryTags: ['翔虫', '日式风', '多人', '角色扮演'],
    rating: 8.9,
    ratingColor: '#FF7A00',
    ratingCount: '3.8万人评分',
    onlineNow: '8400',
    yesterdayPeak: '1.5万',
    peakRank: '#110',
    monthAvgOnline: '1.1万',
    monthAvgRank: '#130',
    blackBoxPlayers: '290.6万',
    playersRank: '#125',
    avgPlayTime: '88.2h',
    playTimeRank: '#42',
    goodRate: '88%',
    wishlistCount: '52w',
    deckSupport: 'verified',
    intro: '蓬勃跃动的狩猎本能！随心所欲尽情奔驰的原野。可自由翱翔的新猎场与全新兽种。使用翔虫做出立体的行动！',
  },
  {
    id: 'street-fighter-6',
    title: '街头霸王6',
    englishTitle: 'Street Fighter 6',
    gradientColors: ['#E65100', '#BF360C'],
    coverImg: $r('app.media.fighter'),
    price: 90,
    originalPrice: 198,
    lowestPrice: 90,
    discountPercent: 50,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['2D 格斗', '格斗', '街机'],
    secondaryTags: ['竞技', '单人', '开放世界', '多人'],
    rating: 9.0,
    ratingColor: '#FF7A00',
    ratingCount: '2.4万人评分',
    onlineNow: '1.4万',
    yesterdayPeak: '2.8万',
    peakRank: '#45',
    monthAvgOnline: '1.8万',
    monthAvgRank: '#52',
    blackBoxPlayers: '185.3万',
    playersRank: '#210',
    avgPlayTime: '48.6h',
    playTimeRank: '#320',
    goodRate: '90%',
    wishlistCount: '48w',
    awardLabel: 'Game Awards 2023 最佳格斗游戏',
    deckSupport: 'verified',
    intro: '《街头霸王》系列最新作品！由RE ENGINE驱动，包含正统对战的"Fighting Ground"、单人游玩的"World Tour"与"Battle Hub"。',
  },
  {
    id: 'nba-2k26',
    title: 'NBA 2K26',
    englishTitle: 'NBA 2K26',
    gradientColors: ['#0277BD', '#01579B'],
    coverImg: $r('app.media.nba'),
    price: 42,
    originalPrice: 298,
    lowestPrice: 42,
    lowestLabel: '史低',
    platformIcon: 'steam',
    tags: ['体育', '篮球', '模拟'],
    secondaryTags: ['竞技', '多人', '生涯模式', '3D'],
    rating: 8.0,
    ratingColor: '#B366FF',
    ratingCount: '1.8万人评分',
    onlineNow: '1.8万',
    yesterdayPeak: '3.6万',
    peakRank: '#32',
    monthAvgOnline: '2.4万',
    monthAvgRank: '#38',
    blackBoxPlayers: '310.2万',
    playersRank: '#102',
    avgPlayTime: '72.4h',
    playTimeRank: '#85',
    goodRate: '78%',
    wishlistCount: '35w',
    deckSupport: 'playable',
    intro: '在《NBA 2K26》中体验顶级篮球竞技，掌控全场，开启属于你的超级巨星传奇。感受极致真实的全场对决与全新辉煌生涯模式。',
  },
  {
    id: 'black-myth-wukong',
    title: '黑神话：悟空',
    englishTitle: 'Black Myth: Wukong',
    gradientColors: ['#B8860B', '#3E2723'],
    coverImg: $r('app.media.wukong'),
    price: 268,
    originalPrice: 298,
    lowestPrice: 268,
    discountPercent: 10,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    rankLabel: '最受欢迎榜 No.1',
    rankBoard: '商城热销榜 No.1',
    tags: ['动作', '角色扮演', '西游'],
    secondaryTags: ['神话', '魂系', '第三人称', '国风神作'],
    rating: 9.9,
    ratingColor: '#FF7A00',
    ratingCount: '48.6万人评分',
    onlineNow: '21.5万',
    yesterdayPeak: '35.8万',
    peakRank: '#1',
    monthAvgOnline: '28.6万',
    monthAvgRank: '#1',
    globalSalesRank: '#1',
    blackBoxPlayers: '1890万',
    playersRank: '#1',
    avgPlayTime: '42.5h',
    playTimeRank: '#12',
    goodRate: '96%',
    wishlistCount: '350w',
    awardLabel: 'The Game Awards 2024 年度最佳动作游戏提名',
    hasDeveloperIn: true,
    deckSupport: 'verified',
    headerTheme: 'orange',
    intro: '《黑神话：悟空》是一款以中国神话为背景的动作角色扮演游戏。你将扮演一位“天命人”，为了探寻昔日传说的真相，踏上一条充满危险与惊奇的西游之路。',
  },
  {
    id: 'elden-ring',
    title: '艾尔登法环：黄金树幽影',
    englishTitle: 'ELDEN RING Shadow of the Erdtree',
    gradientColors: ['#DAA520', '#1A1A1A'],
    coverImg: $r('app.media.eldenring'),
    price: 198,
    originalPrice: 298,
    lowestPrice: 198,
    discountPercent: 33,
    couponLabel: '领券95折',
    lowestLabel: '史低',
    tags: ['开放世界', '魂系', '动作'],
    secondaryTags: ['高难挑战', '角色扮演', '暗黑奇幻'],
    rating: 9.8,
    ratingColor: '#FF7A00',
    ratingCount: '32.1万人评分',
    onlineNow: '8.9万',
    yesterdayPeak: '15.2万',
    peakRank: '#3',
    monthAvgOnline: '12.4万',
    monthAvgRank: '#4',
    blackBoxPlayers: '1250万',
    avgPlayTime: '118.0h',
    goodRate: '95%',
    wishlistCount: '280w',
    awardLabel: 'The Game Awards 2022 年度最佳游戏 GOTY',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '走进幽影之地，踏上全新冒险。探索未知的地下迷宫、挑战强悍的新 Boss，体验交界地更深层次的神话史诗。',
  },
  {
    id: 'cyberpunk-2077',
    title: '赛博朋克 2077：往日之影',
    englishTitle: 'Cyberpunk 2077: Phantom Liberty',
    gradientColors: ['#FEE12B', '#00F0FF'],
    coverImg: $r('app.media.cyberpunk'),
    price: 149,
    originalPrice: 298,
    lowestPrice: 149,
    discountPercent: 50,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['开放世界', '赛博朋克', '第一人称'],
    secondaryTags: ['科幻', '角色扮演', '剧情丰富'],
    rating: 9.4,
    ratingColor: '#FF7A00',
    ratingCount: '19.8万人评分',
    onlineNow: '4.2万',
    yesterdayPeak: '7.8万',
    peakRank: '#8',
    monthAvgOnline: '5.9万',
    monthAvgRank: '#10',
    blackBoxPlayers: '980万',
    avgPlayTime: '76.4h',
    goodRate: '92%',
    wishlistCount: '190w',
    awardLabel: 'Steam 大奖 2023 爱的付出奖',
    deckSupport: 'verified',
    headerTheme: 'orange',
    intro: '在夜之城最危险的狗镇展开一场谍报惊悚冒险。与雇佣兵 V 一起揭开高层政治阴谋，拯救新美国总统。',
  },
  {
    id: 'sekiro',
    title: '只狼：影逝二度',
    englishTitle: 'Sekiro: Shadows Die Twice',
    gradientColors: ['#800000', '#2B0000'],
    coverImg: $r('app.media.sekiro'),
    price: 134,
    originalPrice: 268,
    lowestPrice: 134,
    discountPercent: 50,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['打铁', '动作', '高难'],
    secondaryTags: ['忍者', '战国', '单人', '第三人称'],
    rating: 9.7,
    ratingColor: '#FF7A00',
    ratingCount: '21.5万人评分',
    onlineNow: '2.1万',
    yesterdayPeak: '4.2万',
    peakRank: '#20',
    monthAvgOnline: '3.1万',
    monthAvgRank: '#25',
    blackBoxPlayers: '850万',
    avgPlayTime: '58.0h',
    goodRate: '95%',
    wishlistCount: '160w',
    awardLabel: 'The Game Awards 2019 年度最佳游戏 GOTY',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '在《只狼：影逝二度》中扮演“独臂之狼”，探索 1500 年代末的日本战国时代，挑战死神并展开复仇。',
  },
  {
    id: 'love-choice',
    title: '拣爱',
    englishTitle: 'LoveChoice',
    gradientColors: ['#FF69B4', '#8A2BE2'],
    coverImg: $r('app.media.LoveChoice'),
    price: 12,
    originalPrice: 15,
    lowestPrice: 9,
    discountPercent: 20,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['独立', '恋爱', '剧情'],
    secondaryTags: ['治愈', '解谜', '单人', '选择取向'],
    rating: 9.6,
    ratingColor: '#FF7A00',
    ratingCount: '1.2万人评分',
    onlineNow: '420',
    yesterdayPeak: '1200',
    peakRank: '#850',
    monthAvgOnline: '890',
    monthAvgRank: '#920',
    blackBoxPlayers: '120万',
    avgPlayTime: '3.5h',
    goodRate: '96%',
    wishlistCount: '25w',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '《拣爱》是一款以爱为主题的AVG选择导向游戏。游戏旨在通过富有诗意和沉浸感的剧情，探讨爱与被爱的意义。',
  },
  {
    id: 'miside',
    title: 'MiSide 米塔',
    englishTitle: 'MiSide',
    gradientColors: ['#2BC48A', '#106A78'],
    coverImg: $r('app.media.mita'),
    price: 38,
    originalPrice: 48,
    lowestPrice: 38,
    discountPercent: 21,
    couponLabel: '领券9折',
    lowestLabel: '新史低',
    tags: ['病娇', '恐怖', '二次元'],
    secondaryTags: ['解谜', '角色扮演', '单人', '沉浸体验'],
    rating: 9.5,
    ratingColor: '#FF7A00',
    ratingCount: '8500人评分',
    onlineNow: '3200',
    yesterdayPeak: '7800',
    peakRank: '#210',
    monthAvgOnline: '5400',
    monthAvgRank: '#260',
    blackBoxPlayers: '95万',
    avgPlayTime: '8.2h',
    goodRate: '94%',
    wishlistCount: '42w',
    deckSupport: 'verified',
    headerTheme: 'teal',
    intro: '当你被拉入手机游戏的世界，与病娇美少女米塔生活在同一屋檐下。揭开房间背后的诡异真相并试图逃离这里！',
  },
];

export function getGameById(id: string): GameItem | undefined {
  return gameList.find((item: GameItem) => item.id === id);
}

export function getFilteredGames(
  platformIndex: number,
  categoryIndex: number,
  payFilter?: string,
  typeFilter?: string,
  discountFilter?: string,
  scoreFilter?: string
): GameItem[] {
  let result = [...gameList];

  // 1. 平台筛选
  if (platformIndex === 1) {
    result = result.filter((g) => g.tags.includes('休闲') || g.tags.includes('独立') || g.tags.includes('解谜') || g.tags.includes('平台跳跃') || g.id === 'party-animals' || g.id === 'love-choice');
  } else if (platformIndex === 2) {
    result = result.filter((g) => g.tags.includes('动作') || g.tags.includes('角色扮演') || g.tags.includes('暗黑奇幻') || g.id === 'rdr2' || g.id === 'elden-ring');
  } else if (platformIndex === 3) {
    result = result.filter((g) => g.tags.includes('竞速') || g.tags.includes('开放世界') || g.tags.includes('射击') || g.id === 'palworld' || g.id === 'forza-horizon-5');
  }

  // 2. 付费筛选
  if (payFilter && payFilter !== '全部') {
    if (payFilter === '免费游玩') {
      result = result.filter((g) => g.price === 0);
    } else if (payFilter === '100元以下') {
      result = result.filter((g) => g.price > 0 && g.price <= 100);
    } else if (payFilter === '100-200元') {
      result = result.filter((g) => g.price > 100 && g.price <= 200);
    } else if (payFilter === '200元以上') {
      result = result.filter((g) => g.price > 200);
    }
  }

  // 3. 游戏类型筛选
  if (typeFilter && typeFilter !== '全部') {
    result = result.filter((g) => g.tags.includes(typeFilter) || (g.secondaryTags && g.secondaryTags.includes(typeFilter)));
  }

  // 4. 折扣区间筛选
  if (discountFilter && discountFilter !== '全部') {
    if (discountFilter === '特惠中') {
      result = result.filter((g) => g.discountPercent !== undefined && g.discountPercent > 0);
    } else if (discountFilter === '5折及以上') {
      result = result.filter((g) => g.discountPercent !== undefined && g.discountPercent >= 50);
    } else if (discountFilter === '7折及以上') {
      result = result.filter((g) => g.discountPercent !== undefined && g.discountPercent >= 70);
    }
  }

  // 5. 评分筛选
  if (scoreFilter && scoreFilter !== '全部') {
    if (scoreFilter === '9.0分以上') {
      result = result.filter((g) => g.rating !== undefined && g.rating >= 9.0);
    } else if (scoreFilter === '9.5分以上') {
      result = result.filter((g) => g.rating !== undefined && g.rating >= 9.5);
    }
  }

  // 6. 分类排序
  if (categoryIndex === 0) {
    result.sort((a, b) => (b.rating ?? 0) - (a.rating ?? 0));
  } else if (categoryIndex === 1) {
    result = result.filter((g) => g.discountPercent !== undefined && g.discountPercent > 0);
    result.sort((a, b) => (b.discountPercent ?? 0) - (a.discountPercent ?? 0));
  } else if (categoryIndex === 2) {
    result.sort((a, b) => (parseFloat(b.wishlistCount ?? '0')) - (parseFloat(a.wishlistCount ?? '0')));
  } else if (categoryIndex === 3) {
    result.sort((a, b) => (b.price ?? 0) - (a.price ?? 0));
  } else if (categoryIndex === 4) {
    result.sort((a, b) => (parseFloat(b.onlineNow ?? '0')) - (parseFloat(a.onlineNow ?? '0')));
  }

  return result;
}

export class GameDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private items: GameItem[] = [];

  constructor(items: GameItem[]) {
    this.items = items;
  }

  totalCount(): number {
    return this.items.length;
  }

  getData(index: number): GameItem {
    return this.items[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  setItems(newItems: GameItem[]): void {
    this.items = newItems;
    this.notifyDataReload();
  }
}
