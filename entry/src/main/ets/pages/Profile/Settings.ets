import { SettingsPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.SETTINGS / AppRoutes.PROFILE_SETTINGS
 * 路径 pages/Profile/Settings · 业务：profile.SettingsPage
 */
@Entry
@Component
struct Settings {
  build() {
    SettingsPage()
  }
}
