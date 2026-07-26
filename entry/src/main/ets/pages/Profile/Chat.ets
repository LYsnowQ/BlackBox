import { ChatPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.CHAT / AppRoutes.PROFILE_CHAT
 * 路径 pages/Profile/Chat · 业务：profile.ChatPage
 * params: { id: string }
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct Chat {
  build() {
    Column() {
      ChatPage()
    }
    .width('100%')
    .height('100%')
  }
}
