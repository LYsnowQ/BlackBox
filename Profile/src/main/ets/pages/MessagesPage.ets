import { router } from '@kit.ArkUI';
import { MessageSession } from '../model/types/MessageModel';
import {
  formatUnreadBadge,
  getMessageSessionsSync,
  markSessionReadSync,
  receiveIncomingMessage,
} from '../api/MessageApi';
import { ProfileRoutes } from '../router/ProfileRoutes';

/**
 * 消息 / 邮件页内容（由 entry 路由壳挂载）
 * - 未读角标显示条数（>99 为 99+）
 * - 点击会话进入 Chat 并清零未读
 * - 长按会话：模拟收到一条新消息（未读 +1，演示角标累加）
 * - refreshToken：由 entry 壳 onPageShow 递增，从聊天返回时刷新
 */
@Component
export struct MessagesPage {
  /** entry 壳在 onPageShow 时递增，驱动列表刷新 */
  @Prop @Watch('onRefreshToken') refreshToken: number = 0;
  @State messages: MessageSession[] = [];

  aboutToAppear(): void {
    this.reloadSessions();
  }

  onRefreshToken(): void {
    this.reloadSessions();
  }

  private reloadSessions(): void {
    this.messages = getMessageSessionsSync();
  }

  private openChat(item: MessageSession): void {
    markSessionReadSync(item.id);
    this.reloadSessions();
    router.pushUrl({
      url: ProfileRoutes.CHAT,
      params: {
        'id': item.id,
      },
    });
  }

  /** 长按：模拟该会话收到一条对方消息，未读 +1 */
  private mockIncomingOnRow(item: MessageSession): void {
    const res = receiveIncomingMessage(item.id, `（模拟）来自「${item.title}」的新消息`);
    if (res.code === 0) {
      this.reloadSessions();
    }
  }

  private badgeText(count: number): string {
    return formatUnreadBadge(count);
  }

  @Builder
  NavBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(26)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#1A1A1A')
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => router.back())

      Text('消息')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .letterSpacing(0.5)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row().width(40).height(40)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
  }

  @Builder
  UnreadBadgeBuilder(count: number) {
    if (count > 0) {
      Text(this.badgeText(count))
        .fontSize(count > 9 ? 9 : 10)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .constraintSize({ minWidth: 16, minHeight: 16 })
        .padding({ left: count > 9 ? 4 : 0, right: count > 9 ? 4 : 0 })
        .borderRadius(8)
        .backgroundColor('#FF3B30')
        .textAlign(TextAlign.Center)
        .margin({ left: 8, top: 4 })
    }
  }

  @Builder
  MessageRowBuilder(item: MessageSession) {
    Row() {
      Column() {
        Text(item.avatarChar)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(item.avatarColor)

      Column() {
        Row() {
          Text(item.title)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(item.time)
            .fontSize(11)
            .fontColor('#B0B0B0')
        }
        .width('100%')

        Row() {
          Text(item.preview)
            .fontSize(13)
            .fontColor(item.unreadCount > 0 ? '#666666' : '#999999')
            .fontWeight(item.unreadCount > 0 ? FontWeight.Medium : FontWeight.Normal)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 6 })

          this.UnreadBadgeBuilder(item.unreadCount)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Color.White)
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture()
          .onAction(() => this.openChat(item)),
        LongPressGesture({ repeat: false })
          .onAction(() => this.mockIncomingOnRow(item))
      )
    )
  }

  build() {
    Column() {
      Row().width('100%').height(36)
      this.NavBarBuilder()

      List() {
        ForEach(this.messages, (item: MessageSession, index: number) => {
          ListItem() {
            Column() {
              this.MessageRowBuilder(item)
              if (index !== this.messages.length - 1) {
                Divider()
                  .color('#F0F0F0')
                  .strokeWidth(0.5)
                  .margin({ left: 72 })
              }
            }
          }
        }, (item: MessageSession) => `${item.id}_${item.unreadCount}_${item.time}_${item.preview}`)

        ListItem() {
          Text('已经到底了 · 长按会话可模拟新消息')
            .fontSize(12)
            .fontColor('#B0B0B0')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 24, bottom: 36 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#F7F7F8')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
