import { DarkModePage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.DARK_MODE / AppRoutes.PROFILE_DARK_MODE
 * 路径 pages/Profile/DarkMode · 业务：profile.DarkModePage
 */
@Entry
@Component
struct DarkMode {
  build() {
    Column() {
      DarkModePage()
    }
    .width('100%')
    .height('100%')
  }
}
