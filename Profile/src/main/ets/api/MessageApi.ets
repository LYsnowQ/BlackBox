/**
 * 消息 / 私信 API
 *
 * GET  /api/v1/profile/messages/sessions
 * GET  /api/v1/profile/messages/sessions/{id}
 * GET  /api/v1/profile/messages/sessions/{id}/messages
 * POST /api/v1/profile/messages/sessions/{id}/messages
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

const localChatBuckets: LocalChatBucket[] = [];

function findLocalBucket(sessionId: string): LocalChatBucket | undefined {
  for (let i = 0; i < localChatBuckets.length; i++) {
    if (localChatBuckets[i].sessionId === sessionId) {
      return localChatBuckets[i];
    }
  }
  return undefined;
}

function copySession(s: MessageSession): MessageSession {
  return {
    id: s.id,
    title: s.title,
    preview: s.preview,
    time: s.time,
    unread: s.unread,
    avatarChar: s.avatarChar,
    avatarColor: s.avatarColor,
    type: s.type,
  };
}

function copyMessage(m: ChatMessage): ChatMessage {
  return {
    id: m.id,
    isSelf: m.isSelf,
    content: m.content,
    time: m.time,
    showTime: m.showTime,
  };
}

/**
 * 消息会话列表
 * GET /api/v1/profile/messages/sessions
 */
export function fetchMessageSessions(): ApiResult<MessageSession[]> {
  const list: MessageSession[] = [];
  for (let i = 0; i < MOCK_MESSAGE_SESSIONS.length; i++) {
    list.push(copySession(MOCK_MESSAGE_SESSIONS[i]));
  }
  return apiOk(list);
}

/**
 * 会话详情
 * GET /api/v1/profile/messages/sessions/{id}
 */
export function fetchMessageSessionById(sessionId: string): ApiResult<MessageSession | null> {
  const s = getMockMessageSessionById(sessionId);
  if (s === undefined) {
    return apiOk(null);
  }
  return apiOk(copySession(s));
}

/**
 * 会话消息列表（mock + 本地发送）
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
 * 发送私信（仅 chat 类型会话）
 * POST /api/v1/profile/messages/sessions/{id}/messages
 */
export function sendChatMessage(req: SendChatMessageRequest): ApiResult<ChatMessage> {
  const session = getMockMessageSessionById(req.sessionId);
  if (session === undefined) {
    return apiFail(4041, '会话不存在', {
      id: '',
      isSelf: true,
      content: '',
      time: '',
    });
  }
  if (session.type !== 'chat') {
    return apiFail(4031, '系统消息不可回复', {
      id: '',
      isSelf: true,
      content: '',
      time: '',
    });
  }
  const text = req.content.trim();
  if (text.length === 0) {
    return apiFail(4001, '内容不能为空', {
      id: '',
      isSelf: true,
      content: '',
      time: '',
    });
  }

  const msg: ChatMessage = {
    id: `local_${Date.now()}`,
    isSelf: true,
    content: text,
    time: '刚刚',
  };

  let bucket = findLocalBucket(req.sessionId);
  if (bucket === undefined) {
    bucket = { sessionId: req.sessionId, messages: [] };
    localChatBuckets.push(bucket);
  }
  bucket.messages.push(msg);
  return apiOk(copyMessage(msg));
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
