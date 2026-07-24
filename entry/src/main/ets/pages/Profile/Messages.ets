import { MessagesPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.MESSAGES / AppRoutes.PROFILE_MESSAGES
 * 路径 pages/Profile/Messages · 业务：profile.MessagesPage
 *
 * 注意：@Entry 的 build 根节点必须是容器组件，不能直接放自定义组件。
 */
@Entry
@Component
struct Messages {
  build() {
    Column() {
      MessagesPage()
    }
    .width('100%')
    .height('100%')
  }
}
