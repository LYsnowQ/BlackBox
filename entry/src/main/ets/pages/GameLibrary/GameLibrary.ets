import { GameLibrary as GameLibraryComponent } from 'gamelibrary';

/**
 * entry 路由壳：pages/GameLibrary/GameLibrary · 业务：gamelibrary.GameLibrary
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct GameLibrary {
  build() {
    Column() {
      GameLibraryComponent()
    }
    .width('100%')
    .height('100%')
  }
}
