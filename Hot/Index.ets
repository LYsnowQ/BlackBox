// Hot 模块对外导出
// entry 仅负责路由壳挂载，业务 UI / 模型均在此模块

export { Hot } from './src/main/ets/pages/Hot/Hot';
export { HotNewsDetail } from './src/main/ets/pages/Hot/HotNewsDetail';

/** 主题（默认 light，dark 调试） */
export * from './src/main/ets/pages/Hot/HotTheme';

/** 业务数据模型导出 */
export * from './src/main/ets/model/HotModel';

/** 路由契约：与 entry main_pages / 壳页面路径对齐 */
export { HotRoutes } from './src/main/ets/router/HotRoutes';
