import { ImagePreviewPage } from 'home';

/**
 * entry 路由壳：HomeRoutes.IMAGE_PREVIEW / AppRoutes.HOME_IMAGE_PREVIEW
 * 路径 pages/Home/ImagePreview · 业务：home.ImagePreviewPage
 */
@Entry
@Component
struct HomeImagePreview {
  build() {
    Column() {
      ImagePreviewPage()
    }
    .width('100%')
    .height('100%')
  }
}
