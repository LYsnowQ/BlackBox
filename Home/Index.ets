// Home 模块对外导出
// entry 仅负责路由壳挂载，业务 UI / 模型均在此模块

export { Home } from './src/main/ets/pages/Home';
export { PostDetailPage } from './src/main/ets/pages/PostDetailPage';
export { HomeSearchPage } from './src/main/ets/pages/HomeSearchPage';
export { UserProfilePage } from './src/main/ets/pages/UserProfilePage';
export { ImagePreviewPage } from './src/main/ets/pages/ImagePreviewPage';
export { HomeRecommend } from './src/main/ets/pages/HomeRecommend';
export { FollowFeed } from './src/main/ets/pages/FollowFeed';
export { PostCard } from './src/main/ets/pages/PostCard';

/** 路由契约：与 entry main_pages / 壳页面路径对齐 */
export { HomeRoutes } from './src/main/ets/router/HomeRoutes';
