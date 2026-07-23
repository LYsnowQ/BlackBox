import { router } from '@kit.ArkUI';
import { GameItem, gameList } from '../../model/GameModel';

interface QuickNav {
  title: string;
  desc: string;
  icon: string;
  showDot?: boolean;
}

interface BannerSlide {
  title: string;
  subtitle: string;
  colors: [string, string];
}

@Component
export struct RecommendTab {
  @State bannerIndex: number = 0;

  private bannerSlides: BannerSlide[] = [
    { title: '2K厂商促销', subtitle: '文明6/NBA 2K26/无主4 史低', colors: ['#0F1B2B', '#7A1F1F'] },
    { title: '独立游戏节', subtitle: '精选独立游戏 5折起', colors: ['#122A22', '#1F5C4A'] },
    { title: '开放世界精选', subtitle: '开放世界大作史低', colors: ['#0F1B33', '#2A4E8C'] },
  ];

  private quickNavs: QuickNav[] = [
    { title: '黑盒商城', desc: '', icon: '📦' },
    { title: '喜加一', desc: '6款免费', icon: '🎁', showDot: true },
    { title: '赛事中心', desc: '', icon: '🏆' },
    { title: '黑盒语音', desc: '免费AI降噪', icon: '🎙️' },
  ];

  private goDetail(id: string): void {
    router.pushUrl({
      url: 'pages/GameDetail/GameDetail',
      params: { id },
    });
  }

  @Builder
  BannerSlideBuilder(slide: BannerSlide) {
    Row() {
      Column() {
        Text(slide.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text(slide.subtitle)
          .fontSize(11)
          .fontColor('#FFD9B3')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .padding({ left: 14 })

      Row()
        .width(100)
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [[slide.colors[0], 0], [slide.colors[1], 1]],
        })
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 100,
      colors: [[slide.colors[0], 0], [slide.colors[1], 1]],
    })
  }

  @Builder
  QuickNavItemBuilder(item: QuickNav) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
        if (item.showDot) {
          Row()
            .width(5)
            .height(5)
            .borderRadius(3)
            .backgroundColor('#FF3B30')
            .margin({ left: 3 })
        }
      }
      if (item.desc !== '') {
        Text(item.desc)
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 3 })
      }
      Text(item.icon)
        .fontSize(18)
        .margin({ top: item.desc !== '' ? 6 : 14 })
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)
    .height(70)
    .padding(10)
    .backgroundColor('#F5F5F7')
    .borderRadius(12)
  }

  @Builder
  GameCoverBuilder(item: GameItem) {
    Stack({ alignContent: Alignment.BottomStart }) {
      // 封面占位：无真实素材时用渐变 + 标题展示，接入素材后替换为 Image($r('app.media.xxx'))
      Column() {
        // Image($r('app.media.Palworld'))
        Image($r('app.media.chain'))
        // Text(item.englishTitle.toUpperCase())
        //   .fontSize(13)
        //   .fontWeight(FontWeight.Bold)
        //   .fontColor('rgba(255,255,255,0.85)')
        //   .maxLines(2)
        //   .textAlign(TextAlign.Center)
        //   .padding({ left: 8, right: 8 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        angle: 120,
        colors: [[item.gradientColors[0], 0], [item.gradientColors[1], 1]],
      })

      if (item.couponLabel) {
        Text(item.couponLabel)
          .fontSize(10)
          .fontColor(Color.White)
          .backgroundColor('rgba(0,0,0,0.55)')
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .borderRadius({ topRight: 10 })
      }
    }
    .width('100%')
    .aspectRatio(1.72) // 约等于截图中的封面宽高比，避免图片过高
    .borderRadius({ topLeft: 10, topRight: 10 })
    .clip(true)
  }

  @Builder
  GameCardBuilder(item: GameItem) {
    Column() {
      this.GameCoverBuilder(item)

      Text(item.title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 8 })
        .width('100%')

      Row() {
        Text('¥')
          .fontSize(11)
          .fontColor('#FF3B30')
        Text(`${item.price}`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF3B30')
          .margin({ right: 4 })
        if (item.originalPrice) {
          Text(`¥${item.originalPrice}`)
            .fontSize(11)
            .fontColor('#B0B0B0')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ right: 6 })
        }
        Text('券后价')
          .fontSize(10)
          .fontColor('#999999')
        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#3A3A3A')
            .padding({ left: 5, right: 5, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ left: 6 })
        }
        if (item.lowestLabel) {
          Text(item.lowestLabel)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#2BC48A')
            .padding({ left: 5, right: 5, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ left: 4 })
        }
      }
      .width('100%')
      .margin({ top: 6 })

      Row() {
        if (item.rankBoard) {
          Text(item.rankBoard + ' >')
            .fontSize(11)
            .fontColor('#7A7A7A')
            .margin({ right: 6 })
        }
        Text(item.tags.slice(0, 2).join(' | '))
          .fontSize(11)
          .fontColor('#B0B0B0')
      }
      .width('100%')
      .margin({ top: 6 })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => this.goDetail(item.id))
  }

  build() {
    Scroll() {
      Column() {
        Swiper() {
          ForEach(this.bannerSlides, (slide: BannerSlide) => {
            this.BannerSlideBuilder(slide)
          }, (slide: BannerSlide) => slide.title)
        }
        .aspectRatio(5.1) // 参照截图比例，避免轮播图过高
        .width('100%')
        .borderRadius(14)
        .clip(true)
        .autoPlay(true)
        .loop(true)
        .interval(3500)
        .indicator(
          Indicator.dot()
            .itemWidth(5)
            .itemHeight(5)
            .selectedItemWidth(14)
            .selectedItemHeight(5)
            .color('rgba(255,255,255,0.4)')
            .selectedColor(Color.White)
            .left(16)
            .bottom(10)
        )
        .onChange((index: number) => (this.bannerIndex = index))

        Row({ space: 10 }) {
          ForEach(this.quickNavs, (item: QuickNav) => {
            this.QuickNavItemBuilder(item)
          }, (item: QuickNav) => item.title)
        }
        .width('100%')
        .margin({ top: 14 })

        Row() {
          Text('为你推荐')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Blank()
          Text('更多 >')
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .margin({ top: 20, bottom: 12 })

        Grid() {
          ForEach(gameList, (item: GameItem) => {
            GridItem() {
              this.GameCardBuilder(item)
            }
          }, (item: GameItem) => item.id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(16)
        .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 24 })
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .layoutWeight(1)
  }
}
