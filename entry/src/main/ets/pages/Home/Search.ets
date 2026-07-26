import { HomeSearchPage } from 'home';

/**
 * entry 路由壳：HomeRoutes.SEARCH / AppRoutes.HOME_SEARCH
 * 路径 pages/Home/Search · 业务：home.HomeSearchPage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct HomeSearch {
  build() {
    Column() {
      HomeSearchPage()
    }
    .width('100%')
    .height('100%')
  }
}
