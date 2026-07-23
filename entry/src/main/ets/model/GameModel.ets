/**
 * 游戏数据模型
 * 说明：项目中暂无真实封面图资源，这里用渐变色 + 标题文字做卡片占位。
 * 后续接入真实素材时，只需把封面渲染部分换成 Image($r('app.media.xxx'))，
 * 其余字段（价格 / 折扣 / 标签 / 统计数据）保持不变即可直接使用。
 */

export interface GameItem {
  id: string;
  title: string;               // 中文标题，如 "Palworld / 幻兽帕鲁"
  englishTitle: string;        // 英文/开发商名，用于详情页副标题
  gradientColors: [string, string]; // 封面占位渐变色
  price: number;                // 券后价 / 现价
  originalPrice?: number;       // 原价（有值时显示删除线）
  discountPercent?: number;     // 折扣百分比，如 30 表示 -30%
  couponLabel?: string;         // 例如 "领券95折"
  lowestLabel?: string;         // 例如 "新史低" / "史低"
  rankLabel?: string;           // 例如 "最受欢迎榜 No.1"
  rankBoard?: string;           // 榜单来源，例如 "商城热销榜 No.4"
  tags: string[];               // 游戏类型标签
  rating?: number;              // 评分，如 9.3
  ratingColor?: string;         // 评分角标颜色
  favoriteCount?: string;       // 收藏数，如 "5.6万"
  onlineNow?: string;           // 当前在线，如 "54.0万"
  yesterdayPeak?: string;       // 昨日峰值在线
  globalSalesRank?: string;     // 全球销量排行
  blackBoxPlayers?: string;     // 小黑盒玩家数
  avgPlayTime?: string;         // 平均游戏时间
  goodRate?: string;            // 全语言好评率
  ratingCount?: string;         // 评分人数，如 "3.9万人评分"
  wishlistCount?: string;       // 心愿单人数
  intro?: string;               // 游戏简介
}

export const gameList: GameItem[] = [
  {
    id: 'palworld',
    title: 'Palworld / 幻兽帕鲁',
    englishTitle: 'Palworld',
    gradientColors: ['#8FD3E8', '#5B9BD5'],
    price: 72,
    originalPrice: 108,
    discountPercent: 30,
    couponLabel: '领券95折',
    lowestLabel: '新史低',
    rankLabel: '最受欢迎榜 No.1',
    rankBoard: '优惠促销榜 NO.1',
    tags: ['动作', '冒险', '独立', '角色扮演', '开放世界', '生存'],
    rating: 9.3,
    ratingColor: '#FF7A00',
    favoriteCount: '5.6万',
    onlineNow: '54.0万',
    yesterdayPeak: '77.9万',
    globalSalesRank: '#2',
    blackBoxPlayers: '693.6万',
    avgPlayTime: '66.6h',
    goodRate: '94%',
    ratingCount: '3.9万人评分',
    wishlistCount: '83.4万',
    intro: '在这片被称为"帕鲁"的神秘大陆上，你可以自由地探索、采集、战斗、建造——还能捕捉、饲养和并肩作战的奇异生物"帕鲁"们一起生活。',
  },
  {
    id: 'chained-together',
    title: '链在一起',
    englishTitle: 'Chained Together',
    gradientColors: ['#D96A4A', '#8B3A2A'],
    price: 16,
    originalPrice: 22,
    discountPercent: 20,
    couponLabel: '领券9折',
    lowestLabel: '史低',
    rankBoard: '商城热销榜 No.4',
    tags: ['合作', '冒险'],
    rating: 8.6,
    ratingColor: '#FF7A00',
    ratingCount: '1.2万人评分',
  },
  {
    id: 'rise-of-tomb-raider',
    title: '古墓丽影：崛起',
    englishTitle: 'Rise of the Tomb Raider',
    gradientColors: ['#3A3A3A', '#171717'],
    price: 21,
    originalPrice: 147,
    discountPercent: 85,
    couponLabel: '领券95折',
    rankBoard: '商城热销榜 No.49',
    tags: ['冒险', '动作'],
    rating: 9.0,
    ratingColor: '#FF7A00',
  },
  {
    id: 'tomb-raider-underworld',
    title: '古墓丽影8：地下世界',
    englishTitle: 'Tomb Raider: Underworld',
    gradientColors: ['#2E4B3C', '#16261E'],
    price: 4,
    originalPrice: 44,
    discountPercent: 90,
    couponLabel: '领券9折',
    rankBoard: '小黑盒热销',
    tags: ['冒险', '动作'],
    rating: 8.2,
    ratingColor: '#FF7A00',
  },
  {
    id: 'green-hell',
    title: '绿色地狱',
    englishTitle: 'Green Hell',
    gradientColors: ['#4C7A3B', '#26401D'],
    price: 9,
    originalPrice: 87,
    discountPercent: 90,
    rankBoard: '商城热销榜 No.32',
    tags: ['生存'],
    rating: 8.8,
    ratingColor: '#FF7A00',
  },
  {
    id: 'home-sheep-home',
    title: '小羊回家',
    englishTitle: 'Home Sheep Home: Farmageddon',
    gradientColors: ['#5C4A8A', '#2E2350'],
    price: 6,
    originalPrice: 36,
    discountPercent: 85,
    rankBoard: '小黑盒热销',
    tags: ['独立', '解谜'],
    rating: 7.9,
    ratingColor: '#B366FF',
  },
  {
    id: 'cod-mw4',
    title: '使命召唤®：现代战争® 4',
    englishTitle: 'Call of Duty: Modern Warfare 4',
    gradientColors: ['#4A4A4A', '#1A1A1A'],
    price: 298,
    tags: ['射击', '动作'],
    favoriteCount: '5.6万',
  },
  {
    id: 'gta5',
    title: '侠盗猎车手 V 增强版',
    englishTitle: 'Grand Theft Auto V Enhanced',
    gradientColors: ['#E0B84C', '#8C6A1F'],
    price: 74,
    originalPrice: 149,
    tags: ['动作', '开放世界'],
    rating: 9.1,
    ratingColor: '#FF7A00',
  },
  {
    id: 'diyou-mang',
    title: '地府有点忙',
    englishTitle: 'Hell Is Us... Busy',
    gradientColors: ['#B8860B', '#4A3300'],
    price: 39,
    originalPrice: 49,
    lowestLabel: '史低',
    tags: ['模拟经营', '独立'],
    favoriteCount: '1.3万',
  },
  {
    id: 'midnight-shift',
    title: '午夜值班',
    englishTitle: 'Midnight Shift',
    gradientColors: ['#3A2E4A', '#1A1226'],
    price: 32,
    originalPrice: 38,
    discountPercent: 10,
    couponLabel: '领券92折',
    lowestLabel: '史低',
    tags: ['恐怖', '解谜'],
    rating: 7.5,
    ratingColor: '#B366FF',
  },
  {
    id: 'forza-horizon-6',
    title: '极限竞速：地平线 6',
    englishTitle: 'Forza Horizon 6',
    gradientColors: ['#4A90D9', '#1F4E8C'],
    price: 298,
    tags: ['竞速', '赛车'],
    rating: 9.2,
    ratingColor: '#FF7A00',
  },
  {
    id: 'rdr2',
    title: '荒野大镖客：救赎2',
    englishTitle: 'Red Dead Redemption 2',
    gradientColors: ['#7A2E2E', '#331010'],
    price: 70,
    originalPrice: 279,
    lowestLabel: '史低',
    tags: ['动作', '开放世界'],
    rating: 9.7,
    ratingColor: '#FF7A00',
  },
  {
    id: 'ac-blackflag',
    title: '刺客信条:黑旗 记忆重置',
    englishTitle: "Assassin's Creed IV: Black Flag Remastered",
    gradientColors: ['#1F5C6B', '#0D2A31'],
    price: 224,
    couponLabel: '领券9折',
    tags: ['动作', '冒险'],
    rating: 8.3,
    ratingColor: '#B366FF',
  },
];

export function getGameById(id: string): GameItem | undefined {
  return gameList.find((item: GameItem) => item.id === id);
}
