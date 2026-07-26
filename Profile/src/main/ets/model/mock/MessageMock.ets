/**
 * 消息 / 私信 mock 数据
 */
import {
  ChatMessage,
  ChatSessionBundle,
  MessageSession,
} from '../types/MessageModel';

export const MOCK_MESSAGE_SESSIONS: MessageSession[] = [
  {
    id: 'sys',
    title: '系统通知',
    preview: '你关注的游戏《黑神话：悟空》史低优惠已开启',
    time: '10:24',
    unread: true,
    unreadCount: 2,
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
    unreadCount: 3,
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
    unreadCount: 1,
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
    unreadCount: 0,
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
    unreadCount: 0,
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
    unreadCount: 0,
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
    unreadCount: 0,
    avatarChar: '订',
    avatarColor: '#C8C8CC',
    type: 'order',
  },
];

const MOCK_CHAT_BUNDLES: ChatSessionBundle[] = [
  {
    sessionId: 'sys',
    messages: [
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
  },
  {
    sessionId: 'interact',
    messages: [
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
  },
  {
    sessionId: 'chat_tide',
    messages: [
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
  },
  {
    sessionId: 'chat_pixel',
    messages: [
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
  },
  {
    sessionId: 'activity',
    messages: [
      {
        id: 'ac1',
        isSelf: false,
        content: '独立游戏节现已开启，精选作品 5 折起。活动页可在商城入口查看。',
        time: '周一 11:00',
        showTime: true,
      },
    ],
  },
  {
    sessionId: 'chat_fog',
    messages: [
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
  },
  {
    sessionId: 'order',
    messages: [
      {
        id: 'od1',
        isSelf: false,
        content: '你的订单已发货，请注意查收。物流信息可在订单详情中查看。',
        time: '3/12 14:20',
        showTime: true,
      },
    ],
  },
];

export function getMockChatMessages(sessionId: string): ChatMessage[] {
  for (let i = 0; i < MOCK_CHAT_BUNDLES.length; i++) {
    if (MOCK_CHAT_BUNDLES[i].sessionId === sessionId) {
      return MOCK_CHAT_BUNDLES[i].messages.slice();
    }
  }
  return [];
}

export function getMockMessageSessionById(sessionId: string): MessageSession | undefined {
  for (let i = 0; i < MOCK_MESSAGE_SESSIONS.length; i++) {
    if (MOCK_MESSAGE_SESSIONS[i].id === sessionId) {
      return MOCK_MESSAGE_SESSIONS[i];
    }
  }
  return undefined;
}
