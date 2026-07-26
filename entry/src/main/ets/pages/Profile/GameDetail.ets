import { ProfileGameDetailPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.GAME_DETAIL / AppRoutes.PROFILE_GAME_DETAIL
 * 路径 pages/Profile/GameDetail · 业务：profile.ProfileGameDetailPage
 * params: { id: string } — LibraryGame.id（lg*）
 *
 * 与 pages/GameDetail/GameDetail（gamelibrary）隔离，避免跨模块联动与数据冲突。
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct ProfileGameDetail {
  build() {
    Column() {
      ProfileGameDetailPage()
    }
    .width('100%')
    .height('100%')
  }
}
