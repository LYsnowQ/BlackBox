import { ScanPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.SCAN / AppRoutes.PROFILE_SCAN
 * 路径 pages/Profile/Scan · 业务：profile.ScanPage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct Scan {
  build() {
    Column() {
      ScanPage()
    }
    .width('100%')
    .height('100%')
  }
}
