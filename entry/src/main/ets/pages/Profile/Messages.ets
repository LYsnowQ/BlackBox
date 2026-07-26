import { MessagesPage } from 'profile';

/**
 * entry 路由壳：ProfileRoutes.MESSAGES / AppRoutes.PROFILE_MESSAGES
 * 路径 pages/Profile/Messages · 业务：profile.MessagesPage
 *
 * onPageShow 递增 refreshToken，从聊天返回时刷新未读角标
 */
@Entry
@Component
struct Messages {
  @State refreshToken: number = 0;

  onPageShow(): void {
    this.refreshToken = this.refreshToken + 1;
  }

  build() {
    Column() {
      MessagesPage({ refreshToken: this.refreshToken })
    }
    .width('100%')
    .height('100%')
  }
}
