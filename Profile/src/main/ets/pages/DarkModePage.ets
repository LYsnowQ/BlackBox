import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

interface ModeOption {
  key: string;
  title: string;
  desc: string;
}

/**
 * 深色模式（演示：本地选择，不改全局主题）
 */
@Component
export struct DarkModePage {
  @State selected: string = 'system';

  private options: ModeOption[] = [
    { key: 'system', title: '跟随系统', desc: '自动匹配系统浅色 / 深色外观' },
    { key: 'light', title: '浅色', desc: '始终使用浅色主题' },
    { key: 'dark', title: '深色', desc: '始终使用深色主题' },
  ];

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object> | undefined;
    if (params && params['mode']) {
      this.selected = String(params['mode']);
    }
  }

  private onSelect(key: string): void {
    this.selected = key;
    const label = this.options.find((o: ModeOption) => o.key === key)?.title ?? '跟随系统';
    promptAction.showToast({ message: `已切换为「${label}」（演示）`, duration: 1500 });
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

      Text('深色模式')
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
  OptionRow(opt: ModeOption, isLast: boolean) {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Text(opt.title)
            .fontSize(15)
            .fontColor('#1A1A1A')
          Text(opt.desc)
            .fontSize(12)
            .fontColor('#999999')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .padding({ right: 12 })

        if (this.selected === opt.key) {
          Text('✓')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#2BC48A')
            .width(24)
            .textAlign(TextAlign.End)
        } else {
          Row().width(24).height(24)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 14, top: 16, bottom: 16 })
      .onClick(() => this.onSelect(opt.key))

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
          Text('外观将应用于整个 App（当前为演示选择）')
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .padding({ left: 4, top: 18, bottom: 8 })

          Column() {
            ForEach(this.options, (opt: ModeOption, index: number) => {
              this.OptionRow(opt, index === this.options.length - 1)
            }, (opt: ModeOption) => opt.key)
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
