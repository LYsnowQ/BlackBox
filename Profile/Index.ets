// Profile 模块对外导出
// entry 仅负责路由壳挂载，业务 UI / 模型均在此模块

export { Me } from './src/main/ets/pages/Me';
export { SettingsPage } from './src/main/ets/pages/SettingsPage';
export { MessagesPage } from './src/main/ets/pages/MessagesPage';
export { ChatPage } from './src/main/ets/pages/ChatPage';
export { ScanPage } from './src/main/ets/pages/ScanPage';
export { EditProfilePage } from './src/main/ets/pages/EditProfilePage';

/** 路由契约：与 entry main_pages / 壳页面路径对齐 */
export { ProfileRoutes } from './src/main/ets/router/ProfileRoutes';
