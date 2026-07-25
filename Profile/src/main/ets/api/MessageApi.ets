/**
 * 消息 / 私信 API
 *
 * GET  /api/v1/profile/messages/sessions
 * GET  /api/v1/profile/messages/sessions/{id}
 * GET  /api/v1/profile/messages/sessions/{id}/messages
 * POST /api/v1/profile/messages/sessions/{id}/messages
 * POST /api/v1/profile/messages/sessions/{id}/read
 * POST /api/v1/profile/messages/sessions/{id}/incoming  (mock 模拟对方新消息)
 */
import { ApiResult, apiFail, apiOk } from './ApiTypes';
import {
  ChatMessage,
  MessageSession,
  SendChatMessageRequest,
} from '../model/types/MessageModel';
import {
  getMockChatMessages,
  getMockMessageSessionById,
  MOCK_MESSAGE_SESSIONS,
} from '../model/mock/MessageMock';

/** 会话内追加的本地消息（按 sessionId） */
interface LocalChatBucket {
  sessionId: string;
  messages: ChatMessage[];
}

/** 会话可变状态（未读 / 预览 / 时间） */
interface SessionRuntime {
  sessionId: string;
  unreadCount: number;
  preview: string;
  time: string;
}

const localChatBuckets: LocalChatBucket[] = [];
const sessionRuntimes: SessionRuntime[] = [];

function findLocalBucket(sessionId: string): LocalChatBucket | undefined {
  for (let i = 0; i < localChatBuckets.length; i++) {
    if (localChatBuckets[i].sessionId === sessionId) {
      return localChatBuckets[i];
    }
  }
  return undefined;
}

function findRuntime(sessionId: string): SessionRuntime | undefined {
  for (let i = 0; i < sessionRuntimes.length; i++) {
    if (sessionRuntimes[i].sessionId === sessionId) {
      return sessionRuntimes[i];
    }
  }
  return undefined;
}

function ensureRuntime(base: MessageSession): SessionRuntime {
  let rt = findRuntime(base.id);
  if (rt === undefined) {
    const created: SessionRuntime = {
      sessionId: base.id,
      unreadCount: base.unreadCount,
      preview: base.preview,
      time: base.time,
    };
    sessionRuntimes.push(created);
    return created;
  }
  return rt;
}

function copySessionFrom(base: MessageSession, rt: SessionRuntime): MessageSession {
  const count = rt.unreadCount < 0 ? 0 : rt.unreadCount;
  const out: MessageSession = {
    id: base.id,
    title: base.title,
    preview: rt.preview,
    time: rt.time,
    unread: count > 0,
    unreadCount: count,
    avatarChar: base.avatarChar,
    avatarColor: base.avatarColor,
    type: base.type,
  };
  return out;
}

function copyMessage(m: ChatMessage): ChatMessage {
  const out: ChatMessage = {
    id: m.id,
    isSelf: m.isSelf,
    content: m.content,
    time: m.time,
    showTime: m.showTime,
  };
  return out;
}

function emptyChatMessage(): ChatMessage {
  const out: ChatMessage = {
    id: '',
    isSelf: true,
    content: '',
    time: '',
  };
  return out;
}

function resolveBaseSession(sessionId: string): MessageSession | undefined {
  return getMockMessageSessionById(sessionId);
}

/**
 * 消息会话列表
 * GET /api/v1/profile/messages/sessions
 */
export function fetchMessageSessions(): ApiResult<MessageSession[]> {
  const list: MessageSession[] = [];
  for (let i = 0; i < MOCK_MESSAGE_SESSIONS.length; i++) {
    const base = MOCK_MESSAGE_SESSIONS[i];
    const rt = ensureRuntime(base);
    list.push(copySessionFrom(base, rt));
  }
  return apiOk(list);
}

/**
 * 会话详情
 * GET /api/v1/profile/messages/sessions/{id}
 */
export function fetchMessageSessionById(sessionId: string): ApiResult<MessageSession | null> {
  const base = resolveBaseSession(sessionId);
  if (base === undefined) {
    return apiOk(null as MessageSession | null);
  }
  const rt = ensureRuntime(base);
  return apiOk(copySessionFrom(base, rt));
}

/**
 * 会话消息列表（mock + 本地发送 / 对方消息）
 * GET /api/v1/profile/messages/sessions/{id}/messages
 */
export function fetchChatMessages(sessionId: string): ApiResult<ChatMessage[]> {
  const base = getMockChatMessages(sessionId);
  const list: ChatMessage[] = [];
  for (let i = 0; i < base.length; i++) {
    list.push(copyMessage(base[i]));
  }
  const bucket = findLocalBucket(sessionId);
  if (bucket !== undefined) {
    for (let j = 0; j < bucket.messages.length; j++) {
      list.push(copyMessage(bucket.messages[j]));
    }
  }
  return apiOk(list);
}

/**
 * 标记会话已读（角标清零）
 * POST /api/v1/profile/messages/sessions/{id}/read
 */
export function markSessionRead(sessionId: string): ApiResult<MessageSession | null> {
  const base = resolveBaseSession(sessionId);
  if (base === undefined) {
    return apiOk(null as MessageSession | null);
  }
  const rt = ensureRuntime(base);
  rt.unreadCount = 0;
  return apiOk(copySessionFrom(base, rt));
}

/**
 * 模拟收到对方 / 系统新消息（未读 +1，刷新预览）
 * POST /api/v1/profile/messages/sessions/{id}/incoming
 * 正式环境由推送 / 轮询驱动；此处供 mock 演示角标累加
 */
export function receiveIncomingMessage(
  sessionId: string,
  content: string
): ApiResult<ChatMessage> {
  const base = resolveBaseSession(sessionId);
  if (base === undefined) {
    return apiFail(4041, '会话不存在', emptyChatMessage());
  }
  const text = content.trim();
  if (text.length === 0) {
    return apiFail(4001, '内容不能为空', emptyChatMessage());
  }

  const msg: ChatMessage = {
    id: `in_${Date.now()}`,
    isSelf: false,
    content: text,
    time: '刚刚',
  };

  let bucket = findLocalBucket(sessionId);
  if (bucket === undefined) {
    const created: LocalChatBucket = {
      sessionId: sessionId,
      messages: [],
    };
    bucket = created;
    localChatBuckets.push(created);
  }
  bucket.messages.push(msg);

  const rt = ensureRuntime(base);
  rt.unreadCount = rt.unreadCount + 1;
  rt.preview = text;
  rt.time = '刚刚';

  return apiOk(copyMessage(msg));
}

/**
 * 发送私信（仅 chat 类型会话）
 * POST /api/v1/profile/messages/sessions/{id}/messages
 */
export function sendChatMessage(req: SendChatMessageRequest): ApiResult<ChatMessage> {
  const base = resolveBaseSession(req.sessionId);
  if (base === undefined) {
    return apiFail(4041, '会话不存在', emptyChatMessage());
  }
  if (base.type !== 'chat') {
    return apiFail(4031, '系统消息不可回复', emptyChatMessage());
  }
  const text = req.content.trim();
  if (text.length === 0) {
    return apiFail(4001, '内容不能为空', emptyChatMessage());
  }

  const msg: ChatMessage = {
    id: `local_${Date.now()}`,
    isSelf: true,
    content: text,
    time: '刚刚',
  };

  let bucket = findLocalBucket(req.sessionId);
  if (bucket === undefined) {
    const created: LocalChatBucket = {
      sessionId: req.sessionId,
      messages: [],
    };
    bucket = created;
    localChatBuckets.push(created);
  }
  bucket.messages.push(msg);

  // 自己发送：更新预览，不增加未读
  const rt = ensureRuntime(base);
  rt.preview = text;
  rt.time = '刚刚';
  // 在会话内发送视为已读
  rt.unreadCount = 0;

  return apiOk(copyMessage(msg));
}

/**
 * 未读总数（Me 页消息入口角标）
 * GET /api/v1/profile/messages/unread-total
 */
export function fetchUnreadTotal(): ApiResult<number> {
  let total = 0;
  for (let i = 0; i < MOCK_MESSAGE_SESSIONS.length; i++) {
    const rt = ensureRuntime(MOCK_MESSAGE_SESSIONS[i]);
    total += rt.unreadCount > 0 ? rt.unreadCount : 0;
  }
  return apiOk(total);
}

/** 同步便捷 */
export function getMessageSessionsSync(): MessageSession[] {
  return fetchMessageSessions().data;
}

export function getMessageSessionByIdSync(sessionId: string): MessageSession | undefined {
  const res = fetchMessageSessionById(sessionId);
  if (res.data === null) {
    return undefined;
  }
  return res.data;
}

export function getChatMessagesSync(sessionId: string): ChatMessage[] {
  return fetchChatMessages(sessionId).data;
}

export function markSessionReadSync(sessionId: string): void {
  markSessionRead(sessionId);
}

export function getUnreadTotalSync(): number {
  return fetchUnreadTotal().data;
}

/**
 * 格式化角标文案：0 不显示；1-99 原样；>99 显示 99+
 */
export function formatUnreadBadge(count: number): string {
  if (count <= 0) {
    return '';
  }
  if (count > 99) {
    return '99+';
  }
  return `${count}`;
}
