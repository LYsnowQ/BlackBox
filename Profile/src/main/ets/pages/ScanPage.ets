import { router } from '@kit.ArkUI';

/**
 * 扫一扫页内容（占位实现，由 entry 路由壳挂载）
 */
@Component
export struct ScanPage {
  @Builder
  NavBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(26)
        .fontWeight(FontWeight.Lighter)
        .fontColor(Color.White)
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => router.back())

      Text('扫一扫')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .letterSpacing(0.5)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row().width(40).height(40)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
  }

  build() {
    Column() {
      Row().width('100%').height(36)
      this.NavBarBuilder()

      Column({ space: 16 }) {
        // 取景框占位
        Stack({ alignContent: Alignment.Center }) {
          Column()
            .width(240)
            .height(240)
            .borderRadius(16)
            .border({ width: 1.5, color: 'rgba(255,255,255,0.35)' })

          Text('将二维码放入框内')
            .fontSize(13)
            .fontColor('rgba(255,255,255,0.55)')
            .margin({ top: 280 })
            .position({ y: 260 })
        }
        .width(240)
        .height(240)

        Text('支持扫描好友主页、游戏详情等二维码')
          .fontSize(12)
          .fontColor('rgba(255,255,255,0.38)')
          .margin({ top: 48 })
      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#12141A')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
