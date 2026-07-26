import { PrivacySettingsPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.PRIVACY / AppRoutes.PROFILE_PRIVACY
 * 路径 pages/Profile/Privacy · 业务：profile.PrivacySettingsPage
 */
@Entry
@Component
struct Privacy {
  build() {
    Column() {
      PrivacySettingsPage()
    }
    .width('100%')
    .height('100%')
  }
}
