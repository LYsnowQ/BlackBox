/**
 * Profile 模块统一 API 响应约定
 *
 * 设计原则：
 * 1. 所有接口返回 ApiResult<T>，便于切换真实网络时统一错误处理
 * 2. code === 0 表示成功；非 0 为业务错误
 * 3. 当前实现为 mock，不抛网络异常；未来 http 层可映射到同一结构
 */

export interface ApiResult<T> {
  /** 0 = 成功 */
  code: number;
  message: string;
  data: T;
}

/** 非泛型基类结果，避免 arkts-no-untyped-obj-literals 在泛型返回处踩坑 */
export class ApiResultHolder<T> {
  code: number;
  message: string;
  data: T;

  constructor(code: number, message: string, data: T) {
    this.code = code;
    this.message = message;
    this.data = data;
  }
}

export function apiOk<T>(data: T, message: string = 'ok'): ApiResult<T> {
  return new ApiResultHolder<T>(0, message, data);
}

export function apiFail<T>(code: number, message: string, data: T): ApiResult<T> {
  return new ApiResultHolder<T>(code, message, data);
}

/** 模拟网络延迟（ms），正式环境可置 0 */
export const MOCK_LATENCY_MS: number = 0;
