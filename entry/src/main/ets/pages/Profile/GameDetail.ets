import { ProfileGameDetailPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.GAME_DETAIL / AppRoutes.PROFILE_GAME_DETAIL
 * 路径 pages/Profile/GameDetail · 业务：profile.ProfileGameDetailPage
 * params: { id: string } — 个人库 lg* 或详情 slug；页内映射后展示商城向详情
 *（复制自 Gamelibrary GameDetail：评分/介绍/社区，非个人时长统计）
 *
 * 与 pages/GameDetail/GameDetail（gamelibrary 包）路径隔离，不 import 对方 HAR。
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
