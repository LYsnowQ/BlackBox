import { FeedDetailPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.FEED_DETAIL / AppRoutes.PROFILE_FEED_DETAIL
 * 路径 pages/Profile/FeedDetail · 业务：profile.FeedDetailPage
 * params: { id: string }
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct FeedDetail {
  build() {
    Column() {
      FeedDetailPage()
    }
    .width('100%')
    .height('100%')
  }
}
