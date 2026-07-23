/**
 * 游戏数据模型
 * 说明：项目中暂无真实封面图资源，这里用渐变色 + 标题文字做卡片占位。
 * 后续接入真实素材时，只需把封面渲染部分换成 Image($r('app.media.xxx'))，
 * 其余字段（价格 / 折扣 / 标签 / 统计数据）保持不变即可直接使用。
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
    deckSupport: 'playable',
    headerTheme: 'white',
    customTabs: ['游戏', '社区', '统计'],
    intro: '《古墓丽影：崛起》20 周年纪念版包括基础游戏和以全新内容为特色的 Season Pass。探索克劳馥庄园，在“劳拉的梦魇”中保护它不被僵尸侵袭。',
  },
  {
    id: 'love-choice',
    title: 'LoveChoice 拣爱',
    englishTitle: 'LoveChoice',
    gradientColors: ['#F8BBD0', '#C2185B'],
    coverImg: $r('app.media.LoveChoice'),
    price: 8,
    originalPrice: 10,
    lowestPrice: 6.7,
    discountPercent: 20,
    rankBoard: '大家都在玩',
    tags: ['冒险', '独立', '角色扮演'],
    secondaryTags: ['模拟', '爱情', '恋爱模拟'],
    rating: 8.8,
    ratingColor: '#B366FF',
    ratingCount: '6044人评分',
    onlineNow: '23',
    yesterdayPeak: '191',
    peakRank: '#2528',
    monthAvgOnline: '247',
    monthAvgRank: '#2364',
    blackBoxPlayers: '215.7万',
    playersRank: '#183',
    avgPlayTime: '2.8h',
    playTimeRank: '#85419',
    goodRate: '92%',
    wishlistCount: '24.6w',
    deckSupport: 'verified',
    headerTheme: 'white',
    customTabs: ['游戏', '社区', '统计'],
    intro: '《拣爱》是一款以日式AVG选择玩法为核心的游戏。拣，有选择之意。我们在设计的时候十分在意每一个场景，每一个选择都合理而有其自己的意义。力求让玩家能够在该游戏中做出有意义，且真正能影响结局的选择。',
  },
  {
    id: 'mita',
    title: '米塔',
    englishTitle: 'MiSide',
    gradientColors: ['#7B1FA2', '#4A148C'],
    coverImg: $r('app.media.mita'),
    price: 39.8,
    originalPrice: 52,
    lowestPrice: 41.6,
    discountPercent: 10,
    couponLabel: '领券85折',
    rankBoard: '大家都在玩',
    tags: ['冒险', '独立', '角色扮演'],
    secondaryTags: ['模拟', '心理恐怖', '可爱'],
    rating: 9.8,
    ratingColor: '#FF7A00',
    ratingCount: '1.0万人评分',
    onlineNow: '222',
    yesterdayPeak: '579',
    peakRank: '#1291',
    monthAvgOnline: '728',
    monthAvgRank: '#1190',
    blackBoxPlayers: '118.3万',
    playersRank: '#372',
    avgPlayTime: '8.2h',
    playTimeRank: '#30900',
    goodRate: '97%',
    wishlistCount: '54.1w',
    hasDeveloperIn: true,
    deckSupport: 'playable',
    headerTheme: 'white',
    hasDatabaseTab: true,
    customTabs: ['游戏', '社区', '数据库', '统计'],
    intro: '你好！我的名字叫米塔！每天，你都会来看我，帮我看家务，给我做饭吃，还会给我买小礼物。你真好！我好喜欢你！我好想把你每天都留在我的身边，每天都跟你一起生活~我知道你也想和我在一起...',
  },
  {
    id: 'rdr2',
    title: '荒野大镖客：救赎2',
    englishTitle: 'Red Dead Redemption 2',
    gradientColors: ['#7A2E2E', '#331010'],
    coverImg: $r('app.media.background'),
    price: 70,
    originalPrice: 279,
    lowestPrice: 70,
    discountPercent: 75,
    lowestLabel: '史低',
    tags: ['开放世界', '剧情丰富', '西部'],
    secondaryTags: ['动作', '单人', '第三人称', '好评神作'],
    rating: 9.7,
    ratingColor: '#FF7A00',
    ratingCount: '15.8万人评分',
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
    intro: '亚瑟·摩根和范德林德帮众是一群逃亡在外的亡命之徒。联邦侦探和全国顶尖的赏金猎人在他们身后穷追不舍，亚瑟一行人必须选择在蛮荒的美国腹地奔逃、劫掠与挣扎求生。',
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
    coverImg: $r('app.media.monster'),
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
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/2358720/header.jpg',
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
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/header.jpg',
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
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
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
    id: 'witcher-3',
    title: '巫师3：狂猎 完全版',
    englishTitle: 'The Witcher 3: Wild Hunt Complete Edition',
    gradientColors: ['#8B0000', '#2F4F4F'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg',
    price: 37,
    originalPrice: 149,
    lowestPrice: 29,
    discountPercent: 75,
    couponLabel: '领券95折',
    lowestLabel: '史低',
    tags: ['开放世界', '角色扮演', '剧情'],
    secondaryTags: ['奇幻', '单人', '神作推荐'],
    rating: 9.9,
    ratingColor: '#FF7A00',
    ratingCount: '45.2万人评分',
    onlineNow: '2.8万',
    yesterdayPeak: '5.1万',
    peakRank: '#15',
    monthAvgOnline: '3.6万',
    monthAvgRank: '#18',
    blackBoxPlayers: '1580万',
    avgPlayTime: '105.0h',
    goodRate: '97%',
    wishlistCount: '310w',
    awardLabel: 'The Game Awards 2015 年度最佳游戏 GOTY',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '化身利维亚的杰洛特，游走于割据的北方领域。在庞大的开放世界中寻找预言之子，拯救世界或走向毁灭。',
  },
  {
    id: 'god-of-war-ragt',
    title: '战神：诸神黄昏',
    englishTitle: 'God of War Ragnarök',
    gradientColors: ['#1C39BB', '#4A6984'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/2322010/header.jpg',
    price: 318,
    originalPrice: 398,
    lowestPrice: 318,
    discountPercent: 20,
    couponLabel: '领券95折',
    tags: ['动作', '冒险', '神话'],
    secondaryTags: ['父子冒险', '第三人称', '视听盛宴'],
    rating: 9.7,
    ratingColor: '#FF7A00',
    ratingCount: '15.4万人评分',
    onlineNow: '3.1万',
    yesterdayPeak: '6.4万',
    peakRank: '#12',
    monthAvgOnline: '4.8万',
    monthAvgRank: '#14',
    blackBoxPlayers: '640万',
    avgPlayTime: '54.0h',
    goodRate: '96%',
    wishlistCount: '150w',
    awardLabel: 'TGA 2022 最佳叙事 / 最佳音乐奖',
    deckSupport: 'playable',
    headerTheme: 'white',
    intro: '葵托斯与阿特柔斯踏上九界探索之旅，寻求解答与盟友。预言中的诸神黄昏临近，他们必须在自身安全与九界命运间做出抉择。',
  },
  {
    id: 'pubg',
    title: '绝地求生 官方正版',
    englishTitle: 'PUBG: BATTLEGROUNDS',
    gradientColors: ['#FF8C00', '#2B2B2B'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/578080/header.jpg',
    price: 0,
    originalPrice: 0,
    lowestPrice: 0,
    discountPercent: 0,
    couponLabel: '免费游玩',
    tags: ['战术竞技', '射击', '多人'],
    secondaryTags: ['吃鸡', '第一人称', '联机开黑'],
    rating: 8.5,
    ratingColor: '#FF7A00',
    ratingCount: '52.0万人评分',
    onlineNow: '38.5万',
    yesterdayPeak: '62.0万',
    peakRank: '#3',
    monthAvgOnline: '45.0万',
    monthAvgRank: '#2',
    blackBoxPlayers: '2300万',
    playersRank: '#2',
    avgPlayTime: '320.0h',
    playTimeRank: '#1',
    goodRate: '78%',
    wishlistCount: '500w',
    headerTheme: 'white',
    intro: '降落战术要地，搜刮武器装备，在残酷的百人战场中生存至最后一人！体验纯正的战术竞技射击乐趣。',
  },
  {
    id: 'it-takes-two',
    title: '双人成行',
    englishTitle: 'It Takes Two',
    gradientColors: ['#FF69B4', '#FFA500'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/1426210/header.jpg',
    price: 49,
    originalPrice: 198,
    lowestPrice: 49,
    discountPercent: 75,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['双人合作', '平台跳跃', '解谜'],
    secondaryTags: ['友谊撕裂', '情侣必玩', '欢乐'],
    rating: 9.9,
    ratingColor: '#FF7A00',
    ratingCount: '28.9万人评分',
    onlineNow: '2.1万',
    yesterdayPeak: '4.3万',
    peakRank: '#22',
    monthAvgOnline: '3.1万',
    monthAvgRank: '#25',
    blackBoxPlayers: '1120万',
    avgPlayTime: '14.5h',
    goodRate: '97%',
    wishlistCount: '230w',
    awardLabel: 'The Game Awards 2021 年度最佳游戏 GOTY',
    deckSupport: 'verified',
    headerTheme: 'orange',
    intro: '游玩《双人成行》，踏上一段前所未有的狂野旅程。这是一款专门为双人合作打造的别开生面的平台冒险游戏。',
  },
  {
    id: 'sekiro',
    title: '只狼：影逝二度 年度版',
    englishTitle: 'Sekiro: Shadows Die Twice GOTY',
    gradientColors: ['#800000', '#1C1C1C'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/814380/header.jpg',
    price: 134,
    originalPrice: 268,
    lowestPrice: 134,
    discountPercent: 50,
    couponLabel: '领券95折',
    lowestLabel: '史低',
    tags: ['动作', '忍者', '打铁'],
    secondaryTags: ['高难拼刀', '单人', '魂系神作'],
    rating: 9.8,
    ratingColor: '#FF7A00',
    ratingCount: '25.6万人评分',
    onlineNow: '1.8万',
    yesterdayPeak: '3.6万',
    peakRank: '#30',
    monthAvgOnline: '2.5万',
    monthAvgRank: '#32',
    blackBoxPlayers: '890万',
    avgPlayTime: '48.0h',
    goodRate: '95%',
    wishlistCount: '210w',
    awardLabel: 'The Game Awards 2019 年度最佳游戏 GOTY',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '探索 16 世纪末惨烈流血的日本战国时代。化身独臂忍者狼，在死生边缘打铁拼刀，复仇并夺回荣誉。',
  },
  {
    id: 'terraria',
    title: '泰拉瑞亚 最终更新版',
    englishTitle: 'Terraria',
    gradientColors: ['#228B22', '#8B4513'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/105600/header.jpg',
    price: 18,
    originalPrice: 36,
    lowestPrice: 18,
    discountPercent: 50,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['沙盒', '像素', '生存'],
    secondaryTags: ['建造', '探索', '刷宝', '多人'],
    rating: 9.9,
    ratingColor: '#FF7A00',
    ratingCount: '38.4万人评分',
    onlineNow: '4.6万',
    yesterdayPeak: '7.2万',
    peakRank: '#9',
    monthAvgOnline: '5.2万',
    monthAvgRank: '#11',
    blackBoxPlayers: '1340万',
    avgPlayTime: '142.0h',
    goodRate: '98%',
    wishlistCount: '290w',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '挖掘，战斗，探索，建造！在这个充满奇迹的像素沙盒世界中，整个世界都是你的画布，地面本身就是你的颜料。',
  },
  {
    id: 'stardew-valley',
    title: '星露谷物语 1.6 版本',
    englishTitle: 'Stardew Valley',
    gradientColors: ['#32CD32', '#FFD700'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/413150/header.jpg',
    price: 28,
    originalPrice: 48,
    lowestPrice: 24,
    discountPercent: 41,
    couponLabel: '领券9折',
    tags: ['农场模拟', '像素', '休闲'],
    secondaryTags: ['恋爱结婚', '钓鱼', '治愈神作'],
    rating: 9.9,
    ratingColor: '#FF7A00',
    ratingCount: '31.2万人评分',
    onlineNow: '3.8万',
    yesterdayPeak: '6.5万',
    peakRank: '#11',
    monthAvgOnline: '4.5万',
    monthAvgRank: '#15',
    blackBoxPlayers: '1050万',
    avgPlayTime: '98.5h',
    goodRate: '98%',
    wishlistCount: '240w',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '你继承了爷爷在星露谷留下的荒废农场。手握落后的农具和几枚硬币，开始你的新生活，将这片荒芜小镇变成繁荣的家园！',
  },
  {
    id: 'hollow-knight',
    title: '空洞骑士 寻神者版',
    englishTitle: 'Hollow Knight',
    gradientColors: ['#4682B4', '#191970'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/367520/header.jpg',
    price: 24,
    originalPrice: 48,
    lowestPrice: 24,
    discountPercent: 50,
    couponLabel: '领券95折',
    lowestLabel: '史低',
    tags: ['银河恶魔城', '类银河战士恶魔城', '高难'],
    secondaryTags: ['手绘风', '单人', '神作推荐'],
    rating: 9.8,
    ratingColor: '#FF7A00',
    ratingCount: '26.8万人评分',
    onlineNow: '1.2万',
    yesterdayPeak: '2.4万',
    peakRank: '#45',
    monthAvgOnline: '1.8万',
    monthAvgRank: '#48',
    blackBoxPlayers: '920万',
    avgPlayTime: '62.0h',
    goodRate: '97%',
    wishlistCount: '260w',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '深入衰败的圣巢地下王国，锻造自己的道路！在这款惊险刺激的手绘 2D 银河恶魔城动作游戏中探索广阔的世界。',
  },
  {
    id: 'spiderman-remastered',
    title: '漫威蜘蛛侠 重制版',
    englishTitle: "Marvel's Spider-Man Remastered",
    gradientColors: ['#ED1D24', '#000000'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/1817070/header.jpg',
    price: 186,
    originalPrice: 314,
    lowestPrice: 186,
    discountPercent: 40,
    couponLabel: '领券9折',
    tags: ['超级英雄', '开放世界', '动作'],
    secondaryTags: ['蛛丝荡跃', '漫威', '第三人称'],
    rating: 9.6,
    ratingColor: '#FF7A00',
    ratingCount: '12.4万人评分',
    onlineNow: '1.1万',
    yesterdayPeak: '2.2万',
    peakRank: '#50',
    monthAvgOnline: '1.5万',
    monthAvgRank: '#55',
    blackBoxPlayers: '580万',
    avgPlayTime: '32.0h',
    goodRate: '96%',
    wishlistCount: '160w',
    deckSupport: 'verified',
    headerTheme: 'white',
    intro: '在《漫威蜘蛛侠重制版》中，彼得·帕克和蜘蛛侠的世界在跌宕起伏的原创剧情中碰撞。扮演经验丰富的彼得·帕克，穿梭于纽约街头。',
  },
  {
    id: 'forza-horizon-5',
    title: '极限竞速：地平线 5 顶级版',
    englishTitle: 'Forza Horizon 5 Premium Edition',
    gradientColors: ['#FF4500', '#1E90FF'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/1551360/header.jpg',
    price: 124,
    originalPrice: 248,
    lowestPrice: 124,
    discountPercent: 50,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    tags: ['竞速', '开放世界', '赛车'],
    secondaryTags: ['画质爆表', '多人联机', '墨西哥'],
    rating: 9.5,
    ratingColor: '#FF7A00',
    ratingCount: '17.6万人评分',
    onlineNow: '2.4万',
    yesterdayPeak: '4.8万',
    peakRank: '#18',
    monthAvgOnline: '3.2万',
    monthAvgRank: '#20',
    blackBoxPlayers: '870万',
    avgPlayTime: '88.0h',
    goodRate: '88%',
    wishlistCount: '200w',
    awardLabel: 'TGA 2021 最佳体育/竞速游戏奖',
    deckSupport: 'playable',
    headerTheme: 'white',
    intro: '您的终极地平线冒险正等待着您！探索墨西哥充满活力且不断变化的开放世界景色，驾驶百辆世界级好车享受无拘无束的驾驶乐趣。',
  },
  {
    id: 'naraka-bladepoint',
    title: '永劫无间 免费版',
    englishTitle: 'NARAKA: BLADEPOINT',
    gradientColors: ['#B22222', '#2F4F4F'],
    coverImg: 'https://cdn.akamai.steamstatic.com/steam/apps/582010/header.jpg',
    price: 0,
    originalPrice: 0,
    lowestPrice: 0,
    discountPercent: 0,
    couponLabel: '免费游玩',
    tags: ['武侠竞技', '动作', '吃鸡'],
    secondaryTags: ['飞索拼刀', '国风', '多人开黑'],
    rating: 8.3,
    ratingColor: '#FF7A00',
    ratingCount: '24.5万人评分',
    onlineNow: '15.8万',
    yesterdayPeak: '28.4万',
    peakRank: '#5',
    monthAvgOnline: '18.2万',
    monthAvgRank: '#6',
    blackBoxPlayers: '1650万',
    playersRank: '#3',
    avgPlayTime: '185.0h',
    goodRate: '75%',
    wishlistCount: '380w',
    headerTheme: 'white',
    intro: '挥舞利刃，斩尽全场！在 60 人生存竞技战场中自由穿梭，体验武侠近战拼刀与飞索壁走带来的前所未有的动作竞技魅力。',
  },
];

export function getGameById(id: string): GameItem | undefined {
  return gameList.find((item: GameItem) => item.id === id);
}

export interface PostComment {
  id: string;
  authorName: string;
  authorAvatarBg: string;
  authorLevel?: string;
  timeAgo: string;
  content: string;
  likesCount: number;
}

export interface CommunityPost {
  id: string;
  authorName: string;
  authorAvatarBg: string;
  authorLevel?: string;
  timeAgo: string;
  location?: string;
  title: string;
  content: string;
  likesCount: number;
  commentsCount: number;
  tag?: string;
  coverImg?: ResourceStr;
  toolName?: string;
  toolDesc?: string;
  comments?: PostComment[];
}

export interface DatabaseItem {
  id: string;
  name: string;
  category: string;
  rarity?: string;
  rarityColor?: string;
  desc: string;
  icon: string;
}

export interface RegionPrice {
  regionName: string;
  flagEmoji: string;
  priceLocal: string;
  priceCNY: string;
  isLowest?: boolean;
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

export function getGameCommunityPosts(gameId: string): CommunityPost[] {
  const game = getGameById(gameId);
  const titleStr = game ? game.title : '这款游戏';
  const cover = game?.coverImg ?? $r('app.media.background');

  if (gameId === 'palworld') {
    return [
      {
        id: 'post-pal-1',
        authorName: '执念',
        authorAvatarBg: '#4A5568',
        authorLevel: 'Lv.18',
        timeAgo: '11小时前',
        location: '河南',
        title: '这个名字真实了！帕鲁配种词条全解析',
        content: '经过三天三夜的孵化，终于出了传说+脑筋+凶猛+运动健将的四金战斗帕鲁！分享一下配种路线与词条遗传规律。',
        likesCount: 9,
        commentsCount: 3,
        tag: '帕鲁生成器',
        toolName: '帕鲁生成器',
        toolDesc: '试一试 · 帕鲁生成器',
        coverImg: cover,
        comments: [
          {
            id: 'c-pal-1',
            authorName: '帕鲁黑心老板',
            authorAvatarBg: '#E74C3C',
            authorLevel: 'Lv.14',
            timeAgo: '10小时前',
            content: '四金空涡龙太强了，打塔主直接站撸！',
            likesCount: 12,
          },
          {
            id: 'c-pal-2',
            authorName: '孵蛋专业户',
            authorAvatarBg: '#F39C12',
            authorLevel: 'Lv.11',
            timeAgo: '8小时前',
            content: '求一个唤冬兽和阿努比斯的配种公式！',
            likesCount: 5,
          },
          {
            id: 'c-pal-3',
            authorName: '黑盒盒友',
            authorAvatarBg: '#3498DB',
            authorLevel: 'Lv.9',
            timeAgo: '5小时前',
            content: '收藏了，今晚就回家开始黑心工场孵蛋！',
            likesCount: 3,
          },
        ],
      },
      {
        id: 'post-pal-2',
        authorName: '林深时。',
        authorAvatarBg: '#9B59B6',
        authorLevel: 'Lv.12',
        timeAgo: '3小时前',
        location: '广东',
        title: '牛逼在线人数直接破纪录，里面有什么好玩的？',
        content: '大家觉得这款游戏怎么样？抓宠+基建+自动化生产线，适合独狼还是联机开黑？推荐入手吗？',
        likesCount: 11,
        commentsCount: 2,
        tag: '游戏讨论',
        coverImg: cover,
        comments: [
          {
            id: 'c-pal-4',
            authorName: '抓宠大师',
            authorAvatarBg: '#2ECC71',
            authorLevel: 'Lv.15',
            timeAgo: '2小时前',
            content: '非常上头！玩法丰富，抓宠+基建根本停不下来。',
            likesCount: 18,
          },
          {
            id: 'c-pal-5',
            authorName: '盒友9527',
            authorAvatarBg: '#E67E22',
            authorLevel: 'Lv.8',
            timeAgo: '1小时前',
            content: '支持联机开黑，和朋友一起玩乐趣翻倍！',
            likesCount: 7,
          },
        ],
      },
    ];
  }

  if (gameId === 'black-myth-wukong') {
    return [
      {
        id: 'post-bm-1',
        authorName: '天命人老张',
        authorAvatarBg: '#B8860B',
        authorLevel: 'Lv.20',
        timeAgo: '4小时前',
        location: '北京',
        title: '【黑神话】二周目全隐藏关卡与大圣套极致输出配装',
        content: '刚通关二周目！大圣套+如意金箍棒在满级棍势下的重棍打击感真的绝了！分享一下花果山隐藏山洞的触发条件与辟火罩的最佳使用时机。',
        likesCount: 158,
        commentsCount: 3,
        tag: '国风神作',
        toolName: '大圣配装器',
        toolDesc: '试一试 · 悟空加点器',
        coverImg: cover,
        comments: [
          { id: 'c-bm-1', authorName: '西游狂热粉', authorAvatarBg: '#C0392B', authorLevel: 'Lv.17', timeAgo: '3小时前', content: '如意金箍棒切轻重棍花的硬直判定太帅了！', likesCount: 42 },
          { id: 'c-bm-2', authorName: '齐天大圣', authorAvatarBg: '#F39C12', authorLevel: 'Lv.19', timeAgo: '2小时前', content: '四妹剧情太虐了，好想救四妹！', likesCount: 89 },
          { id: 'c-bm-3', authorName: '游魔王', authorAvatarBg: '#27AE60', authorLevel: 'Lv.10', timeAgo: '1小时前', content: '感谢大佬，花果山那个避水珠终于找到了！', likesCount: 15 },
        ],
      },
      {
        id: 'post-bm-2',
        authorName: '浪人剑客',
        authorAvatarBg: '#34495E',
        authorLevel: 'Lv.13',
        timeAgo: '8小时前',
        location: '浙江',
        title: '虎先锋打不过去怎么办？立棍法手残党逃课教学',
        content: '很多兄弟卡在卧虎寺虎先锋，教大家一套定身术+立棍法逃课打法，不用频繁拼刀也能稳稳通关！',
        likesCount: 76,
        commentsCount: 2,
        tag: '新手救星',
        coverImg: cover,
        comments: [
          { id: 'c-bm-4', authorName: '喝血大魔王', authorAvatarBg: '#E74C3C', authorLevel: 'Lv.7', timeAgo: '6小时前', content: '终于过了！这虎先锋一拳把我牙都打掉了！', likesCount: 28 },
          { id: 'c-bm-5', authorName: '黑盒盒友', authorAvatarBg: '#2980B9', authorLevel: 'Lv.12', timeAgo: '4小时前', content: '立棍高处蓄力确实安全，多谢分享！', likesCount: 11 },
        ],
      },
    ];
  }

  if (gameId === 'elden-ring') {
    return [
      {
        id: 'post-er-1',
        authorName: '褪色者阿勇',
        authorAvatarBg: '#DAA520',
        authorLevel: 'Lv.19',
        timeAgo: '6小时前',
        location: '上海',
        title: '黄金树幽影 DLC 推荐等级与全幽影树碎片收集地图',
        content: '刚进幽影之地别急着开 Boss，先把墓地平原的 5 个幽影树碎片拿齐！庇佑等级升到 3 级之后减伤非常明显。',
        likesCount: 210,
        commentsCount: 2,
        tag: '交界地指南',
        toolName: '幽影碎片地图',
        toolDesc: '试一试 · 全地图标记',
        coverImg: cover,
        comments: [
          { id: 'c-er-1', authorName: '梅琳娜单推人', authorAvatarBg: '#9B59B6', authorLevel: 'Lv.16', timeAgo: '5小时前', content: '太及时了！刚进游戏被舞狮一巴掌拍死。', likesCount: 34 },
          { id: 'c-er-2', authorName: '狂龙贝勒', authorAvatarBg: '#C0392B', authorLevel: 'Lv.18', timeAgo: '3小时前', content: '诅咒你！贝勒！埃尔贡的声音太令人震撼了。', likesCount: 67 },
        ],
      },
    ];
  }

  if (gameId === 'cyberpunk-2077') {
    return [
      {
        id: 'post-cp-1',
        authorName: '强尼银手',
        authorAvatarBg: '#00F0FF',
        authorLevel: 'Lv.18',
        timeAgo: '5小时前',
        location: '成都',
        title: '【往日之影】狗镇全隐藏武器与百头鹰狙击枪获取坐标',
        content: '狗镇空投箱里能开出不少顶级动能武器！详细坐标已经标注在图中，汉森的遗产记得去空投点摸。',
        likesCount: 132,
        commentsCount: 2,
        tag: '狗镇生存',
        toolName: '狗镇空投地图',
        toolDesc: '试一试 · 赛博加点器',
        coverImg: cover,
        comments: [
          { id: 'c-cp-1', authorName: '雇佣兵V', authorAvatarBg: '#F1C40F', authorLevel: 'Lv.15', timeAgo: '4小时前', content: '狗镇的谍报氛围太棒了，比夜之城本体更有代入感！', likesCount: 29 },
          { id: 'c-cp-2', authorName: '朱迪老婆', authorAvatarBg: '#E91E63', authorLevel: 'Lv.12', timeAgo: '2小时前', content: '百头鹰配爆头伤害直接起飞！', likesCount: 16 },
        ],
      },
    ];
  }

  if (gameId === 'sekiro') {
    return [
      {
        id: 'post-sk-1',
        authorName: '独臂狼',
        authorAvatarBg: '#800000',
        authorLevel: 'Lv.17',
        timeAgo: '7小时前',
        location: '湖北',
        title: '【只狼】剑圣苇名一心全招式完美刀法弹反教学',
        content: '“犹豫就会败北，果断就会白给！”详细拆解一心的枪刀组合拳与雷反判定时间点，祝大家早日打铁通关！',
        likesCount: 188,
        commentsCount: 2,
        tag: '打铁指南',
        coverImg: cover,
        comments: [
          { id: 'c-sk-1', authorName: '苇名流弟子', authorAvatarBg: '#34495E', authorLevel: 'Lv.14', timeAgo: '6小时前', content: '打铁打得手抖，弹反成功那一声铿锵太解压了！', likesCount: 45 },
          { id: 'c-sk-2', authorName: '永真党', authorAvatarBg: '#1ABC9C', authorLevel: 'Lv.11', timeAgo: '3小时前', content: '一心真乃师徒典范，通关后成就感爆棚！', likesCount: 23 },
        ],
      },
    ];
  }

  if (gameId === 'party-animals') {
    return [
      {
        id: 'post-pa-1',
        authorName: '软萌小狗',
        authorAvatarBg: '#FF9500',
        authorLevel: 'Lv.14',
        timeAgo: '2小时前',
        location: '江苏',
        title: '【猛兽派对】飞踢与摔投连招技巧！如何成为竞技场霸王',
        content: '跑冲+飞踢可以把人踢出几米远！抓住敌人后旋转两圈再按抛投能直接丢下擂台，快去试试！',
        likesCount: 95,
        commentsCount: 2,
        tag: '派对萌宠',
        coverImg: cover,
        comments: [
          { id: 'c-pa-1', authorName: '锤子帮帮主', authorAvatarBg: '#E67E22', authorLevel: 'Lv.10', timeAgo: '1小时前', content: '哈哈哈哈跟朋友玩笑到肚子痛！', likesCount: 19 },
          { id: 'c-pa-2', authorName: '鳄鱼哥', authorAvatarBg: '#27AE60', authorLevel: 'Lv.8', timeAgo: '30分钟前', content: '抢电风扇关卡太魔性了，互踩真快乐！', likesCount: 8 },
        ],
      },
    ];
  }

  if (gameId === 'love-choice') {
    return [
      {
        id: 'post-lc-1',
        authorName: '心动瞬间',
        authorAvatarBg: '#FF69B4',
        authorLevel: 'Lv.12',
        timeAgo: '4小时前',
        location: '四川',
        title: '《拣爱》全结局达成感受：关于爱、倾听与陪伴',
        content: '通关《吃方便面》与《终章》后感触很深，爱不仅是表达，更是倾听与陪伴。非常治愈的一款国产独立佳作。',
        likesCount: 114,
        commentsCount: 2,
        tag: '情感共鸣',
        coverImg: cover,
        comments: [
          { id: 'c-lc-1', authorName: '盒友3344', authorAvatarBg: '#9B59B6', authorLevel: 'Lv.9', timeAgo: '3小时前', content: '第一章的聊天选项真的好真实，选错就变成直男了！', likesCount: 26 },
          { id: 'c-lc-2', authorName: '晚风与你', authorAvatarBg: '#3498DB', authorLevel: 'Lv.7', timeAgo: '1小时前', content: '配乐太温柔了，打完很久心都是暖的。', likesCount: 14 },
        ],
      },
    ];
  }

  if (gameId === 'miside') {
    return [
      {
        id: 'post-ms-1',
        authorName: '米塔单推人',
        authorAvatarBg: '#2BC48A',
        authorLevel: 'Lv.16',
        timeAgo: '3小时前',
        location: '重庆',
        title: '《MiSide 米塔》全隐藏房间与病娇美少女全结局解密',
        content: '当你以为这只是个二次元恋爱模拟，结果房间突然开始变异……米塔的眼神变化太高能了！',
        likesCount: 142,
        commentsCount: 2,
        tag: '病娇恐怖',
        coverImg: cover,
        comments: [
          { id: 'c-ms-1', authorName: '解密高玩', authorAvatarBg: '#E74C3C', authorLevel: 'Lv.15', timeAgo: '2小时前', content: '米塔太顶了！虽然有点恐怖但真的让人欲罢不能！', likesCount: 38 },
          { id: 'c-ms-2', authorName: '二次元盒友', authorAvatarBg: '#F1C40F', authorLevel: 'Lv.11', timeAgo: '45分钟前', content: '第四章卡带解密太硬核了，看攻略才通过。', likesCount: 17 },
        ],
      },
    ];
  }

  // 通用动态生成器 (保障任何其他游戏均有专属帖子与完整评论)
  return [
    {
      id: `post-${gameId}-1`,
      authorName: '黑盒高能主播',
      authorAvatarBg: '#FF9500',
      authorLevel: 'Lv.20',
      timeAgo: '1天前',
      location: '上海',
      title: `【全网首发】${titleStr} 顶级通关全流程与隐藏成就避坑指南！`,
      content: `详细整理了《${titleStr}》当前版本所有隐藏关卡、全收集道具点位以及单人/联机通关的高效打法，强烈建议收藏备用！`,
      likesCount: 890,
      commentsCount: 3,
      tag: '精选攻略',
      coverImg: cover,
      comments: [
        {
          id: `c-${gameId}-1`,
          authorName: '硬核成就党',
          authorAvatarBg: '#3498DB',
          authorLevel: 'Lv.16',
          timeAgo: '18小时前',
          content: `收藏了！《${titleStr}》全成就达成靠这篇指南省了好多时间！`,
          likesCount: 45,
        },
        {
          id: `c-${gameId}-2`,
          authorName: '游侠小哥',
          authorAvatarBg: '#2ECC71',
          authorLevel: 'Lv.12',
          timeAgo: '12小时前',
          content: '讲解得很细致，关卡机制分析得非常全面，顶一个！',
          likesCount: 22,
        },
        {
          id: `c-${gameId}-3`,
          authorName: '盒友666',
          authorAvatarBg: '#9B59B6',
          authorLevel: 'Lv.8',
          timeAgo: '5小时前',
          content: '画面和打击感确实出彩，近期最值得入手的游戏之一！',
          likesCount: 11,
        },
      ],
    },
    {
      id: `post-${gameId}-2`,
      authorName: '游戏测评君',
      authorAvatarBg: '#1ABC9C',
      authorLevel: 'Lv.15',
      timeAgo: '5小时前',
      location: '杭州',
      title: `《${titleStr}》深度评测：它是否值得你投入上百小时？`,
      content: `从美术画质、剧情演出、音乐音效以及核心核心玩法四个维度深度拆解《${titleStr}》，带你了解最真实的玩家口碑与入手建议。`,
      likesCount: 340,
      commentsCount: 2,
      tag: '深度评测',
      coverImg: cover,
      comments: [
        {
          id: `c-${gameId}-4`,
          authorName: '资深玩家',
          authorAvatarBg: '#E67E22',
          authorLevel: 'Lv.14',
          timeAgo: '3小时前',
          content: '评测中肯！游戏中后期的耐玩度确实很高。',
          likesCount: 19,
        },
        {
          id: `c-${gameId}-5`,
          authorName: '萌新玩家',
          authorAvatarBg: '#E74C3C',
          authorLevel: 'Lv.6',
          timeAgo: '1小时前',
          content: '已入手，体验非常惊艳，没有踩雷！',
          likesCount: 8,
        },
      ],
    },
  ];
}

export function getGameDatabaseItems(gameId: string): DatabaseItem[] {
  return [
    { id: 'db-1', name: '传奇武器 / 核心模组', category: '装备', rarity: '传说', rarityColor: '#FF9500', desc: '增加 45% 输出伤害与 20% 移动速度', icon: '⚔️' },
    { id: 'db-2', name: '高级生存套装', category: '防具', rarity: '史诗', rarityColor: '#B366FF', desc: '全属性抗性 +30%，自带生命恢复效果', icon: '🛡️' },
    { id: 'db-3', name: '稀有培育种子 / 秘能石', category: '材料', rarity: '稀有', rarityColor: '#3399FF', desc: '用于合成顶级道具与解锁特别功能', icon: '💎' },
    { id: 'db-4', name: '全景地图契约', category: '道具', rarity: '普通', rarityColor: '#999999', desc: '解密区域迷雾并标注所有宝箱位置', icon: '🗺️' },
  ];
}

export function getGameRegionPrices(gameId: string): RegionPrice[] {
  const game = getGameById(gameId);
  const basePrice = game ? game.price : 50;
  return [
    { regionName: '中国区 (国区)', flagEmoji: '🇨🇳', priceLocal: `¥ ${basePrice}`, priceCNY: `¥ ${basePrice}`, isLowest: true },
    { regionName: '阿根廷区', flagEmoji: '🇦🇷', priceLocal: `ARS$ ${(basePrice * 180).toFixed(0)}`, priceCNY: `¥ ${(basePrice * 0.92).toFixed(1)}` },
    { regionName: '土耳其区', flagEmoji: '🇹🇷', priceLocal: `₺ ${(basePrice * 4.5).toFixed(0)}`, priceCNY: `¥ ${(basePrice * 0.95).toFixed(1)}` },
    { regionName: '美区', flagEmoji: '🇺🇸', priceLocal: `$ ${(basePrice * 0.14).toFixed(2)}`, priceCNY: `¥ ${(basePrice * 1.05).toFixed(1)}` },
    { regionName: '日区', flagEmoji: '🇯🇵', priceLocal: `¥ ${(basePrice * 21).toFixed(0)}`, priceCNY: `¥ ${(basePrice * 1.02).toFixed(1)}` },
  ];
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


