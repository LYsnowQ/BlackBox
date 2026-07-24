// Gamelibrary 模块对外导出
// entry 仅负责路由壳挂载，业务 UI / 模型均在此模块

export { GameLibrary } from './src/main/ets/pages/GameLibrary/GameLibrary';
export { GameLibraryContent } from './src/main/ets/pages/GameLibrary/GameLibraryContent';
export { RecommendTab } from './src/main/ets/pages/GameLibrary/RecommendTab';
export { RankingTab } from './src/main/ets/pages/GameLibrary/RankingTab';
export { GameDetail } from './src/main/ets/pages/GameDetail/GameDetail';

/** 业务数据模型导出 */
export * from './src/main/ets/model/GameLibrary/GameLibraryModel';
export * from './src/main/ets/model/GameDetail/GameDetailModel';

/** 路由契约：与 entry main_pages / 壳页面路径对齐 */
export { GameLibraryRoutes } from './src/main/ets/router/GameLibraryRoutes';
