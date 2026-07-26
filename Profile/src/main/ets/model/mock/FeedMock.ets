/**
 * 个人动态 mock 数据（列表 + 详情，Profile 模块自包含）
 */
import { FeedDetail, FeedItem } from '../types/FeedModel';

export const MOCK_FEED_LIST: FeedItem[] = [
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

/** 动态详情 mock（id 与列表一致） */
export const MOCK_FEED_DETAILS: FeedDetail[] = [
  {
    id: '1',
    title: '深夜独白 · 关于「等待」',
    summary: '有些游戏不是通关了就结束，而是通关后才开始。像把一封写了很久的信，终于投进邮筒。',
    fullContent:
      '有些游戏不是通关了就结束，而是通关后才开始。像把一封写了很久的信，终于投进邮筒。\n\n'
      + '等待本身是一种体验：读档、刷材料、等好友上线、等史低。我们总以为自己在等「下一局」，'
      + '其实是在等一个愿意把时间交给你的理由。\n\n'
      + '这一次，我把等待写成了动态。不急着通关人生，只想把每一局都玩出回味。',
    meta: '2 小时前',
    likes: '2.1k',
    comments: '386',
    tag: '灵感',
    hasCover: true,
    coverColors: ['#1A1A2E', '#4A4A6A'],
    authorName: '雾里听潮',
    authorAvatarChar: '盒',
    authorLevel: 'Lv.48',
    publishTime: '2 小时前',
    region: '上海',
    likeCount: 2100,
    commentCount: 386,
    commentList: [
      {
        id: 'c1-1',
        authorName: '夜航船',
        authorAvatarChar: '夜',
        authorAvatarColor: '#4A5568',
        timeText: '1 小时前 · 浙江',
        content: '写得真好，通关后的空窗期最容易被忽略。',
        likeCount: 42,
      },
      {
        id: 'c1-2',
        authorName: '存档点',
        authorAvatarChar: '存',
        authorAvatarColor: '#2BC48A',
        timeText: '50 分钟前 · 广东',
        content: '「把一封写了很久的信投进邮筒」这句太戳了。',
        likeCount: 28,
      },
      {
        id: 'c1-3',
        authorName: '慢热玩家',
        authorAvatarChar: '慢',
        authorAvatarColor: '#8E44AD',
        timeText: '30 分钟前 · 北京',
        content: '收藏了，下次熬夜打完 Boss 再来读一遍。',
        likeCount: 15,
      },
    ],
  },
  {
    id: '2',
    title: '《黑神话：悟空》',
    summary: '不是标签能概括的作品。镜头、节奏、Boss 设计都在说话：我们终于可以只谈游戏本身了。',
    fullContent:
      '不是标签能概括的作品。镜头、节奏、Boss 设计都在说话：我们终于可以只谈游戏本身了。\n\n'
      + '从序章到终局，它很少用「国产 3A」自我证明，而是用关卡密度与演出完成度让人闭嘴。'
      + '有人说它难，有人说它美——这两件事并不矛盾。\n\n'
      + '我的分数：9.6。扣掉的 0.4 留给还想再打一周目时的挑剔。',
    meta: '昨天 · 9.6 分',
    likes: '8.7k',
    comments: '1.2k',
    tag: '评价',
    hasCover: true,
    coverColors: ['#2A1810', '#8B4513'],
    authorName: '雾里听潮',
    authorAvatarChar: '盒',
    authorLevel: 'Lv.48',
    publishTime: '昨天 21:16',
    region: '上海',
    likeCount: 8700,
    commentCount: 1200,
    commentList: [
      {
        id: 'c2-1',
        authorName: '齐天',
        authorAvatarChar: '齐',
        authorAvatarColor: '#C0392B',
        timeText: '昨天 22:01 · 四川',
        content: '同意 9.6，黄风岭那段演出直接封神。',
        likeCount: 186,
      },
      {
        id: 'c2-2',
        authorName: '棍花练习生',
        authorAvatarChar: '棍',
        authorAvatarColor: '#F39C12',
        timeText: '昨天 23:40 · 江苏',
        content: '「可以只谈游戏本身」这句话比分数更重要。',
        likeCount: 97,
      },
      {
        id: 'c2-3',
        authorName: '二周目战士',
        authorAvatarChar: '二',
        authorAvatarColor: '#2980B9',
        timeText: '今天 08:12 · 湖北',
        content: '扣 0.4 的理由我懂，我也想再打一周目。',
        likeCount: 53,
      },
    ],
  },
  {
    id: '3',
    title: '本周在玩 · Hades II',
    summary: 'Roguelike 的魅力在于「再来一把」的借口永远成立。这一把，只是为了多听一句台词。',
    fullContent:
      'Roguelike 的魅力在于「再来一把」的借口永远成立。这一把，只是为了多听一句台词。\n\n'
      + 'Melinoë 的施法手感比一代更「巫师」，房间节奏也更敢做文章。失败不再像惩罚，'
      + '更像剧情推进的门票。\n\n'
      + '本周时长：42h。如果有人问我周末去哪了——在地府。',
    meta: '3 天前 · 42h',
    likes: '956',
    comments: '128',
    tag: '在玩',
    hasCover: false,
    coverColors: ['#1A0A2E', '#6B2D8B'],
    authorName: '雾里听潮',
    authorAvatarChar: '盒',
    authorLevel: 'Lv.48',
    publishTime: '3 天前',
    region: '上海',
    likeCount: 956,
    commentCount: 128,
    commentList: [
      {
        id: 'c3-1',
        authorName: '早到冥府',
        authorAvatarChar: '冥',
        authorAvatarColor: '#6B2D8B',
        timeText: '2 天前 · 福建',
        content: '42 小时我才刚摸到中期，你太猛了。',
        likeCount: 31,
      },
      {
        id: 'c3-2',
        authorName: '再来一把',
        authorAvatarChar: '再',
        authorAvatarColor: '#26A69A',
        timeText: '2 天前 · 山东',
        content: '「只是为了多听一句台词」完全是我。',
        likeCount: 22,
      },
    ],
  },
  {
    id: '4',
    title: '什么才算好结局？',
    summary: '好结局不一定是圆满。可以是遗憾刚好到可以回味的程度，可以是角色终于学会了告别。',
    fullContent:
      '好结局不一定是圆满。可以是遗憾刚好到可以回味的程度，可以是角色终于学会了告别。\n\n'
      + '有的游戏用 True End 奖励肝帝，有的用 Bad End 讲完最重要的话。'
      + '我更在意：关掉游戏之后，你还会不会想起某个 NPC 的一句口头禅。\n\n'
      + '欢迎在评论区留下你心中的「好结局」——不剧透也可以，只说感觉。',
    meta: '一周前',
    likes: '4.3k',
    comments: '892',
    tag: '讨论',
    hasCover: false,
    coverColors: ['#0D2137', '#1B4F72'],
    authorName: '雾里听潮',
    authorAvatarChar: '盒',
    authorLevel: 'Lv.48',
    publishTime: '一周前',
    region: '上海',
    likeCount: 4300,
    commentCount: 892,
    commentList: [
      {
        id: 'c4-1',
        authorName: '剧情党',
        authorAvatarChar: '剧',
        authorAvatarColor: '#E74C3C',
        timeText: '6 天前 · 重庆',
        content: '对我来说好结局 = 角色得到了选择权，而不是奖杯。',
        likeCount: 120,
      },
      {
        id: 'c4-2',
        authorName: '通关仪式',
        authorAvatarChar: '通',
        authorAvatarColor: '#16A085',
        timeText: '5 天前 · 天津',
        content: '字幕滚起来时若有若无的 BGM，比完美通关更像句号。',
        likeCount: 88,
      },
      {
        id: 'c4-3',
        authorName: '盒友小A',
        authorAvatarChar: 'A',
        authorAvatarColor: '#34495E',
        timeText: '4 天前 · 河南',
        content: '同意「遗憾刚好可以回味」，写进笔记了。',
        likeCount: 45,
      },
    ],
  },
];
