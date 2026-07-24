import { HotNewsDetail as HotNewsDetailComponent } from 'hot';

/**
 * entry 路由壳：HotRoutes.NEWS_DETAIL / AppRoutes.HOT_NEWS_DETAIL
 * 路径 pages/Hot/HotNewsDetail · 业务：hot.HotNewsDetail
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct HotNewsDetail {
  build() {
    Column() {
      HotNewsDetailComponent()
    }
    .width('100%')
    .height('100%')
  }
}
