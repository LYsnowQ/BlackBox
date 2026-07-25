import { router } from '@kit.ArkUI';
import { MessageSession } from '../model/types/MessageModel';
import { getMessageSessionsSync } from '../api/MessageApi';
import { ProfileRoutes } from '../router/ProfileRoutes';

/**
 * 消息 / 邮件页内容（由 entry 路由壳挂载）
 * 点击会话进入 ChatPage
 */
@Component
export struct MessagesPage {
  private messages: MessageSession[] = getMessageSessionsSync();

  private openChat(item: MessageSession): void {
    router.pushUrl({
      url: ProfileRoutes.CHAT,
      params: { id: item.id },
    });
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
  MessageRowBuilder(item: MessageSession) {
    Row() {
      // 头像
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
            .fontColor('#999999')
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 6 })

          if (item.unread) {
            Row()
              .width(8)
              .height(8)
              .borderRadius(4)
              .backgroundColor('#FF3B30')
              .margin({ left: 8, top: 6 })
          }
        }
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Color.White)
    .onClick(() => this.openChat(item))
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
        }, (item: MessageSession) => item.id)

        ListItem() {
          Text('已经到底了')
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
