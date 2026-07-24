import { MessagesPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.MESSAGES / AppRoutes.PROFILE_MESSAGES
 * 路径 pages/Profile/Messages · 业务：profile.MessagesPage
 */
@Entry
@Component
struct Messages {
  build() {
    MessagesPage()
  }
}
