import { router } from '@kit.ArkUI';
import { DataTab } from './DataTab';
import { DynamicTab } from './DynamicTab';
import { ProfileRoutes } from '../router/ProfileRoutes';
import { formatUnreadBadge, getUnreadTotalSync } from '../api/MessageApi';

/**
 * 个人中心内容区（嵌入 Index 底部导航「我」）
 * 顶部「数据 / 动态」切换 + 右侧工具入口
 * 布局参照软件小黑盒个人页
 *
 * 路由：使用 ProfileRoutes 契约，由 entry 注册壳页面
 */
@Component
export struct Me {
  // 0 = 数据, 1 = 动态
  @State topTabIndex: number = 0;
  /** 消息入口总未读 */
  @State unreadTotal: number = 0;

  aboutToAppear(): void {
    this.refreshUnread();
  }

  private refreshUnread(): void {
    this.unreadTotal = getUnreadTotalSync();
  }

  private goSettings(): void {
    router.pushUrl({
      url: ProfileRoutes.SETTINGS,
    });
  }

  private goMessages(): void {
    router.pushUrl({
      url: ProfileRoutes.MESSAGES,
    });
  }

  private goScan(): void {
    router.pushUrl({
      url: ProfileRoutes.SCAN,
    });
  }

  @Builder
  TopHeaderBuilder() {
    Row() {
      Row() {
        Text('数据')
          .fontSize(20)
          .fontWeight(this.topTabIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.topTabIndex === 0 ? '#1A1A1A' : '#B0B0B0')
          .onClick(() => (this.topTabIndex = 0))

        Text('动态')
          .fontSize(20)
          .fontWeight(this.topTabIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.topTabIndex === 1 ? '#1A1A1A' : '#B0B0B0')
          .margin({ left: 22 })
          .onClick(() => (this.topTabIndex = 1))
      }

      Blank()

      Row() {
        // 扫一扫
        Text('⬚')
          .fontSize(17)
          .fontColor('#1A1A1A')
          .width(32)
          .height(32)
          .textAlign(TextAlign.Center)
          .onClick(() => this.goScan())

        // 设置
        Text('⚙')
          .fontSize(17)
          .fontColor('#1A1A1A')
          .width(32)
          .height(32)
          .textAlign(TextAlign.Center)
          .margin({ left: 4 })
          .onClick(() => this.goSettings())

        // 邮件 / 消息 + 总未读角标
        Stack({ alignContent: Alignment.TopEnd }) {
          Text('✉')
            .fontSize(17)
            .fontColor('#1A1A1A')
            .width(32)
            .height(32)
            .textAlign(TextAlign.Center)

          if (this.unreadTotal > 0) {
            Text(formatUnreadBadge(this.unreadTotal))
              .fontSize(this.unreadTotal > 9 ? 8 : 9)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
              .constraintSize({ minWidth: 14, minHeight: 14 })
              .padding({ left: this.unreadTotal > 9 ? 3 : 0, right: this.unreadTotal > 9 ? 3 : 0 })
              .borderRadius(7)
              .backgroundColor('#FF3B30')
              .textAlign(TextAlign.Center)
              .offset({ x: 4, y: -2 })
          }
        }
        .width(32)
        .height(32)
        .margin({ left: 4 })
        .onClick(() => this.goMessages())
      }
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding({ left: 16, right: 12, top: 12, bottom: 12 })
  }

  build() {
    Column() {
      this.TopHeaderBuilder()

      if (this.topTabIndex === 0) {
        DataTab()
      } else {
        DynamicTab()
      }
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
    // 从消息页返回时刷新入口角标
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean) => {
      if (isVisible) {
        this.refreshUnread();
      }
    })
  }
}
