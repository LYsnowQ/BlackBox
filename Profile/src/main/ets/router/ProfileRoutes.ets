/**
 * Profile 模块路由契约
 *
 * 约定：
 * 1. 路径字符串必须与 entry 中 @Entry 壳页面、main_pages.json 完全一致
 * 2. 业务页只通过本契约跳转，禁止硬编码 url
 * 3. entry 负责注册路由；Profile HAR 只声明契约并 pushUrl
 */
export class ProfileRoutes {
  /** 设置 */
  static readonly SETTINGS: string = 'pages/Profile/Settings';
  /** 消息 */
  static readonly MESSAGES: string = 'pages/Profile/Messages';
  /** 扫一扫 */
  static readonly SCAN: string = 'pages/Profile/Scan';
  /** 编辑个人资料 */
  static readonly EDIT_PROFILE: string = 'pages/Profile/EditProfile';
  /** 消息聊天 params: { id: string } */
  static readonly CHAT: string = 'pages/Profile/Chat';
}
