import { GameDetail as GameDetailComponent } from 'gamelibrary';

/**
 * entry 路由壳：GameLibraryRoutes.GAME_DETAIL / AppRoutes.GAME_DETAIL
 * 路径 pages/GameDetail/GameDetail · 业务：gamelibrary.GameDetail
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct GameDetail {
  build() {
    Column() {
      GameDetailComponent()
    }
    .width('100%')
    .height('100%')
  }
}
