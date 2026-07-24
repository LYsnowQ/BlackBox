import { EditProfilePage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.EDIT_PROFILE / AppRoutes.PROFILE_EDIT
 * 路径 pages/Profile/EditProfile · 业务：profile.EditProfilePage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct EditProfile {
  build() {
    Column() {
      EditProfilePage()
    }
    .width('100%')
    .height('100%')
  }
}
