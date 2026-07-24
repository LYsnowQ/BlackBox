/**
 * Gamelibrary 模块路由契约
 *
 * 约定：
 * 1. 路径字符串必须与 entry 中 @Entry 壳页面、main_pages.json 完全一致
 * 2. 业务页只通过本契约跳转，禁止硬编码 url
 * 3. entry 负责注册路由；Gamelibrary HAR 只声明契约并 pushUrl
 */
export class GameLibraryRoutes {
  /** 游戏详情（params: { id: string }） */
  static readonly GAME_DETAIL: string = 'pages/GameDetail/GameDetail';
}
