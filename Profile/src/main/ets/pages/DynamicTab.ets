import { feedList, FeedItem } from '../model/ProfileModel';

/**
 * 「动态」Tab — 仿小黑盒个人动态流
 */
@Component
export struct DynamicTab {
  @Builder
  FeedCardBuilder(item: FeedItem) {
    Column() {
      Row() {
        Text(item.tag)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2BC48A')
          .letterSpacing(0.2)

        Blank()

        Text(item.meta)
          .fontSize(11)
          .fontColor('#B0B0B0')
      }
      .width('100%')

      Text(item.title)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .letterSpacing(0.2)
        .lineHeight(22)
        .margin({ top: 10 })
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(item.content)
        .fontSize(13)
        .fontColor('#666666')
        .lineHeight(21)
        .margin({ top: 8 })
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (item.hasCover) {
        Column()
          .width('100%')
          .height(120)
          .borderRadius(10)
          .margin({ top: 12 })
          .backgroundColor('#F0F0F2')
      }

      Row({ space: 20 }) {
        Text(`${item.likes} 赞`)
          .fontSize(12)
          .fontColor('#999999')
        Text(`${item.comments} 评`)
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ top: 14 })
    }
    .width('100%')
    .padding(16)
    .margin({ left: 16, right: 16, bottom: 12 })
    .borderRadius(14)
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  EmptyBuilder() {
    Column({ space: 8 }) {
      Text('暂无动态')
        .fontSize(14)
        .fontColor('#999999')
      Text('稍后再来看看')
        .fontSize(12)
        .fontColor('#B0B0B0')
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Scroll() {
      Column() {
        if (feedList.length === 0) {
          this.EmptyBuilder()
        } else {
          Column() {
            ForEach(feedList, (item: FeedItem) => {
              this.FeedCardBuilder(item)
            }, (item: FeedItem) => item.id)

            Text('已经到底了')
              .fontSize(12)
              .fontColor('#B0B0B0')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 4, bottom: 28 })
          }
          .width('100%')
          .padding({ top: 8 })
        }
      }
      .width('100%')
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#F7F7F8')
  }
}
