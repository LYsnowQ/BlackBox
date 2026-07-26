import { router } from '@kit.ArkUI';

interface NotifRow {
  title: string;
  desc?: string;
  key: string;
}

/**
 * 消息通知
 */
@Component
export struct NotificationSettingsPage {
  @State master: boolean = true;
  @State like: boolean = true;
  @State comment: boolean = true;
  @State follow: boolean = true;
  @State privateMsg: boolean = true;
  @State system: boolean = true;

  private rows: NotifRow[] = [
    { title: '接收通知', desc: '关闭后将不再接收任何推送', key: 'master' },
    { title: '点赞', key: 'like' },
    { title: '评论与回复', key: 'comment' },
    { title: '新增关注', key: 'follow' },
    { title: '私信', key: 'privateMsg' },
    { title: '系统消息', key: 'system' },
  ];

  private getChecked(key: string): boolean {
    if (key === 'master') {
      return this.master;
    }
    if (!this.master) {
      return false;
    }
    if (key === 'like') {
      return this.like;
    }
    if (key === 'comment') {
      return this.comment;
    }
    if (key === 'follow') {
      return this.follow;
    }
    if (key === 'privateMsg') {
      return this.privateMsg;
    }
    return this.system;
  }

  private setChecked(key: string, v: boolean): void {
    if (key === 'master') {
      this.master = v;
      return;
    }
    if (key === 'like') {
      this.like = v;
    } else if (key === 'comment') {
      this.comment = v;
    } else if (key === 'follow') {
      this.follow = v;
    } else if (key === 'privateMsg') {
      this.privateMsg = v;
    } else {
      this.system = v;
    }
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

      Text('消息通知')
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
  RowBuilder(item: NotifRow, isLast: boolean) {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Text(item.title)
            .fontSize(15)
            .fontColor(this.master || item.key === 'master' ? '#1A1A1A' : '#B0B0B0')
          if (item.desc) {
            Text(item.desc)
              .fontSize(12)
              .fontColor('#999999')
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({ right: 12 })

        Toggle({ type: ToggleType.Switch, isOn: this.getChecked(item.key) })
          .selectedColor('#2BC48A')
          .width(48)
          .height(28)
          .enabled(item.key === 'master' || this.master)
          .onChange((v: boolean) => this.setChecked(item.key, v))
      }
      .width('100%')
      .padding({ left: 16, right: 14, top: 14, bottom: 14 })
      .alignItems(VerticalAlign.Center)

      if (!isLast) {
        Divider().color('#F0F0F0').strokeWidth(0.5).margin({ left: 16, right: 14 })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      Row().width('100%').height(36)
      this.NavBarBuilder()

      Scroll() {
        Column() {
          Text('管理各类消息的推送开关')
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .padding({ left: 4, top: 18, bottom: 8 })

          Column() {
            ForEach(this.rows, (item: NotifRow, index: number) => {
              this.RowBuilder(item, index === this.rows.length - 1)
            }, (item: NotifRow) => item.key)
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
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
