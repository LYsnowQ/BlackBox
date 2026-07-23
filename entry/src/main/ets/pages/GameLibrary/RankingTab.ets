import { router } from '@kit.ArkUI';
import { GameItem, gameList } from '../../model/GameModel';

@Component
export struct RankingTab {
  @State platformIndex: number = 0;
  @State categoryIndex: number = 0;

  private platforms: string[] = ['PC', 'Switch', 'PSN', 'Xbox'];
  private categories: string[] = ['最受欢迎', '优惠促销', '最受期待', '商城热销', '当前在线'];
  private filters: string[] = ['付费', '游戏类型', '折扣区间', '评分'];

  private goDetail(id: string): void {
    try {
      router.pushUrl({
        url: 'pages/GameDetail/GameDetail',
        params: { id },
      });
    } catch (err) {
    }
  }

  @Builder
  PlatformTabBuilder(name: string, index: number) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontWeight(this.platformIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.platformIndex === index ? '#1A1A1A' : '#999999')
      Row()
        .width(this.platformIndex === index ? 20 : 0)
        .height(3)
        .borderRadius(2)
        .backgroundColor('#1A1A1A')
        .margin({ top: 6 })
    }
    .padding({ right: 26 })
    .onClick(() => (this.platformIndex = index))
  }

  @Builder
  CategoryTabBuilder(name: string, index: number) {
    Column() {
      Text(name)
        .fontSize(15)
        .fontWeight(this.categoryIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.categoryIndex === index ? '#1A1A1A' : '#666666')
      Row()
        .width(this.categoryIndex === index ? 22 : 0)
        .height(3)
        .borderRadius(2)
        .backgroundColor('#2BC48A')
        .margin({ top: 6 })
    }
    .padding({ right: 20 })
    .onClick(() => (this.categoryIndex = index))
  }

  @Builder
  FilterChipBuilder(name: string) {
    Row() {
      Text(name)
        .fontSize(12)
        .fontColor('#666666')
      Text(' ▾')
        .fontSize(10)
        .fontColor('#999999')
    }
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
    .backgroundColor('#F5F5F7')
    .borderRadius(8)
    .margin({ right: 8 })
  }

  @Builder
  RatingBadgeBuilder(item: GameItem) {
    if (item.rating) {
      Row() {
        Text('🔥')
          .fontSize(9)
        Text(`${item.rating}`)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ left: 2 })
      }
      .padding({ left: 6, right: 8, top: 3, bottom: 3 })
      .borderRadius(6)
      .backgroundColor(item.ratingColor ?? '#FF7A00')
    }
  }

  @Builder
  ThumbBuilder(item: GameItem) {
    Stack({ alignContent: Alignment.TopStart }) {
      if (item.coverImg) {
        Image(item.coverImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Column()
          .width('100%')
          .height('100%')
          .linearGradient({
            angle: 120,
            colors: [[item.gradientColors[0], 0], [item.gradientColors[1], 1]],
          })
      }

      Row() {
        Text('🎮')
          .fontSize(10)
      }
      .width(18)
      .height(18)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(0,0,0,0.4)')
      .borderRadius(4)
      .margin(4)

      if (item.discountPercent) {
        Text(`-${item.discountPercent}%`)
          .fontSize(10)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#E23B3B')
          .padding({ left: 5, right: 5, top: 2, bottom: 2 })
          .borderRadius({ topRight: 8, bottomLeft: 8 })
          .align(Alignment.TopEnd)
      }
    }
    .width(112)
    .aspectRatio(1.72)
    .borderRadius(10)
    .clip(true)
  }

  @Builder
  GameRowBuilder(item: GameItem, rank: number) {
    Row() {
      this.ThumbBuilder(item)

      Column() {
        Text(item.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          if (item.price !== undefined) {
            Text('¥')
              .fontSize(11)
              .fontColor('#1A1A1A')
            Text(`${item.price}`)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ right: 4 })
          }
          if (item.originalPrice) {
            Text(`¥${item.originalPrice}`)
              .fontSize(11)
              .fontColor('#B0B0B0')
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ right: 6 })
          }
          if (item.lowestLabel) {
            Text(item.lowestLabel)
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor('#2BC48A')
              .padding({ left: 5, right: 5, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 6 })
          }
          if (item.couponLabel) {
            Text(item.couponLabel)
              .fontSize(10)
              .fontColor('#FF7A00')
              .backgroundColor('#FFF1E0')
              .padding({ left: 5, right: 5, top: 1, bottom: 1 })
              .borderRadius(3)
          }
        }
        .width('100%')
        .margin({ top: 8 })

        if (item.favoriteCount) {
          Row() {
            Text('♡')
              .fontSize(12)
              .fontColor('#B0B0B0')
            Text(item.favoriteCount)
              .fontSize(12)
              .fontColor('#999999')
              .margin({ left: 4 })
          }
          .margin({ top: 8 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .height(65)
      .justifyContent(FlexAlign.Center)
      .padding({ left: 12 })

      this.RatingBadgeBuilder(item)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .padding({ top: 16, bottom: 16 })
    .onClick(() => this.goDetail(item.id))
  }

  build() {
    Column() {
      Row() {
        ForEach(this.platforms, (name: string, index: number) => {
          this.PlatformTabBuilder(name, index)
        })
      }
      .width('100%')
      .padding({ top: 14, bottom: 14 })

      Row() {
        Scroll() {
          Row() {
            ForEach(this.categories, (name: string, index: number) => {
              this.CategoryTabBuilder(name, index)
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
      }
      .width('100%')

      Row() {
        Scroll() {
          Row() {
            ForEach(this.filters, (name: string) => {
              this.FilterChipBuilder(name)
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .layoutWeight(1)

        Row() {
          Text('▤')
            .fontSize(14)
            .fontColor('#666666')
          Text(' 筛选')
            .fontSize(12)
            .fontColor('#666666')
        }
        .padding({ left: 4 })
      }
      .width('100%')
      .margin({ top: 12, bottom: 8 })

      List() {
        ForEach(gameList, (item: GameItem, index: number) => {
          ListItem() {
            this.GameRowBuilder(item, index + 1)
          }

          if (index !== gameList.length - 1) {
            ListItem() {
              Divider().color('#EDEDED').strokeWidth(1)
            }
          }
        }, (item: GameItem) => item.id)
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .divider({ strokeWidth: 0 })
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 16, right: 16 })
  }
}
