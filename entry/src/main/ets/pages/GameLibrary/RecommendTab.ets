import { router } from '@kit.ArkUI';
import { GameItem, gameList, getGameById } from '../../model/GameModel';

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
  bgImg?: ResourceStr;
}

interface HotSellerItem {
  id: string;
  title: string;
  price: number;
  originalPrice?: number;
  discountPercent?: number;
  couponLabel?: string;
  coverImg: ResourceStr;
}

@Component
export struct RecommendTab {
  @State bannerIndex: number = 0;

  private bannerSlides: BannerSlide[] = [
    { title: '黑盒大促', subtitle: '夏日冲浪季', colors: ['#0F1B2B', '#7A1F1F'], bgImg: $r('app.media.background') },
    { title: '2K厂商促销', subtitle: '文明6/NBA 2K26/无主4 史低', colors: ['#0F1B2B', '#7A1F1F'] },
    { title: '独立游戏节', subtitle: '精选独立游戏 5折起', colors: ['#122A22', '#1F5C4A'] },
  ];

  private quickNavs: QuickNav[] = [
    { title: '黑盒商城', desc: '', icon: '🛍️' },
    { title: '喜加一', desc: '6款免费', icon: '🎁', showDot: true },
    { title: '赛事中心', desc: '', icon: '🏆' },
    { title: '黑盒语音', desc: '免费AI降噪', icon: '🎙️' },
  ];

  private forYouIds: string[] = [
    'palworld',
    'party-animals',
    'chained-together',
    'rise-of-tomb-raider',
    'love-choice',
    'mita',
  ];

  private steamSaleIds: string[] = [
    'overcooked2',
    'resident-evil-4',
    'monster-hunter-world',
    'monster-hunter-rise',
    'street-fighter-6',
    'nba-2k26',
  ];

  private hotSellers: HotSellerItem[] = [
    {
      id: 'palworld',
      title: 'Palworld / 幻兽帕鲁-标准版',
      price: 72,
      originalPrice: 108,
      discountPercent: 30,
      couponLabel: '领券95折',
      coverImg: $r('app.media.Palworld'),
    },
    {
      id: 'mita',
      title: '午夜值班-标准版',
      price: 32,
      originalPrice: 38,
      discountPercent: 10,
      couponLabel: '领券92折',
      coverImg: $r('app.media.mita'),
    },
    {
      id: 'tomb-raider-underworld',
      title: '绝地求生 10000+1200 G-coin',
      price: 631,
      couponLabel: '领券93折',
      coverImg: $r('app.media.tomb'),
    },
    {
      id: 'rise-of-tomb-raider',
      title: '碧蓝航线 交叉领域',
      price: 28,
      couponLabel: '领券9折',
      coverImg: $r('app.media.rise'),
    },
  ];

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
  BannerSlideBuilder(slide: BannerSlide) {
    Stack({ alignContent: Alignment.TopStart }) {
      if (slide.bgImg) {
        Image(slide.bgImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Row()
          .width('100%')
          .height('100%')
          .linearGradient({
            angle: 100,
            colors: [[slide.colors[0], 0], [slide.colors[1], 1]],
          })
      }

      Row() {
        Text('小黑盒')
          .fontSize(9)
          .fontColor(Color.White)
          .backgroundColor('rgba(0,0,0,0.5)')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
      }
      .margin({ left: 12, top: 10 })

      Column() {
        Text(slide.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text(slide.subtitle)
          .fontSize(12)
          .fontColor('#FFD9B3')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16, top: 32 })
    }
    .width('100%')
    .height('100%')
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
  SectionHeaderBuilder(title: string) {
    Row() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
      Blank()
      Text('更多 >')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .margin({ top: 20, bottom: 12 })
  }

  @Builder
  GameCoverBuilder(item: GameItem) {
    Stack({ alignContent: Alignment.TopStart }) {
      if (item.coverImg) {
        Image(item.coverImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Column() {
          Text(item.englishTitle.toUpperCase())
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('rgba(255,255,255,0.85)')
            .maxLines(2)
            .textAlign(TextAlign.Center)
            .padding({ left: 8, right: 8 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 120,
          colors: [[item.gradientColors[0], 0], [item.gradientColors[1], 1]],
        })
      }

      if (item.couponLabel) {
        Text(item.couponLabel)
          .fontSize(10)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#FFA033')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius({ topRight: 8, bottomRight: 8 })
      }
    }
    .width('100%')
    .aspectRatio(1.72)
    .borderRadius(10)
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
        if (item.platformIcon === 'steam') {
          Text('♨')
            .fontSize(12)
            .fontColor('#1A1A1A')
            .margin({ right: 3 })
        } else {
          Text('☖')
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ right: 3 })
        }

        Text('¥')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
        Text(`${item.price}`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ right: 4 })

        if (item.originalPrice) {
          Text(`¥${item.originalPrice}`)
            .fontSize(11)
            .fontColor('#B0B0B0')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ right: 4 })
        }

        if (item.originalPrice && item.discountPercent && item.id !== 'love-choice') {
          Text('券后价')
            .fontSize(10)
            .fontColor('#999999')
            .margin({ right: 4 })
        }

        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#333333')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ right: 4 })
        }

        if (item.lowestLabel) {
          Text(item.lowestLabel)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#2BC48A')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
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
        Text(item.tags.slice(0, 3).join(' | '))
          .fontSize(11)
          .fontColor('#B0B0B0')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => this.goDetail(item.id))
  }

  @Builder
  SteamSaleFeaturedBuilder() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.background'))
          .width('100%')
          .height(180)
          .objectFit(ImageFit.Cover)

        Text('Steam促销')
          .fontSize(11)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#2BC48A')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius({ bottomRight: 8 })
      }
      .width('100%')
      .height(180)

      Row() {
        Row() {
          Text('▶')
            .fontSize(18)
            .fontColor(Color.White)
            .margin({ left: 2 })
        }
        .width(44)
        .height(44)
        .borderRadius(22)
        .backgroundColor('rgba(0,0,0,0.45)')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height(180)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r('app.media.background'))
          .width(38)
          .height(38)
          .borderRadius(6)
          .objectFit(ImageFit.Cover)
          .margin({ right: 10 })

        Column() {
          Text('荒野大镖客：救赎2')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('开放世界 | 剧情丰富 | 西部')
            .fontSize(11)
            .fontColor('#E0E0E0')
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Row() {
          Text('☖')
            .fontSize(11)
            .fontColor(Color.White)
            .margin({ right: 2 })
          Text('¥70')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('¥279')
            .fontSize(11)
            .fontColor('rgba(255,255,255,0.7)')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ left: 3, right: 3 })
          Text('-75%')
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#333333')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ right: 4 })
          Text('史低')
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#2BC48A')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius(3)
        }
      }
      .width('100%')
      .padding(10)
      .linearGradient({
        angle: 180,
        colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.85)', 1]]
      })
    }
    .width('100%')
    .height(180)
    .borderRadius(12)
    .clip(true)
    .margin({ bottom: 12 })
    .onClick(() => this.goDetail('rdr2'))
  }

  @Builder
  HotSellerCardBuilder(item: HotSellerItem) {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(item.coverImg)
          .width('100%')
          .height(76)
          .objectFit(ImageFit.Cover)

        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('rgba(0,0,0,0.6)')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius({ bottomLeft: 4 })
            .align(Alignment.TopEnd)
        }

        if (item.couponLabel) {
          Text(item.couponLabel)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#FFA033')
            .padding({ left: 5, right: 5, top: 2, bottom: 2 })
            .borderRadius({ topRight: 6 })
            .align(Alignment.BottomStart)
        }
      }
      .width('100%')
      .height(76)
      .borderRadius(8)
      .clip(true)

      Text(item.title)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: 6 })
        .width('100%')

      Row() {
        Text('¥')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
        Text(`${item.price}`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .margin({ right: 3 })
        if (item.originalPrice) {
          Text(`¥${item.originalPrice}`)
            .fontSize(10)
            .fontColor('#B0B0B0')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ right: 3 })
        }
        Text('券后价')
          .fontSize(9)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .width(135)
    .padding(8)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ right: 10 })
    .onClick(() => this.goDetail(item.id))
  }

  build() {
    Scroll() {
      Column() {
        // Banner 轮播
        Swiper() {
          ForEach(this.bannerSlides, (slide: BannerSlide) => {
            this.BannerSlideBuilder(slide)
          }, (slide: BannerSlide) => slide.title)
        }
        .aspectRatio(3.2)
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

        // 快捷导航
        Row({ space: 10 }) {
          ForEach(this.quickNavs, (item: QuickNav) => {
            this.QuickNavItemBuilder(item)
          }, (item: QuickNav) => item.title)
        }
        .width('100%')
        .margin({ top: 14 })

        // 快捷导航下方的小横线指示条
        Row()
          .width(24)
          .height(3)
          .backgroundColor('#E5E5E5')
          .borderRadius(1.5)
          .margin({ top: 10, bottom: 4 })

        // 栏目一：为你推荐
        this.SectionHeaderBuilder('为你推荐')

        Grid() {
          ForEach(this.forYouIds, (id: string) => {
            GridItem() {
              if (getGameById(id)) {
                this.GameCardBuilder(getGameById(id) as GameItem)
              }
            }
          }, (id: string) => id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .width('100%')

        // 栏目二：Steam促销
        this.SectionHeaderBuilder('Steam促销')

        // 大卡片（荒野大镖客2）
        this.SteamSaleFeaturedBuilder()

        // 6款促销游戏
        Grid() {
          ForEach(this.steamSaleIds, (id: string) => {
            GridItem() {
              if (getGameById(id)) {
                this.GameCardBuilder(getGameById(id) as GameItem)
              }
            }
          }, (id: string) => id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(12)
        .rowsGap(12)
        .width('100%')

        // 栏目三：黑盒热销
        this.SectionHeaderBuilder('黑盒热销')

        Scroll() {
          Row() {
            ForEach(this.hotSellers, (item: HotSellerItem) => {
              this.HotSellerCardBuilder(item)
            }, (item: HotSellerItem) => item.id)
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
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

