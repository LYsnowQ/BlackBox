/**
 * 商城向游戏详情附属 mock（社区 / 数据库 / 区价）
 * 页面请走 api/GameCatalogApi。
 */
import { getGameById } from './GameCatalogMock';
import {
  CommunityPost,
  DatabaseItem,
  RegionPrice,
} from '../types/GameCatalogModel';

export {
  CommunityPost,
  PostComment,
  PostCommentReply,
  PostGameCard,
  DatabaseItem,
  RegionPrice,
} from '../types/GameCatalogModel';

export function getGameCommunityPosts(gameId: string): CommunityPost[] {
  const game = getGameById(gameId);
  const titleStr = game ? game.title : '这款游戏';
  const cover = game?.coverImg ?? $r('app.media.background');

  if (gameId === 'chained-together') {
    return [
      {
        id: 'post-chain-1',
        authorName: '晓梦先生Simon',
        authorAvatarBg: '#4A5568',
        authorLevel: 'Lv.12',
        timeAgo: '昨天22:26',
        location: '浙江',
        title: '+++++',
        content: '+++++\n🥰🥰🥰 终于跟兄弟挂着锁链通关地狱级难度的通天塔了！',
        likesCount: 14,
        commentsCount: 3,
        tag: '合作',
        gameCard: {
          title: '链在一起 标准版',
          subTitle: '晓梦先生Simon 购买底交价',
          price: '15.84',
          discount: '-28%',
          lowestTag: '史低成交价',
          coverImg: cover,
        },
        comments: [
          {
            id: 'c-chain-0',
            authorName: '开黑小王子',
            authorAvatarBg: '#26A69A',
            authorLevel: 'Lv.8',
            timeAgo: '昨天23:10·广东',
            content: '这价格牛逼，我也去冲一个！',
            likesCount: 2,
            replies: [
              { authorName: '晓梦先生Simon', content: '快冲！这游戏跟朋友开黑太欢乐了！', timeAgo: '昨天23:15·浙江' }
            ]
          },
          {
            id: 'c-chain-00',
            authorName: '锁链守护者',
            authorAvatarBg: '#8E44AD',
            authorLevel: 'Lv.11',
            timeAgo: '昨天23:40·上海',
            content: '你们俩跳独木桥的时候没掉下去吗？我和我朋友掉回起点三次崩溃了😭',
            likesCount: 5,
            replies: [
              { authorName: '歌者SAKE', targetUser: '锁链守护者', content: '独木桥一定要一个人先走，等稳住了另一个人再跳！', timeAgo: '今天00:05·江苏' }
            ]
          }
        ]
      },
      {
        id: 'post-chain-2',
        authorName: 'xin.',
        authorAvatarBg: '#2E7D32',
        authorLevel: 'Lv.8',
        timeAgo: '昨天19:49',
        postDate: '2天前·湖北',
        location: '湖北',
        title: '求助，有没有大佬帮忙过去，可远程',
        content: '求助，有没有大佬帮忙过去，可远程\n已经卡了一个多小时了😭😭😭',
        likesCount: 18,
        commentsCount: 26,
        tag: '求助',
        relatedSearch: '相关搜索·链在一起 卡关求助',
        coverImg: cover,
        comments: [
          {
            id: 'c-chain-1',
            authorName: '玩家99626925',
            authorAvatarBg: '#78909C',
            timeAgo: '昨天08:24·山东',
            location: '山东',
            content: '过不去就退出游戏重进这个地方，每次进去之后第二个到第三个台子的距离都不太一样，有时候很近，有时候需要冲刺才能跳过去，我也搞不清为什么，但确实存在这个现象😐',
            likesCount: 6,
            replies: [
              { authorName: 'xin.', targetUser: '玩家99626925', content: '真的吗！我等会重进试试，感谢提醒！', timeAgo: '昨天09:10·湖北' }
            ]
          },
          {
            id: 'c-chain-2',
            authorName: '执迷不悟',
            authorAvatarBg: '#5C6BC0',
            authorLevel: 'Lv.17',
            timeAgo: '昨天09:35·广东',
            location: '广东',
            content: '往前两步跳上第一块踏板，往右边走跳第二块踏板，现在面向终点，走到你面向的方向能挪动到最右的地方，等着被刺击飞，可以直接打到终点下面🤪上次无意间发现的',
            likesCount: 12,
            replies: [
              { authorName: '歌者SAKE', targetUser: '执迷不悟', content: '之前看一个四十多分钟速通的，就借用了几次地形击飞，看傻眼了，飞天遁地，玩的不是一个游戏🤪', timeAgo: '昨天15:45·江苏', location: '江苏' },
              { authorName: '执迷不悟', targetUser: '歌者SAKE', content: '速通大佬的物理引擎跟我们不一样，直接拉满抛物线算法的！', timeAgo: '昨天16:02·广东', location: '广东' }
            ]
          },
          {
            id: 'c-chain-3',
            authorName: '丑丑ovo',
            authorAvatarBg: '#EC407A',
            authorLevel: 'Lv.7',
            timeAgo: '昨天19:49·河北',
            location: '河北',
            content: '我有飞天mod，需要直接私我',
            likesCount: 3,
            replies: [
              { authorName: '游侠99', targetUser: '丑丑ovo', content: '开mod就失去这游戏的受虐精髓啦！', timeAgo: '昨天20:10·北京' }
            ]
          },
          {
            id: 'c-chain-4',
            authorName: '我才不是一问三不知',
            authorAvatarBg: '#FFA726',
            authorLevel: 'Lv.10',
            timeAgo: '昨天17:31·广东',
            location: '广东',
            content: '这里我真玩了一个小时 好不容易过了结果独木桥掉下去了',
            likesCount: 8,
          },
        ]
      },
      {
        id: 'post-chain-3',
        authorName: '锁链双子星',
        authorAvatarBg: '#37474F',
        authorLevel: 'Lv.15',
        timeAgo: '昨天18:10',
        location: '四川',
        title: '【搞笑合集】跟死党玩链在一起的名场面：互相拉下水',
        content: '预警：玩这个游戏请保持冷静！本以为是兄弟齐心，结果我刚跳过去，他直接一脚踩空把我从几十米高空拽下去了...',
        likesCount: 42,
        commentsCount: 5,
        tag: '搞笑',
        coverImg: cover,
        comments: [
          { authorName: '友情破裂者', authorAvatarBg: '#D32F2F', authorLevel: 'Lv.9', timeAgo: '昨天19:00·四川', content: '真实！我已经和室友冷战两小时了哈哈哈哈！', likesCount: 15 },
          { authorName: '吃瓜群众', authorAvatarBg: '#F57C00', authorLevel: 'Lv.6', timeAgo: '昨天19:30·重庆', content: '推荐带上受虐狂朋友一起玩，效果翻倍！', likesCount: 8 }
        ]
      }
    ];
  }

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
        content: '经过三天三夜的孵化，终于出了传说+脑筋+凶猛+运动健将的四金战斗帕鲁！分享一下配种路线与词条遗传规律。建议从棉悠悠与疾旋鼬开始洗词条！',
        likesCount: 148,
        commentsCount: 6,
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
            likesCount: 32,
            replies: [
              { authorName: '执念', targetUser: '帕鲁黑心老板', content: '是的！技能带骑乘加成，直接吐息秒杀！', timeAgo: '9小时前·河南' },
              { authorName: '孵蛋专业户', targetUser: '帕鲁黑心老板', content: '你孵了多少个蛋才出四金的？我孵了200个还没出运动健将...', timeAgo: '8小时前·四川' }
            ]
          },
          {
            id: 'c-pal-2',
            authorName: '阿努比斯单推人',
            authorAvatarBg: '#F39C12',
            authorLevel: 'Lv.11',
            timeAgo: '8小时前',
            content: '阿努比斯必须配工匠精神+认真+社畜+稀有！手工搓水泥速度简直飞起！',
            likesCount: 25,
            replies: [
              { authorName: '黑工厂厂长', targetUser: '阿努比斯单推人', content: '社畜词条太贴切了哈哈哈，24小时无休！', timeAgo: '7小时前·广东' }
            ]
          },
          {
            id: 'c-pal-3',
            authorName: '黑盒盒友',
            authorAvatarBg: '#3498DB',
            authorLevel: 'Lv.9',
            timeAgo: '5小时前',
            content: '收藏了，今晚就回家开始黑心工场孵蛋！',
            likesCount: 9,
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
        likesCount: 86,
        commentsCount: 4,
        tag: '游戏讨论',
        coverImg: cover,
        comments: [
          {
            id: 'c-pal-4',
            authorName: '抓宠大师',
            authorAvatarBg: '#2ECC71',
            authorLevel: 'Lv.15',
            timeAgo: '2小时前',
            content: '非常上头！玩法丰富，抓宠+基建根本停不下来。推荐和朋友开专用服务器！',
            likesCount: 18,
            replies: [
              { authorName: '林深时。', targetUser: '抓宠大师', content: '收到！今晚就叫上室友搭建服务器走起！', timeAgo: '1小时前·广东' }
            ]
          },
          {
            id: 'c-pal-5',
            authorName: '盒友9527',
            authorAvatarBg: '#E67E22',
            authorLevel: 'Lv.8',
            timeAgo: '1小时前',
            content: '支持联机开黑，和朋友一起玩乐趣翻倍！看朋友被野外BOSS追着打太快乐了。',
            likesCount: 14,
          },
        ],
      },
      {
        id: 'post-pal-3',
        authorName: '基建建筑狂魔',
        authorAvatarBg: '#16A085',
        authorLevel: 'Lv.16',
        timeAgo: '昨天15:30',
        location: '山东',
        title: '【基地秀】耗时80小时打造的雪山城堡据点！全自动化金属矿场',
        content: '雪山顶据点不仅风景绝佳，而且自带8块金属矿石！布置了4只阿努比斯采矿+2只碎岩龟，每天自动产出上万铁矿！展示一下城堡结构。',
        likesCount: 195,
        commentsCount: 8,
        tag: '基地展示',
        coverImg: cover,
        comments: [
          {
            authorName: '建筑学学士',
            authorAvatarBg: '#2980B9',
            authorLevel: 'Lv.13',
            timeAgo: '昨天16:00·北京',
            content: '大佬这个地基是怎么铺平的？我每次盖楼都卡在地形高低差上...',
            likesCount: 11,
            replies: [
              { authorName: '基建建筑狂魔', targetUser: '建筑学学士', content: '要先从最低的地面铺墙壁，然后往上搭地板，就能完美解决高低差悬空问题！', timeAgo: '昨天16:30·山东' }
            ]
          }
        ]
      }
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

  // 通用动态生成器
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
