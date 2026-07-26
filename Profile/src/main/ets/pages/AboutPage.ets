import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

interface AboutRow {
  title: string;
  value?: string;
  showArrow?: boolean;
  action?: string;
}

/**
 * 关于小黑盒
 */
@Component
export struct AboutPage {
  private rows: AboutRow[] = [
    { title: '用户协议', showArrow: true, action: 'terms' },
    { title: '隐私政策', showArrow: true, action: 'privacy' },
    { title: '开源许可', showArrow: true, action: 'oss' },
    { title: '检查更新', value: '已是最新', showArrow: true, action: 'update' },
  ];

  private onRowClick(item: AboutRow): void {
    if (item.action === 'update') {
      promptAction.showToast({ message: '当前已是最新版本 1.0.0', duration: 2000 });
      return;
    }
    const map: Record<string, string> = {
      'terms': '用户协议（演示文案）',
      'privacy': '隐私政策（演示文案）',
      'oss': '开源许可列表（演示）',
    };
    promptAction.showToast({ message: map[item.action ?? ''] ?? item.title, duration: 2000 });
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

      Text('关于小黑盒')
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
  RowBuilder(item: AboutRow, isLast: boolean) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(15)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
        if (item.value) {
          Text(item.value)
            .fontSize(13)
            .fontColor('#999999')
            .margin({ right: item.showArrow ? 8 : 0 })
        }
        if (item.showArrow) {
          Text('›').fontSize(18).fontColor('#C0C0C0').width(16).textAlign(TextAlign.End)
        }
      }
      .width('100%')
      .height(52)
      .padding({ left: 16, right: 14 })
      .onClick(() => this.onRowClick(item))

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
        Column({ space: 0 }) {
          Column({ space: 10 }) {
            Column() {
              Text('盒')
                .fontSize(28)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.White)
            }
            .width(72)
            .height(72)
            .borderRadius(18)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#2BC48A')

            Text('小黑盒')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')

            Text('版本 1.0.0 · HarmonyOS 演示版')
              .fontSize(12)
              .fontColor('#999999')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 28, bottom: 28 })

          Column() {
            ForEach(this.rows, (item: AboutRow, index: number) => {
              this.RowBuilder(item, index === this.rows.length - 1)
            }, (item: AboutRow) => item.title)
          }
          .width('100%')
          .borderRadius(14)
          .clip(true)
          .backgroundColor(Color.White)

          Text('数据均为 mock，无真实网络请求')
            .fontSize(12)
            .fontColor('#B0B0B0')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 28, bottom: 36 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
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
