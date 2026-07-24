import { PostDetailPage } from 'home';

/**
 * entry 路由壳：HomeRoutes.POST_DETAIL / AppRoutes.HOME_POST_DETAIL
 * 路径 pages/Home/PostDetail · 业务：home.PostDetailPage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct PostDetail {
  build() {
    Column() {
      PostDetailPage()
    }
    .width('100%')
    .height('100%')
  }
}
