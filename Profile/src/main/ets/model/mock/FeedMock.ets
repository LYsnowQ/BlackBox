/**
 * 个人动态 mock 数据
 */
import { FeedItem } from '../types/FeedModel';

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
