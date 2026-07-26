import { AccountSecurityPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.ACCOUNT_SECURITY / AppRoutes.PROFILE_ACCOUNT_SECURITY
 * 路径 pages/Profile/AccountSecurity · 业务：profile.AccountSecurityPage
 */
@Entry
@Component
struct AccountSecurity {
  build() {
    Column() {
      AccountSecurityPage()
    }
    .width('100%')
    .height('100%')
  }
}
