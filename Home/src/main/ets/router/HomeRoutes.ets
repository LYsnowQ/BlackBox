/**
 * Home 模块路由契约
 *
 * 约定：
 * 1. 路径字符串必须与 entry 中 @Entry 壳页面、main_pages.json 完全一致
 * 2. 业务页只通过本契约跳转，禁止硬编码 url
 * 3. entry 负责注册路由；Home HAR 只声明契约并 pushUrl
 * 4. 首页 Tab 内容由 entry Index 挂载，不走 router
 */
export class HomeRoutes {
  /** 帖子详情 params: { id: string, tab?: 'comment' } */
  static readonly POST_DETAIL: string = 'pages/Home/PostDetail';
}
