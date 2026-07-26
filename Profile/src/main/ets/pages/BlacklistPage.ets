import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

interface BlackUser {
  id: string;
  name: string;
  reason: string;
  avatarChar: string;
}

/**
 * 黑名单
 */
@Component
export struct BlacklistPage {
  @State list: BlackUser[] = [
    { id: 'b1', name: '广告机器人01', reason: '频繁私信', avatarChar: '广' },
    { id: 'b2', name: '杠精小张', reason: '恶意评论', avatarChar: '杠' },
  ];

  private removeUser(id: string): void {
    promptAction.showDialog({
      title: '移出黑名单',
      message: '确定将该用户移出黑名单？',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '移出', color: '#2BC48A' },
      ],
    }).then((result) => {
      if (result.index === 1) {
        this.list = this.list.filter((u: BlackUser) => u.id !== id);
        promptAction.showToast({ message: '已移出', duration: 1500 });
      }
    }).catch(() => {
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

      Text('黑名单')
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
  UserRow(user: BlackUser, isLast: boolean) {
    Column() {
      Row({ space: 12 }) {
        Column() {
          Text(user.avatarChar)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#B0B0B0')

        Column({ space: 4 }) {
          Text(user.name)
            .fontSize(15)
            .fontColor('#1A1A1A')
          Text(user.reason)
            .fontSize(12)
            .fontColor('#999999')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text('移出')
          .fontSize(13)
          .fontColor('#2BC48A')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(14)
          .backgroundColor('rgba(43,196,138,0.10)')
          .onClick(() => this.removeUser(user.id))
      }
      .width('100%')
      .padding({ left: 16, right: 14, top: 14, bottom: 14 })

      if (!isLast) {
        Divider().color('#F0F0F0').strokeWidth(0.5).margin({ left: 68, right: 14 })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      Row().width('100%').height(36)
      this.NavBarBuilder()

      if (this.list.length === 0) {
        Column({ space: 8 }) {
          Text('暂无黑名单用户')
            .fontSize(15)
            .fontColor('#999999')
          Text('被拉黑的用户无法与你互动')
            .fontSize(12)
            .fontColor('#B0B0B0')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            Text(`共 ${this.list.length} 人`)
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
              .padding({ left: 4, top: 18, bottom: 8 })

            Column() {
              ForEach(this.list, (user: BlackUser, index: number) => {
                this.UserRow(user, index === this.list.length - 1)
              }, (user: BlackUser) => user.id)
            }
            .width('100%')
            .borderRadius(14)
            .clip(true)
            .backgroundColor(Color.White)
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 36 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .align(Alignment.Top)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
