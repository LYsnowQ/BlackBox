/**
 * 消息 / 私信 · 类型定义
 */

/** 消息会话类型 */
export type MessageSessionType = 'chat' | 'system' | 'interaction' | 'activity' | 'order';

/** 消息列表项（邮件页） */
export interface MessageSession {
  id: string;
  title: string;
  preview: string;
  time: string;
  unread: boolean;
  /** 头像占位字 */
  avatarChar: string;
  /** 头像底色 */
  avatarColor: string;
  type: MessageSessionType;
}

/** 单条聊天消息 */
export interface ChatMessage {
  id: string;
  /** true = 当前用户发出 */
  isSelf: boolean;
  content: string;
  time: string;
  /** 是否在气泡上方展示时间分隔 */
  showTime?: boolean;
}

/** 发送私信请求 */
export interface SendChatMessageRequest {
  sessionId: string;
  content: string;
}

/** 会话消息包（列表存储结构） */
export interface ChatSessionBundle {
  sessionId: string;
  messages: ChatMessage[];
}
