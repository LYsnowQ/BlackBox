/** 首页（关注 / 推荐）mock 数据，独立于 GameModel */

export interface CircleItem {
  id: string;
  name: string;
  iconText: string;
  bgColor: string;
  fgColor: string;
}

export interface FollowUser {
  id: string;
  name: string;
  avatarColor: string;
  avatarText: string;
  hasUpdate: boolean;
}

export interface PostImage {
  /** 资源名；空串表示纯色占位 */
  mediaKey: string;
  placeholderColor: string;
}

export interface FeedPost {
  id: string;
  authorName: string;
  authorAvatarColor: string;
  authorAvatarText: string;
  levelLabel: string;
  isOfficial: boolean;
  isFollowing: boolean;
  title: string;
  summary: string;
  images: PostImage[];
  imageCount: number;
  /** right = 右图左文；grid = 下方多图 */
  imageLayout: string;
  tagText: string;
  tagTone: string;
  gameTag: string;
  timeText: string;
  commentCount: number;
  likeCount: number;
}

export const circleList: CircleItem[] = [
  { id: 'all', name: '全部', iconText: '▣', bgColor: '#E8E8EC', fgColor: '#6B6B75' },
  { id: 'chat', name: '盒友杂谈', iconText: '友', bgColor: '#6B7CFF', fgColor: '#FFFFFF' },
  { id: 'dave', name: '潜水员戴夫', iconText: 'Dave', bgColor: '#4EC6E8', fgColor: '#FFFFFF' },
  { id: 'steam', name: 'Steam', iconText: 'S', bgColor: '#1B2838', fgColor: '#FFFFFF' },
  { id: 'digital', name: '数码硬件', iconText: '硬', bgColor: '#4A4A52', fgColor: '#FFFFFF' },
  { id: 'pc', name: 'PC游戏', iconText: 'PC', bgColor: '#E0B84A', fgColor: '#FFFFFF' },
];

export const followUsers: FollowUser[] = [
  { id: 'u1', name: '天王寺璃奈', avatarColor: '#F7C6D8', avatarText: '璃', hasUpdate: false },
  { id: 'u2', name: '我不吃牛肉讷', avatarColor: '#B8E0D2', avatarText: '牛', hasUpdate: true },
  { id: 'u3', name: '软件格律诗', avatarColor: '#F5C16C', avatarText: '诗', hasUpdate: true },
  { id: 'u4', name: 'Honglizi', avatarColor: '#C9A227', avatarText: 'H', hasUpdate: true },
  { id: 'u5', name: '折纸qwq', avatarColor: '#5B7CFF', avatarText: '折', hasUpdate: true },
  { id: 'u6', name: '兔兔阿', avatarColor: '#FFD6A5', avatarText: '兔', hasUpdate: false },
];

export const recommendPosts: FeedPost[] = [
  {
    id: 'r1',
    authorName: '明天去月球',
    authorAvatarColor: '#5B8DEF',
    authorAvatarText: '月',
    levelLabel: 'Lv.13',
    isOfficial: true,
    isFollowing: false,
    title: '30年才迎来革新：Win11正替换Win95时代的属性框，采用Wi…',
    summary: '很喜欢的一张怀旧风壁纸，双击评论区领取～关注@明天去月球，黑盒硬件早知…',
    images: [
      { mediaKey: 'chain', placeholderColor: '#2A3340' },
    ],
    imageCount: 1,
    imageLayout: 'right',
    tagText: '热点第17位',
    tagTone: 'hot',
    gameTag: '',
    timeText: '',
    commentCount: 202,
    likeCount: 387,
  },
  {
    id: 'r2',
    authorName: '虾米游',
    authorAvatarColor: '#3D5A80',
    authorAvatarText: '虾',
    levelLabel: 'Lv.15',
    isOfficial: false,
    isFollowing: false,
    title: '大学4年没讲明白的神经网络数学，被一段 PyTorch 代码讲透了',
    summary: '序最近喜欢上学习AI了，我会把我看到的一些好的文章分享给大家。为什么神经网络能学习？为什么 ReLU 如此重要？为…',
    images: [
      { mediaKey: '', placeholderColor: '#EDE6D9' },
      { mediaKey: '', placeholderColor: '#E8EEF5' },
      { mediaKey: 'mita', placeholderColor: '#E8F0E4' },
    ],
    imageCount: 24,
    imageLayout: 'grid',
    tagText: '百科知识',
    tagTone: 'wiki',
    gameTag: '',
    timeText: '',
    commentCount: 14,
    likeCount: 79,
  },
  {
    id: 'r3',
    authorName: 'Honglizi',
    authorAvatarColor: '#C9A227',
    authorAvatarText: 'H',
    levelLabel: '',
    isOfficial: true,
    isFollowing: true,
    title: '知名装机博主XCMOD工作室，卷款跑路国外！',
    summary: 'B站知名高端PC定制UP主“XCMOD工作室”，被曝卷款跑路！XCMOD工作室是B站的高端电脑定制类UP主，主要面…',
    images: [
      { mediaKey: 'nba', placeholderColor: '#D0D4DA' },
      { mediaKey: 'fighter', placeholderColor: '#2B2B2B' },
    ],
    imageCount: 12,
    imageLayout: 'grid',
    tagText: '',
    tagTone: '',
    gameTag: '',
    timeText: '',
    commentCount: 86,
    likeCount: 312,
  },
];

export const followPosts: FeedPost[] = [
  {
    id: 'f1',
    authorName: '天王寺璃奈',
    authorAvatarColor: '#F7C6D8',
    authorAvatarText: '璃',
    levelLabel: 'Lv.25',
    isOfficial: false,
    isFollowing: true,
    title: '【斯普拉遁：涂击队】首发简评暨情报分享',
    summary: '解禁肝了7小时，最高难度，目前等级28级，绝大多数时间…',
    images: [
      { mediaKey: 'Palworld', placeholderColor: '#E85A4F' },
      { mediaKey: 'party', placeholderColor: '#F0A040' },
      { mediaKey: 'monster', placeholderColor: '#4AA8D8' },
    ],
    imageCount: 7,
    imageLayout: 'grid',
    tagText: '',
    tagTone: '',
    gameTag: '斯普拉遁：涂击队',
    timeText: '9分钟前',
    commentCount: 1,
    likeCount: 0,
  },
  {
    id: 'f2',
    authorName: '刺客南窗傲',
    authorAvatarColor: '#4A5568',
    authorAvatarText: '刺',
    levelLabel: 'Lv.10',
    isOfficial: false,
    isFollowing: true,
    title: '吃饭',
    summary: '男同学喊我出来吃饭，各位觉得他是喜欢我吗',
    images: [
      { mediaKey: 'OverCooked', placeholderColor: '#E8C4A0' },
    ],
    imageCount: 1,
    imageLayout: 'grid',
    tagText: '大学日常',
    tagTone: 'topic',
    gameTag: '',
    timeText: '3天前',
    commentCount: 750,
    likeCount: 1487,
  },
];
