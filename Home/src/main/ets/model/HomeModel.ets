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
  /** 对应 FollowUser.id；关注流按此过滤 */
  authorId: string;
  /** 对应 CircleItem.id；推荐流按此过滤（不含 all） */
  circleId: string;
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
    authorId: '',
    circleId: 'digital',
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
    authorId: '',
    circleId: 'chat',
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
    authorId: 'u4',
    circleId: 'digital',
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
  {
    id: 'r4',
    authorId: '',
    circleId: 'dave',
    authorName: '深海打工人',
    authorAvatarColor: '#4EC6E8',
    authorAvatarText: '海',
    levelLabel: 'Lv.8',
    isOfficial: false,
    isFollowing: false,
    title: '潜水员戴夫：刷完图鉴后的毕业装分享',
    summary: '肝了三周终于集齐图鉴，整理了一套当前版本比较稳的毕业装备路线，适合还在卡关的盒友…',
    images: [
      { mediaKey: 'Palworld', placeholderColor: '#4EC6E8' },
      { mediaKey: 'monster', placeholderColor: '#2A8BB0' },
    ],
    imageCount: 6,
    imageLayout: 'grid',
    tagText: '潜水员戴夫',
    tagTone: 'topic',
    gameTag: '潜水员戴夫',
    timeText: '',
    commentCount: 41,
    likeCount: 156,
  },
  {
    id: 'r5',
    authorId: '',
    circleId: 'steam',
    authorName: '史低雷达',
    authorAvatarColor: '#1B2838',
    authorAvatarText: 'S',
    levelLabel: 'Lv.20',
    isOfficial: true,
    isFollowing: false,
    title: '本周 Steam 史低合集：这几款别再犹豫了',
    summary: '整理本周值得入手的史低与新史低，含动作、策略、独立游戏，附愿望单链接…',
    images: [
      { mediaKey: 'chain', placeholderColor: '#1B2838' },
    ],
    imageCount: 1,
    imageLayout: 'right',
    tagText: 'Steam',
    tagTone: 'topic',
    gameTag: '',
    timeText: '',
    commentCount: 128,
    likeCount: 420,
  },
  {
    id: 'r6',
    authorId: '',
    circleId: 'pc',
    authorName: '帧数狂魔',
    authorAvatarColor: '#E0B84A',
    authorAvatarText: '帧',
    levelLabel: 'Lv.11',
    isOfficial: false,
    isFollowing: false,
    title: '4070 超级画质全开实测：这几款 3A 稳 100+ 帧',
    summary: '统一 1440p + DLSS 质量档，对比无帧生成与有帧生成的体感差异，附设置截图…',
    images: [
      { mediaKey: 'fighter', placeholderColor: '#2B2B2B' },
      { mediaKey: 'nba', placeholderColor: '#D0D4DA' },
      { mediaKey: '', placeholderColor: '#E0B84A' },
    ],
    imageCount: 9,
    imageLayout: 'grid',
    tagText: 'PC游戏',
    tagTone: 'topic',
    gameTag: '',
    timeText: '',
    commentCount: 67,
    likeCount: 233,
  },
  {
    id: 'r7',
    authorId: '',
    circleId: 'chat',
    authorName: '今晚不熬夜',
    authorAvatarColor: '#6B7CFF',
    authorAvatarText: '夜',
    levelLabel: 'Lv.6',
    isOfficial: false,
    isFollowing: false,
    title: '盒友真实：你们是怎么控制买游戏冲动的？',
    summary: '愿望单已经三位数了，每次促销还是忍不住，求靠谱的自制力方法论…',
    images: [
      { mediaKey: '', placeholderColor: '#EEF2FF' },
    ],
    imageCount: 1,
    imageLayout: 'grid',
    tagText: '盒友杂谈',
    tagTone: 'topic',
    gameTag: '',
    timeText: '',
    commentCount: 95,
    likeCount: 188,
  },
];

export const followPosts: FeedPost[] = [
  {
    id: 'f1',
    authorId: 'u1',
    circleId: '',
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
    authorId: 'ux',
    circleId: '',
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
  {
    id: 'f3',
    authorId: 'u2',
    circleId: 'chat',
    authorName: '我不吃牛肉讷',
    authorAvatarColor: '#B8E0D2',
    authorAvatarText: '牛',
    levelLabel: 'Lv.16',
    isOfficial: false,
    isFollowing: true,
    title: '我哭了',
    summary: '其实我是装的(๑> <)☆哈哈哈哈',
    images: [
      { mediaKey: '', placeholderColor: '#E8D5C4' },
    ],
    imageCount: 1,
    imageLayout: 'grid',
    tagText: '盒友杂谈',
    tagTone: 'topic',
    gameTag: '',
    timeText: '昨天13:31',
    commentCount: 87,
    likeCount: 66,
  },
  {
    id: 'f4',
    authorId: 'u2',
    circleId: 'chat',
    authorName: '我不吃牛肉讷',
    authorAvatarColor: '#B8E0D2',
    authorAvatarText: '牛',
    levelLabel: 'Lv.16',
    isOfficial: false,
    isFollowing: true,
    title: '微喇裤焊死在身上',
    summary: 'yyds微喇裤',
    images: [
      { mediaKey: '', placeholderColor: '#3A3A3A' },
    ],
    imageCount: 1,
    imageLayout: 'grid',
    tagText: '盒友杂谈',
    tagTone: 'topic',
    gameTag: '',
    timeText: '2天前',
    commentCount: 48,
    likeCount: 103,
  },
  {
    id: 'f5',
    authorId: 'u2',
    circleId: 'chat',
    authorName: '我不吃牛肉讷',
    authorAvatarColor: '#B8E0D2',
    authorAvatarText: '牛',
    levelLabel: 'Lv.16',
    isOfficial: false,
    isFollowing: true,
    title: '超级可爱特效(๑> <)☆',
    summary: '去今天爽玩11h千恋万花嘻嘻，睡醒就去健身房～',
    images: [
      { mediaKey: '', placeholderColor: '#F0C8D8' },
    ],
    imageCount: 1,
    imageLayout: 'grid',
    tagText: '盒友杂谈',
    tagTone: 'topic',
    gameTag: '',
    timeText: '3天前',
    commentCount: 32,
    likeCount: 91,
  },
  {
    id: 'f6',
    authorId: 'u3',
    circleId: 'chat',
    authorName: '软件格律诗',
    authorAvatarColor: '#F5C16C',
    authorAvatarText: '诗',
    levelLabel: 'Lv.12',
    isOfficial: false,
    isFollowing: true,
    title: '超大更新！有颜值更有音质！11款超热门音乐播放器+歌词工具汇总！',
    summary: '一、SPlayer《被惊艳到！给的真的多，一款伟大的音乐播放器！前方多图警告！》（点击得到）v3.1.1各架构独立构建…',
    images: [
      { mediaKey: '', placeholderColor: '#1A2A3A' },
      { mediaKey: '', placeholderColor: '#0D1B2A' },
      { mediaKey: '', placeholderColor: '#2C1810' },
    ],
    imageCount: 39,
    imageLayout: 'grid',
    tagText: '盒友杂谈',
    tagTone: 'topic',
    gameTag: '',
    timeText: '昨天19:19',
    commentCount: 18,
    likeCount: 73,
  },
  {
    id: 'f7',
    authorId: 'u3',
    circleId: 'chat',
    authorName: '软件格律诗',
    authorAvatarColor: '#F5C16C',
    authorAvatarText: '诗',
    levelLabel: 'Lv.12',
    isOfficial: false,
    isFollowing: true,
    title: '让人大开眼界！近59.2k星标，一份中国独立开发者项目列表，收藏！',
    summary: '如果你关注科技圈、软件产品或者独立开发领域，应该经常会遇到一个问题：国内到底有哪些个人开发者正在做自己的产…',
    images: [
      { mediaKey: '', placeholderColor: '#E8F0F5' },
      { mediaKey: '', placeholderColor: '#F5F0E8' },
    ],
    imageCount: 4,
    imageLayout: 'grid',
    tagText: '盒友杂谈',
    tagTone: 'topic',
    gameTag: '',
    timeText: '昨天11:26',
    commentCount: 3,
    likeCount: 32,
  },
];

export interface CommentReply {
  id: string;
  authorName: string;
  isAuthor: boolean;
  content: string;
  timeText: string;
  region: string;
  replyToName: string;
}

export interface PostComment {
  id: string;
  authorName: string;
  authorAvatarColor: string;
  authorAvatarText: string;
  levelLabel: string;
  isAuthor: boolean;
  isOfficial: boolean;
  isPinned: boolean;
  timeText: string;
  region: string;
  content: string;
  imageKey: string;
  imageColor: string;
  likeCount: number;
  replyTotal: number;
  replies: CommentReply[];
}

export interface PostDetail {
  id: string;
  fullTitle: string;
  authorName: string;
  authorAvatarColor: string;
  authorAvatarText: string;
  levelLabel: string;
  isOfficial: boolean;
  isFollowing: boolean;
  publishTime: string;
  region: string;
  circles: string[];
  hotTag: string;
  heroMediaKey: string;
  heroColor: string;
  caption: string;
  bodyParagraphs: string[];
  relatedLink: string;
  authorNote: string;
  topicTags: string[];
  relatedSearch: string;
  collectionName: string;
  collectionProgress: string;
  likeCount: number;
  starCount: number;
  awardCount: number;
  commentCount: number;
  comments: PostComment[];
}

export const postDetails: PostDetail[] = [
  {
    id: 'r1',
    fullTitle: '30年才迎来革新：Win11正替换Win95时代的属性框，采用WinUI3框架',
    authorName: '明天去月球',
    authorAvatarColor: '#5B8DEF',
    authorAvatarText: '月',
    levelLabel: 'Lv.13',
    isOfficial: true,
    isFollowing: false,
    publishTime: '昨天16:42',
    region: '甘肃',
    circles: ['Steam', '数码硬件'],
    hotTag: '热点第17位',
    heroMediaKey: 'chain',
    heroColor: '#1E3A5F',
    caption: '很喜欢的一张怀旧风壁纸，双击评论区领取～\n关注@明天去月球，黑盒硬件早知道～',
    bodyParagraphs: [
      '作为微软推进 Windows 11 界面现代化的核心动作之一，微软终于开始用全新的现代化版本，替换已沿用数十年的文件资源管理器属性对话框。值得肯定的是，新版属性对话框基于原生 WinUI 框架构建，并未采用 WebView2 网页外壳方案。',
      '比如右键点击某些应用打开属性时，你会看到“安全”“详细信息”“以前的版本”，甚至第三方扩展选项卡共存。目前尚不清楚微软将如何整合这些旧版第三方选项卡，但可以推测微软已经找到了反向孤岛的可行实现路径。',
      '另一个值得关注的问题是：WinUI 界面历来存在运行时加载导致的冷启动延迟问题。即便到今天，文件资源管理器的 XAML 右键菜单也正因这一点饱受诟病。和不使用 WinUI 的“此电脑”页面相比，文件资源管理器的“主页”选项卡响应速度明显更慢。',
      '随着微软计划对 WinUI 3 进行专项性能优化，希望这些问题应该很快会得到解决 ——',
    ],
    relatedLink: 'DLSS 5 详解：三大模型、可逐对象控制，能否单显卡实现尚不明确',
    authorNote: '不要光收藏啊喂\n记得给主包点赞充\n这是主包更新的动力',
    topicTags: ['热点计划', '盒友日常', '微软', 'windows 11', '单机游戏专项创作计划', 'windows'],
    relatedSearch: 'Windows 资源管理器 优化',
    collectionName: '合集【硬件新闻速递】',
    collectionProgress: '1/338',
    likeCount: 517,
    starCount: 203,
    awardCount: 37,
    commentCount: 236,
    comments: [
      {
        id: 'c1',
        authorName: '明天去月球',
        authorAvatarColor: '#5B8DEF',
        authorAvatarText: '月',
        levelLabel: 'Lv.13',
        isAuthor: true,
        isOfficial: true,
        isPinned: true,
        timeText: '昨天17:02',
        region: '甘肃',
        content: '壁纸在这～',
        imageKey: 'chain',
        imageColor: '#1E3A5F',
        likeCount: 77,
        replyTotal: 13,
        replies: [
          {
            id: 'c1r1',
            authorName: '空梦i',
            isAuthor: false,
            content: '收到',
            timeText: '昨天17:47',
            region: '广东',
            replyToName: '',
          },
          {
            id: 'c1r2',
            authorName: '二游领域大神',
            isAuthor: false,
            content: 'xp壁纸',
            timeText: '昨天17:59',
            region: '广东',
            replyToName: '',
          },
          {
            id: 'c1r3',
            authorName: 'miku',
            isAuthor: false,
            content: '壁纸',
            timeText: '昨天18:31',
            region: '山西',
            replyToName: '',
          },
          {
            id: 'c1r4',
            authorName: '齐晶羽',
            isAuthor: false,
            content: '小红车上有吗lz',
            timeText: '昨天18:37',
            region: '河北',
            replyToName: '',
          },
          {
            id: 'c1r5',
            authorName: '明天去月球',
            isAuthor: true,
            content: '这我真不知道，这是我逛外网看到的',
            timeText: '昨天18:43',
            region: '甘肃',
            replyToName: '齐晶羽',
          },
          {
            id: 'c1r6',
            authorName: '華麗的鬼舞',
            isAuthor: false,
            content: '阁下是番茄花园派 还是雨林木风派',
            timeText: '昨天19:08',
            region: '内蒙古',
            replyToName: '',
          },
          {
            id: 'c1r7',
            authorName: '明天去月球',
            isAuthor: true,
            content: '不是风林雨木？',
            timeText: '昨天21:03',
            region: '甘肃',
            replyToName: '華麗的鬼舞',
          },
          {
            id: 'c1r8',
            authorName: '一笑眼成线',
            isAuthor: false,
            content: '雨林沐风',
            timeText: '昨天21:15',
            region: '江苏',
            replyToName: '明天去月球',
          },
          {
            id: 'c1r9',
            authorName: 'SakuraMay',
            isAuthor: false,
            content: '这是原图吗，有出处吗',
            timeText: '昨天21:59',
            region: '上海',
            replyToName: '',
          },
          {
            id: 'c1r10',
            authorName: '明天去月球',
            isAuthor: true,
            content: '是原图，出处已经找不到了，很久之前存的了',
            timeText: '昨天22:00',
            region: '甘肃',
            replyToName: 'SakuraMay',
          },
        ],
      },
      {
        id: 'c2',
        authorName: '悠卡林°C',
        authorAvatarColor: '#9B6B9E',
        authorAvatarText: '悠',
        levelLabel: 'Lv.25',
        isAuthor: false,
        isOfficial: false,
        isPinned: false,
        timeText: '昨天16:49',
        region: '广东',
        content: '做系统给我做好了啊，干嘛呢！',
        imageKey: 'nba',
        imageColor: '#333333',
        likeCount: 582,
        replyTotal: 18,
        replies: [
          {
            id: 'c2r1',
            authorName: 'KRAL',
            isAuthor: false,
            content: '没有那么多真人，其实都是codeX和Cluade',
            timeText: '昨天16:54',
            region: '湖北',
            replyToName: '',
          },
          {
            id: 'c2r2',
            authorName: '心如明鉴照织微',
            isAuthor: false,
            content: '这很体面先生',
            timeText: '昨天16:59',
            region: '江西',
            replyToName: '',
          },
        ],
      },
    ],
  },
  {
    id: 'r2',
    fullTitle: '大学4年没讲明白的神经网络数学，被一段 PyTorch 代码讲透了',
    authorName: '虾米游',
    authorAvatarColor: '#3D5A80',
    authorAvatarText: '虾',
    levelLabel: 'Lv.15',
    isOfficial: false,
    isFollowing: false,
    publishTime: '2天前',
    region: '上海',
    circles: ['百科知识'],
    hotTag: '',
    heroMediaKey: 'mita',
    heroColor: '#E8F0E4',
    caption: '序最近喜欢上学习AI了，我会把我看到的一些好的文章分享给大家。',
    bodyParagraphs: [
      '为什么神经网络能学习？为什么 ReLU 如此重要？把线性层、激活函数和反向传播拆开看，很多“玄学”其实只是矩阵乘法加链式法则。',
      '下面这段最小可运行的 PyTorch 回归示例，几乎覆盖了课上半年讲不清的核心：前向、损失、反向、参数更新。',
    ],
    relatedLink: '',
    authorNote: '有问题评论区见，一起学。',
    topicTags: ['百科知识', 'AI', 'PyTorch'],
    relatedSearch: '神经网络 ReLU',
    collectionName: '',
    collectionProgress: '',
    likeCount: 79,
    starCount: 22,
    awardCount: 3,
    commentCount: 14,
    comments: [
      {
        id: 'r2c1',
        authorName: '学习机器',
        authorAvatarColor: '#5B8DEF',
        authorAvatarText: '学',
        levelLabel: 'Lv.8',
        isAuthor: false,
        isOfficial: false,
        isPinned: false,
        timeText: '1天前',
        region: '北京',
        content: '终于看懂 loss.backward 在干嘛了',
        imageKey: '',
        imageColor: '',
        likeCount: 12,
        replyTotal: 2,
        replies: [
          {
            id: 'r2c1r1',
            authorName: '虾米游',
            isAuthor: true,
            content: '哈哈哈同款经历',
            timeText: '1天前',
            region: '上海',
            replyToName: '',
          },
        ],
      },
    ],
  },
  {
    id: 'r3',
    fullTitle: '知名装机博主XCMOD工作室，卷款跑路国外！',
    authorName: 'Honglizi',
    authorAvatarColor: '#C9A227',
    authorAvatarText: 'H',
    levelLabel: 'Lv.20',
    isOfficial: true,
    isFollowing: true,
    publishTime: '5小时前',
    region: '广东',
    circles: ['数码硬件', 'PC游戏'],
    hotTag: '',
    heroMediaKey: 'fighter',
    heroColor: '#2B2B2B',
    caption: 'B站知名高端PC定制UP主“XCMOD工作室”，被曝卷款跑路！',
    bodyParagraphs: [
      'XCMOD工作室是B站的高端电脑定制类UP主，主要面向高预算装机用户。近期多名消费者反馈付款后无法发货、联系不上。',
      '目前相关信息仍在持续更新中，消费维权请保留合同与转账记录。',
    ],
    relatedLink: '',
    authorNote: '信息来自公开渠道，转载请注明。',
    topicTags: ['数码硬件', '装机', '消费警示'],
    relatedSearch: 'XCMOD 工作室',
    collectionName: '',
    collectionProgress: '',
    likeCount: 312,
    starCount: 88,
    awardCount: 5,
    commentCount: 86,
    comments: [
      {
        id: 'r3c1',
        authorName: '装机老王',
        authorAvatarColor: '#666666',
        authorAvatarText: '王',
        levelLabel: 'Lv.12',
        isAuthor: false,
        isOfficial: false,
        isPinned: false,
        timeText: '3小时前',
        region: '浙江',
        content: '高预算更要走正规渠道…',
        imageKey: '',
        imageColor: '',
        likeCount: 45,
        replyTotal: 0,
        replies: [],
      },
    ],
  },
  {
    id: 'f1',
    fullTitle: '【斯普拉遁：涂击队】首发简评暨情报分享',
    authorName: '天王寺璃奈',
    authorAvatarColor: '#F7C6D8',
    authorAvatarText: '璃',
    levelLabel: 'Lv.25',
    isOfficial: false,
    isFollowing: true,
    publishTime: '9分钟前',
    region: '江苏',
    circles: ['斯普拉遁：涂击队'],
    hotTag: '',
    heroMediaKey: 'Palworld',
    heroColor: '#E85A4F',
    caption: '解禁肝了7小时，最高难度，目前等级28级。',
    bodyParagraphs: [
      '寄语首发手感不错，涂地节奏比想象中更紧。绝大多数时间在练枪线与地图控制，后面补武器表和活动情报。',
    ],
    relatedLink: '',
    authorNote: '有首发问题评论区问我～',
    topicTags: ['斯普拉遁', '首发'],
    relatedSearch: '涂击队 攻略',
    collectionName: '',
    collectionProgress: '',
    likeCount: 0,
    starCount: 2,
    awardCount: 0,
    commentCount: 1,
    comments: [
      {
        id: 'f1c1',
        authorName: '喷子一号',
        authorAvatarColor: '#4AA8D8',
        authorAvatarText: '喷',
        levelLabel: 'Lv.6',
        isAuthor: false,
        isOfficial: false,
        isPinned: false,
        timeText: '刚刚',
        region: '四川',
        content: '求武器强度表！',
        imageKey: '',
        imageColor: '',
        likeCount: 0,
        replyTotal: 0,
        replies: [],
      },
    ],
  },
  {
    id: 'f2',
    fullTitle: '吃饭',
    authorName: '刺客南窗傲',
    authorAvatarColor: '#4A5568',
    authorAvatarText: '刺',
    levelLabel: 'Lv.10',
    isOfficial: false,
    isFollowing: true,
    publishTime: '3天前',
    region: '湖北',
    circles: ['大学日常'],
    hotTag: '',
    heroMediaKey: 'OverCooked',
    heroColor: '#E8C4A0',
    caption: '男同学喊我出来吃饭，各位觉得他是喜欢我吗',
    bodyParagraphs: [
      '火锅配炸物，味道还行。主要是气氛微妙……求盒友分析。',
    ],
    relatedLink: '',
    authorNote: '',
    topicTags: ['大学日常', '情感'],
    relatedSearch: '',
    collectionName: '',
    collectionProgress: '',
    likeCount: 1487,
    starCount: 320,
    awardCount: 12,
    commentCount: 750,
    comments: [
      {
        id: 'f2c1',
        authorName: '旁观盒友',
        authorAvatarColor: '#88AA99',
        authorAvatarText: '旁',
        levelLabel: 'Lv.9',
        isAuthor: false,
        isOfficial: false,
        isPinned: false,
        timeText: '2天前',
        region: '福建',
        content: '喊你吃饭基本稳了',
        imageKey: '',
        imageColor: '',
        likeCount: 210,
        replyTotal: 3,
        replies: [
          {
            id: 'f2c1r1',
            authorName: '刺客南窗傲',
            isAuthor: true,
            content: '真的吗哈哈哈',
            timeText: '2天前',
            region: '湖北',
            replyToName: '',
          },
        ],
      },
    ],
  },
];

export function getPostDetailById(id: string): PostDetail | undefined {
  for (let i = 0; i < postDetails.length; i++) {
    if (postDetails[i].id === id) {
      return postDetails[i];
    }
  }
  return undefined;
}
