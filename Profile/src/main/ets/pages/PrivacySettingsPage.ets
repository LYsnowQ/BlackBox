import { router } from '@kit.ArkUI';

interface PrivacyRow {
  title: string;
  desc?: string;
  key: string;
}

/**
 * 隐私设置
 */
@Component
export struct PrivacySettingsPage {
  @State showOnline: boolean = true;
  @State allowStrangerMsg: boolean = false;
  @State showGameLibrary: boolean = true;
  @State showDynamic: boolean = true;
  @State recommendFriends: boolean = true;

  private rows: PrivacyRow[] = [
    { title: '展示在线状态', desc: '关闭后好友将无法看到你是否在线', key: 'online' },
    { title: '允许陌生人私信', desc: '关闭后仅互关好友可发私信', key: 'stranger' },
    { title: '公开游戏库', desc: '关闭后他人无法查看你的游戏库', key: 'library' },
    { title: '公开动态', desc: '关闭后动态仅自己可见', key: 'dynamic' },
    { title: '向我推荐可能认识的人', key: 'recommend' },
  ];

  private getChecked(key: string): boolean {
    if (key === 'online') {
      return this.showOnline;
    }
    if (key === 'stranger') {
      return this.allowStrangerMsg;
    }
    if (key === 'library') {
      return this.showGameLibrary;
    }
    if (key === 'dynamic') {
      return this.showDynamic;
    }
    return this.recommendFriends;
  }

  private setChecked(key: string, v: boolean): void {
    if (key === 'online') {
      this.showOnline = v;
    } else if (key === 'stranger') {
      this.allowStrangerMsg = v;
    } else if (key === 'library') {
      this.showGameLibrary = v;
    } else if (key === 'dynamic') {
      this.showDynamic = v;
    } else {
      this.recommendFriends = v;
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

      Text('隐私设置')
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
  RowBuilder(item: PrivacyRow, isLast: boolean) {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Text(item.title)
            .fontSize(15)
            .fontColor('#1A1A1A')
          if (item.desc) {
            Text(item.desc)
              .fontSize(12)
              .fontColor('#999999')
              .maxLines(2)
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({ right: 12 })

        Toggle({ type: ToggleType.Switch, isOn: this.getChecked(item.key) })
          .selectedColor('#2BC48A')
          .width(48)
          .height(28)
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
          Text('控制谁可以看到你的信息')
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .padding({ left: 4, top: 18, bottom: 8 })

          Column() {
            ForEach(this.rows, (item: PrivacyRow, index: number) => {
              this.RowBuilder(item, index === this.rows.length - 1)
            }, (item: PrivacyRow) => item.key)
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
