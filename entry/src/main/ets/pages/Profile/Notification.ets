import { NotificationSettingsPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.NOTIFICATION / AppRoutes.PROFILE_NOTIFICATION
 * 路径 pages/Profile/Notification · 业务：profile.NotificationSettingsPage
 */
@Entry
@Component
struct Notification {
  build() {
    Column() {
      NotificationSettingsPage()
    }
    .width('100%')
    .height('100%')
  }
}
