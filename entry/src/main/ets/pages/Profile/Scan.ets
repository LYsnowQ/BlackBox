import { ScanPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.SCAN / AppRoutes.PROFILE_SCAN
 * 路径 pages/Profile/Scan · 业务：profile.ScanPage
 */
@Entry
@Component
struct Scan {
  build() {
    ScanPage()
  }
}
