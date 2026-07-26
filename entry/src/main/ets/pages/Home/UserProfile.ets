import { UserProfilePage } from 'home';

/**
 * entry 路由壳：HomeRoutes.USER_PROFILE / AppRoutes.HOME_USER_PROFILE
 * 路径 pages/Home/UserProfile · 业务：home.UserProfilePage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct HomeUserProfile {
  build() {
    Column() {
      UserProfilePage()
    }
    .width('100%')
    .height('100%')
  }
}
