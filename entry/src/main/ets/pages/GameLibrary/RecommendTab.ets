import { GameItem, gameList, getGameById } from '../../model/GameLibrary/GameLibraryModel';

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
interface RecommendPageItem {
  id: string;
  title: string;
  price: number;
  originalPrice?: number;
  discountPercent?: number;
  couponLabel?: string;
  lowestLabel?: string;
  remainDays?: string;
  tags: string[];
  coverImg?: ResourceStr;
  gradientColors?: [string, string];
}

@Component
export struct RecommendTab {
  @State bannerIndex: number = 0;
  @State isForYouPageOpen: boolean = false;
  @State activeNavPage: string = ''; // '' | '黑盒商城' | '喜加一' | '赛事中心' | '黑盒语音'
  @State storeSegmentIndex: number = 0; // 0: 游戏, 1: 游戏道具, 2: 游戏周边
  @State storeSortIndex: number = 0; // 0: 销量, 1: 最高折扣, 2: 价格升序, 3: 价格降序, 4: 最新上架

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
    'miside',
  ];

  private forYouPageGames: RecommendPageItem[] = [
    {
      id: 'paper-bride',
      title: '纸嫁衣',
      price: 17,
      couponLabel: '领券减1',
      tags: ['大家都在玩', '解谜'],
      coverImg: $r('app.media.paper_bride'),
    },
    {
      id: 'death-and-taxes',
      title: '死亡与税赋',
      price: 7,
      originalPrice: 52,
      discountPercent: 87,
      tags: ['大家都在玩', '独立', '模拟'],
      coverImg: $r('app.media.death_taxes'),
    },
    {
      id: 'song-of-koto',
      title: '莺之歌',
      price: 5,
      originalPrice: 22,
      discountPercent: 80,
      lowestLabel: '超史低',
      tags: ['大家都在玩', '视觉小说'],
      coverImg: $r('app.media.song_koto'),
    },
    {
      id: 'pico-park-2',
      title: 'PICO PARK 2',
      price: 40,
      tags: ['大家都在玩', '动作', '休闲'],
      coverImg: $r('app.media.pico_park'),
    },
    {
      id: 'p5r',
      title: '女神异闻录5皇家版',
      price: 73,
      originalPrice: 268,
      discountPercent: 70,
      couponLabel: '领券9折',
      tags: ['大家都在玩'],
      coverImg: $r('app.media.p5r'),
    },
    {
      id: 'hungry-starving',
      title: '饿殍：明末千里行',
      price: 21,
      originalPrice: 37,
      discountPercent: 37,
      couponLabel: '领券9折',
      remainDays: '剩余 6 天',
      tags: ['大家都在玩', '剧情', '国产'],
      coverImg: $r('app.media.hungry_starving'),
    },
    {
      id: 'they-love-me-too-much',
      title: '糟糕！他们太爱我了怎么办？',
      price: 18,
      tags: ['大家都在玩', '角色扮演', '策略'],
      coverImg: $r('app.media.they_love_me'),
    },
    {
      id: 'rayman-rabbids',
      title: '雷曼4：疯狂兔子',
      price: 24,
      couponLabel: '领券95折',
      tags: ['大家都在玩'],
      coverImg: $r('app.media.rayman'),
    },
    {
      id: 'old-day-nun',
      title: '旧日女修',
      price: 23,
      originalPrice: 38,
      discountPercent: 35,
      lowestLabel: '新史低',
      couponLabel: '领券9折',
      remainDays: '剩余 6 天',
      tags: ['修仙', '角色扮演'],
      coverImg: $r('app.media.old_day_nun'),
    },
    {
      id: 'cats-together',
      title: '双喵成行',
      price: 24,
      originalPrice: 32,
      discountPercent: 20,
      couponLabel: '领券9折',
      tags: ['大家都在玩', '双人', '合作'],
      coverImg: $r('app.media.cats_together'),
    },
    {
      id: 'paper-house',
      title: '纸房子',
      price: 12,
      tags: ['解谜', '独立'],
      coverImg: $r('app.media.paper_house'),
    },
    {
      id: 'palworld',
      title: 'Palworld / 幻兽帕鲁',
      price: 72,
      originalPrice: 108,
      discountPercent: 30,
      couponLabel: '领券95折',
      lowestLabel: '新史低',
      tags: ['大家都在玩', '开放世界', '抓宠'],
      coverImg: $r('app.media.Palworld'),
    },
    {
      id: 'black-myth-wukong',
      title: '黑神话：悟空',
      price: 268,
      originalPrice: 298,
      discountPercent: 10,
      couponLabel: '领券9折',
      lowestLabel: '史低',
      tags: ['大家都在玩', '国风神作', '动作'],
      coverImg: $r('app.media.wukong'),
    },
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
      id: 'miside',
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
      coverImg: $r('app.media.pubg_gcoin'),
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
      this.getUIContext().getRouter().pushUrl({
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
    .onClick(() => {
      this.activeNavPage = item.title;
    })
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
        .onClick(() => {
          if (title === '为你推荐') {
            this.isForYouPageOpen = true;
          }
        })
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
        Image($r('app.media.rdr2'))
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
        Image($r('app.media.rdr2'))
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

  @Builder
  ForYouRowBuilder(item: RecommendPageItem) {
    Row() {
      // 左侧封面图片 (含折角折扣角标)
      Stack({ alignContent: Alignment.TopEnd }) {
        if (item.coverImg) {
          Image(item.coverImg)
            .width(124)
            .height(72)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
        } else {
          Column() {
            Text(item.title)
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .padding(4)
          }
          .width(124)
          .height(72)
          .borderRadius(8)
          .justifyContent(FlexAlign.Center)
          .linearGradient({
            angle: 120,
            colors: item.gradientColors ? [[item.gradientColors[0], 0], [item.gradientColors[1], 1]] : [['#3A3A3A', 0], ['#171717', 1]]
          })
        }

        if (item.discountPercent) {
          Text(`-${item.discountPercent}%`)
            .fontSize(9)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('rgba(0,0,0,0.65)')
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .borderRadius({ topRight: 8, bottomLeft: 4 })
        }
      }
      .width(124)
      .height(72)

      // 右侧核心信息
      Column() {
        Text(item.title)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 价格与折扣/立减/史低标签
        Row() {
          Text('☖')
            .fontSize(10)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ right: 2 })
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
              .fontSize(10)
              .fontColor('#B0B0B0')
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ right: 4 })
          } else {
            Text('券后价')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ right: 4 })
          }

          if (item.couponLabel) {
            Text(item.couponLabel)
              .fontSize(9)
              .fontColor('#E25C00')
              .border({ width: 1, color: '#FFB280' })
              .backgroundColor('#FFF5ED')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 4 })
          }

          if (item.lowestLabel) {
            Text(item.lowestLabel)
              .fontSize(9)
              .fontColor(Color.White)
              .backgroundColor(item.lowestLabel === '超史低' ? '#00B0FF' : '#2BC48A')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 4 })
          }

          if (item.remainDays) {
            Blank()
            Text(item.remainDays)
              .fontSize(9)
              .fontColor('#888888')
          }
        }
        .width('100%')
        .margin({ top: 6 })

        // 分类 Chip 标签
        Row({ space: 4 }) {
          ForEach(item.tags, (tag: string) => {
            Text(tag)
              .fontSize(10)
              .fontColor('#666666')
              .backgroundColor('#F5F5F7')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
          })
        }
        .width('100%')
        .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .border({ width: { bottom: 1 }, color: '#F7F7F9' })
    .onClick(() => {
      this.goDetail(item.id);
    })
  }

  @Builder
  ForYouPageOverlayBuilder() {
    Column() {
      // 截图同款 Header: ← 为你推荐
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.isForYouPageOpen = false))

        Text('为你推荐')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      // 截图同款垂直游戏列表
      Scroll() {
        Column() {
          ForEach(this.forYouPageGames, (item: RecommendPageItem) => {
            this.ForYouRowBuilder(item)
          }, (item: RecommendPageItem) => item.id)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 4, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
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

      if (this.isForYouPageOpen) {
        this.ForYouPageOverlayBuilder()
      }

      if (this.activeNavPage === '黑盒商城') {
        this.StorePageOverlayBuilder()
      } else if (this.activeNavPage === '喜加一') {
        this.FreeGamePageOverlayBuilder()
      } else if (this.activeNavPage === '赛事中心') {
        this.TournamentPageOverlayBuilder()
      } else if (this.activeNavPage === '黑盒语音') {
        this.VoicePageOverlayBuilder()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  StorePageOverlayBuilder() {
    Column() {
      // 1. 顶部 Header 导航栏 (截图: < H 黑盒商城 官方服务... 🔍 🎧)
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 8 })
          .onClick(() => (this.activeNavPage = ''))

        Row() {
          Text('H')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('#1A1A1A')
            .width(24)
            .height(24)
            .borderRadius(6)
            .textAlign(TextAlign.Center)
        }
        .margin({ right: 8 })

        Column() {
          Text('黑盒商城')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('官方服务 · 流程便捷 · 价格实惠')
            .fontSize(10)
            .fontColor('#999999')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text('🔍')
          .fontSize(18)
          .margin({ right: 14 })
        Text('🎧')
          .fontSize(18)
          .margin({ right: 14 })
      }
      .width('100%')
      .height(52)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F5F5F7' })

      Scroll() {
        Column() {
          // 2. 青铜会员 VIP 专属卡片 (截图: 渐变色卡片 + 4项特权)
          Column() {
            Row() {
              Column() {
                Text('青铜会员')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#5D3012')
                Text('累计消费 1 元，即可享受丰厚会员特权')
                  .fontSize(11)
                  .fontColor('#8C522B')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('H')
                .fontSize(28)
                .fontWeight(FontWeight.Bolder)
                .fontColor('#E09E74')
            }
            .width('100%')

            Row() {
              Column() {
                Text('⚡')
                  .fontSize(16)
                Text('20%抵扣')
                  .fontSize(10)
                  .fontColor('#7A4523')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)

              Column() {
                Text('🪙')
                  .fontSize(16)
                Text('返还H币')
                  .fontSize(10)
                  .fontColor('#7A4523')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)

              Column() {
                Text('🧧')
                  .fontSize(16)
                Text('20元券包')
                  .fontSize(10)
                  .fontColor('#7A4523')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)

              Column() {
                Text('🚀')
                  .fontSize(16)
                Text('3天加速器')
                  .fontSize(10)
                  .fontColor('#7A4523')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)

              Text('查看更多 >')
                .fontSize(11)
                .fontColor('#8C522B')
            }
            .width('100%')
            .margin({ top: 14 })
          }
          .width('100%')
          .padding(14)
          .borderRadius(12)
          .linearGradient({
            angle: 135,
            colors: [['#FFEDE3', 0], ['#FFD6C0', 1]]
          })
          .margin({ top: 12, bottom: 14 })

          // 3. 5 Icon 金刚位 (截图: 我的钱包 / 我的订单 / 领券中心 / 购物车 / 游戏厂商)
          Row() {
            Column() {
              Text('👛')
                .fontSize(22)
              Text('我的钱包')
                .fontSize(11)
                .fontColor('#333333')
                .margin({ top: 6 })
            }
            .layoutWeight(1)

            Column() {
              Text('📋')
                .fontSize(22)
              Text('我的订单')
                .fontSize(11)
                .fontColor('#333333')
                .margin({ top: 6 })
            }
            .layoutWeight(1)

            Stack({ alignContent: Alignment.TopEnd }) {
              Column() {
                Text('🧧')
                  .fontSize(22)
                Text('领券中心')
                  .fontSize(11)
                  .fontColor('#333333')
                  .margin({ top: 6 })
              }
              Text('热')
                .fontSize(8)
                .fontColor(Color.White)
                .backgroundColor('#FF3B30')
                .padding({ left: 3, right: 3, top: 1, bottom: 1 })
                .borderRadius(6)
            }
            .layoutWeight(1)

            Column() {
              Text('🛒')
                .fontSize(22)
              Text('购物车')
                .fontSize(11)
                .fontColor('#333333')
                .margin({ top: 6 })
            }
            .layoutWeight(1)

            Column() {
              Text('🎮')
                .fontSize(22)
              Text('游戏厂商')
                .fontSize(11)
                .fontColor('#333333')
                .margin({ top: 6 })
            }
            .layoutWeight(1)
          }
          .width('100%')
          .margin({ bottom: 16 })

          // 4. 3大品类切换 Tab (截图: 游戏 | 游戏道具 | 游戏周边)
          Row() {
            Row() {
              Text('游戏')
                .fontSize(13)
                .fontWeight(this.storeSegmentIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.storeSegmentIndex === 0 ? '#1A1A1A' : '#666666')
                .backgroundColor(this.storeSegmentIndex === 0 ? Color.White : 'transparent')
                .padding({ left: 24, right: 24, top: 8, bottom: 8 })
                .borderRadius(8)
                .onClick(() => (this.storeSegmentIndex = 0))

              Text('游戏道具')
                .fontSize(13)
                .fontWeight(this.storeSegmentIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.storeSegmentIndex === 1 ? '#1A1A1A' : '#666666')
                .backgroundColor(this.storeSegmentIndex === 1 ? Color.White : 'transparent')
                .padding({ left: 24, right: 24, top: 8, bottom: 8 })
                .borderRadius(8)
                .onClick(() => (this.storeSegmentIndex = 1))

              Text('游戏周边')
                .fontSize(13)
                .fontWeight(this.storeSegmentIndex === 2 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.storeSegmentIndex === 2 ? '#1A1A1A' : '#666666')
                .backgroundColor(this.storeSegmentIndex === 2 ? Color.White : 'transparent')
                .padding({ left: 24, right: 24, top: 8, bottom: 8 })
                .borderRadius(8)
                .onClick(() => (this.storeSegmentIndex = 2))
            }
            .width('100%')
            .padding(3)
            .backgroundColor('#F2F3F5')
            .borderRadius(10)
          }
          .width('100%')
          .margin({ bottom: 12 })

          // 5. 排序筛选横栏 (截图: 销量 | 最高折扣 | 价格升序 | 价格降序 | 最新上架)
          Row({ space: 16 }) {
            ForEach(['销量', '最高折扣', '价格升序', '价格降序', '最新上架'], (tab: string, idx: number) => {
              Column() {
                Text(tab)
                  .fontSize(13)
                  .fontWeight(this.storeSortIndex === idx ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.storeSortIndex === idx ? '#1A1A1A' : '#888888')
                Row()
                  .width(this.storeSortIndex === idx ? 16 : 0)
                  .height(3)
                  .borderRadius(1.5)
                  .backgroundColor('#1A1A1A')
                  .margin({ top: 4 })
              }
              .onClick(() => (this.storeSortIndex = idx))
            })
          }
          .width('100%')
          .margin({ bottom: 14 })

          // 6. 商品双列瀑布流 (截图: 幻兽帕鲁 / 风暴怕死队 / 绝地求生G-coin饰品 / 碧蓝幻想Relink / 链在一起 / 生化4)
          Grid() {
            // 商品 1: 幻兽帕鲁
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.Palworld'))
                    .width('100%')
                    .height(105)
                    .borderRadius({ topLeft: 10, topRight: 10 })
                    .objectFit(ImageFit.Cover)
                  Text('领券95折')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#FFA033')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius({ topRight: 8, bottomRight: 8 })
                }

                Text('Palworld / 幻兽帕鲁-标准版')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8, left: 8, right: 8 })

                Row() {
                  Text('¥ 103')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('券后价')
                    .fontSize(10)
                    .fontColor('#999999')
                    .margin({ left: 4 })
                }
                .margin({ top: 6, left: 8, bottom: 10 })
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .onClick(() => this.goDetail('palworld'))
            }

            // 商品 2: 风暴怕死队
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.background'))
                    .width('100%')
                    .height(105)
                    .borderRadius({ topLeft: 10, topRight: 10 })
                    .objectFit(ImageFit.Cover)
                  Text('领券92折')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#FFA033')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius({ topRight: 8, bottomRight: 8 })
                }

                Text('风暴怕死队-标准版')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8, left: 8, right: 8 })

                Row() {
                  Text('¥ 57')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('¥68')
                    .fontSize(10)
                    .fontColor('#B0B0B0')
                    .decoration({ type: TextDecorationType.LineThrough })
                    .margin({ left: 4 })
                  Text('券后价')
                    .fontSize(9)
                    .fontColor('#999999')
                    .margin({ left: 3 })
                  Text('-10%')
                    .fontSize(8)
                    .fontColor(Color.White)
                    .backgroundColor('#333333')
                    .padding({ left: 3, right: 3, top: 1, bottom: 1 })
                    .borderRadius(2)
                    .margin({ left: 4 })
                }
                .margin({ top: 6, left: 8, bottom: 10 })
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .onClick(() => this.goDetail('palworld'))
            }

            // 商品 3: 绝地求生 G-coin 道具饰品 (截图同款)
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.pubg_gcoin'))
                    .width('100%')
                    .height(130)
                    .borderRadius({ topLeft: 10, topRight: 10 })
                    .objectFit(ImageFit.Contain)
                    .backgroundColor('#FAFAFA')
                  Text('领券93折')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#FFA033')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius({ topRight: 8, bottomRight: 8 })
                }

                Text('绝地求生 10000+1200 G-coin')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8, left: 8, right: 8 })

                Row({ space: 4 }) {
                  Text('今日特卖')
                    .fontSize(9)
                    .fontColor('#888888')
                    .border({ width: 1, color: '#E0E0E0' })
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(3)
                  Text('游戏饰品')
                    .fontSize(9)
                    .fontColor('#888888')
                    .border({ width: 1, color: '#E0E0E0' })
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(3)
                }
                .margin({ top: 6, left: 8 })

                Row() {
                  Text('¥ 631')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('券后价')
                    .fontSize(10)
                    .fontColor('#999999')
                    .margin({ left: 4 })
                }
                .margin({ top: 6, left: 8, bottom: 10 })
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .onClick(() => this.goDetail('rise-of-tomb-raider'))
            }

            // 商品 4: 碧蓝幻想 Relink
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.party'))
                    .width('100%')
                    .height(105)
                    .borderRadius({ topLeft: 10, topRight: 10 })
                    .objectFit(ImageFit.Cover)
                  Text('领券9折')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#FFA033')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius({ topRight: 8, bottomRight: 8 })
                }

                Text('碧蓝幻想 Relink-无尽黄昏完整（普通版）')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8, left: 8, right: 8 })

                Row() {
                  Text('¥ 233')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('券后价')
                    .fontSize(10)
                    .fontColor('#999999')
                    .margin({ left: 4 })
                }
                .margin({ top: 6, left: 8, bottom: 10 })
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .onClick(() => this.goDetail('party-animals'))
            }

            // 商品 5: 链在一起
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.chain'))
                    .width('100%')
                    .height(105)
                    .borderRadius({ topLeft: 10, topRight: 10 })
                    .objectFit(ImageFit.Cover)
                  Text('领券9折')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#FFA033')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius({ topRight: 8, bottomRight: 8 })
                }

                Text('链在一起-标准版')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8, left: 8, right: 8 })

                Row() {
                  Text('¥ 20')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('券后价')
                    .fontSize(10)
                    .fontColor('#999999')
                    .margin({ left: 4 })
                }
                .margin({ top: 6, left: 8, bottom: 10 })
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .onClick(() => this.goDetail('chained-together'))
            }

            // 商品 6: 生化危机 4
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image($r('app.media.resident'))
                    .width('100%')
                    .height(105)
                    .borderRadius({ topLeft: 10, topRight: 10 })
                    .objectFit(ImageFit.Cover)
                  Text('领券9折')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#FFA033')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius({ topRight: 8, bottomRight: 8 })
                }

                Text('RESIDENT EVIL 4 生化4重制版')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8, left: 8, right: 8 })

                Row() {
                  Text('¥ 148')
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('券后价')
                    .fontSize(10)
                    .fontColor('#999999')
                    .margin({ left: 4 })
                }
                .margin({ top: 6, left: 8, bottom: 10 })
              }
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
              .borderRadius(10)
              .onClick(() => this.goDetail('resident-evil-4'))
            }
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .width('100%')
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 4, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }

  @Builder
  FreeGamePageOverlayBuilder() {
    Column() {
      // Header
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.activeNavPage = ''))

        Text('喜加一 · 限时福利发放')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      Scroll() {
        Column() {
          // 本期焦点免费大卡片
          Stack({ alignContent: Alignment.Bottom }) {
            Image($r('app.media.rise'))
              .width('100%')
              .height(180)
              .objectFit(ImageFit.Cover)
              .borderRadius(12)

            Row() {
              Column() {
                Text('🎁 本期 Epic/Steam 联合限免大作')
                  .fontSize(12)
                  .fontColor('#FFD700')
                  .fontWeight(FontWeight.Bold)
                Text('《古墓丽影：崛起》20周年纪念版')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('免费领取')
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .backgroundColor('#FF3B30')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .borderRadius(16)
                .onClick(() => this.goDetail('rise-of-tomb-raider'))
            }
            .width('100%')
            .padding(14)
            .linearGradient({
              angle: 180,
              colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.85)', 1]]
            })
            .borderRadius({ bottomLeft: 12, bottomRight: 12 })
          }
          .width('100%')
          .margin({ top: 12, bottom: 16 })

          Text('🎮 正在派送中 (3款可领)')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ bottom: 12 })
            .width('100%')

          // 免费列表 Item 1
          Row() {
            Image($r('app.media.rise'))
              .width(90)
              .height(56)
              .borderRadius(6)
              .objectFit(ImageFit.Cover)

            Column() {
              Text('古墓丽影：崛起')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Row() {
                Text('¥ 0')
                  .fontSize(15)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF3B30')
                Text('¥147')
                  .fontSize(11)
                  .fontColor('#999999')
                  .decoration({ type: TextDecorationType.LineThrough })
                  .margin({ left: 4 })
              }
              .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 10 })
            .layoutWeight(1)

            Button('一键领取')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#2BC48A')
              .borderRadius(14)
              .height(30)
              .onClick(() => this.goDetail('rise-of-tomb-raider'))
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ bottom: 10 })

          // 免费列表 Item 2
          Row() {
            Column() {
              Text('死亡与税赋 独家Key派发')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('小黑盒社区福利抽奖 1000 份发放')
                .fontSize(11)
                .fontColor('#888888')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Button('参与抽奖')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor('#1A1A1A')
              .backgroundColor('#F0F0F2')
              .borderRadius(14)
              .height(30)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')
        .padding({ left: 14, right: 14, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }

  @Builder
  TournamentPageOverlayBuilder() {
    Column() {
      // Header
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor(Color.White)
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.activeNavPage = ''))

        Text('赛事中心 · E-Sports Hub')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor('#121314')

      Scroll() {
        Column() {
          // 直播大屏卡片
          Column() {
            Row() {
              Text('🔴 LIVE 直播中')
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .backgroundColor('#FF3B30')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(4)
              Blank()
              Text('🔥 158.4万人 在看')
                .fontSize(11)
                .fontColor('#FFD700')
            }
            .width('100%')

            Text('CS2 2026 哥本哈根 Major 决赛')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ top: 10 })

            Row() {
              Text('小黑盒 Gaming')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text(' 14 : 12 ')
                .fontSize(20)
                .fontWeight(FontWeight.Bolder)
                .fontColor('#FF7A00')
                .margin({ left: 12, right: 12 })
              Text('欧皇 Team')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
            }
            .margin({ top: 14 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1E2022')
          .borderRadius(12)
          .margin({ top: 12, bottom: 16 })

          Text('🏆 热门赛事赛程预告')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ bottom: 12 })
            .width('100%')

          Row() {
            Column() {
              Text('街头霸王6 · 盒友杯淘汰赛')
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('明日 20:00 · BO5 抢三决赛')
                .fontSize(10)
                .fontColor('#999999')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text('竞猜押注 >')
              .fontSize(12)
              .fontColor('#FF7A00')
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#1E2022')
          .borderRadius(10)
        }
        .width('100%')
        .padding({ left: 14, right: 14, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#121314')
  }

  @Builder
  VoicePageOverlayBuilder() {
    Column() {
      // Header
      Row() {
        Text('‹')
          .fontSize(32)
          .fontColor('#1A1A1A')
          .padding({ left: 14, right: 14 })
          .onClick(() => (this.activeNavPage = ''))

        Text('黑盒语音 · AI 免费超清降噪')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 44 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      Scroll() {
        Column() {
          // AI 降噪状态面板
          Row() {
            Text('🎙️')
              .fontSize(28)
            Column() {
              Text('黑盒 AI 3.0 神经降噪已开启')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('采样率 48kHz · 延迟 <15ms · 智能过滤键盘麦噪')
                .fontSize(10)
                .fontColor('#2BC48A')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 10 })
            .layoutWeight(1)
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#E8F8F1')
          .borderRadius(12)
          .margin({ top: 12, bottom: 16 })

          Text('🔊 热门开黑组队房间')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .margin({ bottom: 12 })
            .width('100%')

          // 房间 1
          Row() {
            Column() {
              Text('【幻兽帕鲁】雪山据点四金战队缺1人')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('在线 3/4 人 · 自由麦 · 氛围融洽')
                .fontSize(11)
                .fontColor('#888888')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Button('一键进房')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor(Color.White)
              .backgroundColor('#2BC48A')
              .borderRadius(14)
              .height(30)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .margin({ bottom: 10 })

          // 房间 2
          Row() {
            Column() {
              Text('【链在一起】高难跳跃 求心态好大佬')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('在线 1/2 人 · 按键说话')
                .fontSize(11)
                .fontColor('#888888')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Button('一键进房')
              .type(ButtonType.Normal)
              .fontSize(12)
              .fontColor('#1A1A1A')
              .backgroundColor('#F0F0F2')
              .borderRadius(14)
              .height(30)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')
        .padding({ left: 14, right: 14, bottom: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#F8F9FA')
  }
}

