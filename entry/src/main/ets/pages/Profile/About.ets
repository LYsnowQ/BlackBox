import { AboutPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.ABOUT / AppRoutes.PROFILE_ABOUT
 * 路径 pages/Profile/About · 业务：profile.AboutPage
 */
@Entry
@Component
struct About {
  build() {
    Column() {
      AboutPage()
    }
    .width('100%')
    .height('100%')
  }
}
