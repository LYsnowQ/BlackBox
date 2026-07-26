import { BlacklistPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.BLACKLIST / AppRoutes.PROFILE_BLACKLIST
 * 路径 pages/Profile/Blacklist · 业务：profile.BlacklistPage
 */
@Entry
@Component
struct Blacklist {
  build() {
    Column() {
      BlacklistPage()
    }
    .width('100%')
    .height('100%')
  }
}
