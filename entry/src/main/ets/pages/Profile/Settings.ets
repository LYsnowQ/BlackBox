import { SettingsPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.SETTINGS / AppRoutes.PROFILE_SETTINGS
 * 路径 pages/Profile/Settings · 业务：profile.SettingsPage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct Settings {
  build() {
    Column() {
      SettingsPage()
    }
    .width('100%')
    .height('100%')
  }
}
