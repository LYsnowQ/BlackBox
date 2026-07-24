import { router } from '@kit.ArkUI';
import {
  HotBanner,
  HotChannel,
  HotNewsItem,
  HotRankItem,
  DealCell,
  hotBanners,
  hotChannels,
  hotRankList,
  getAllFeedNews,
} from '../../model/HotModel';
import {
  HotThemeColors,
  HotThemeMode,
  HOT_DEFAULT_THEME_MODE,
  getHotTheme,
  rankBadgeBackground,
} from './HotTheme';
import { HotRoutes } from '../../router/HotRoutes';

/**
 * 热点 Tab 主页（Hot HAR 业务组件，由 entry Index 挂载）
 * - 默认浅色（对照 Screen/Light 图1 全部 / 图2 热榜）
 * - 深色：HotTheme.HOT_DEFAULT_THEME_MODE = 'dark' 调试；后期由上层主题接管
 * - 全部：Banner + 新闻列表
 * - 热榜：排行列表
 * - 剑星 / Steam 等：待开发占位
 */
@Component
export struct Hot {
  @State channelIndex: number = 0;
  @State bannerIndex: number = 0;
  /** 调试用；默认取 HOT_DEFAULT_THEME_MODE（light） */
  @State themeMode: HotThemeMode = HOT_DEFAULT_THEME_MODE;

  private channels: HotChannel[] = hotChannels;
  private banners: HotBanner[] = hotBanners;
  private feedList: HotNewsItem[] = getAllFeedNews();
  private rankList: HotRankItem[] = hotRankList;

  private theme(): HotThemeColors {
    return getHotTheme(this.themeMode);
  }

  private currentChannel(): HotChannel {
    return this.channels[this.channelIndex];
  }

  private openNews(id: string): void {
    router.pushUrl({
      url: HotRoutes.NEWS_DETAIL,
      params: { id, themeMode: this.themeMode },
    });
  }

  // ---------- 顶部标题栏 ----------
  @Builder
  HeaderBuilder() {
    Row() {
      Text('热点')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme().title)

      Blank()

      Text('🔍')
        .fontSize(20)
        .fontColor(this.theme().icon)
        .margin({ right: 18 })
      // 点击消息图标切换 light/dark（仅调试；正式主题由上层接管后删除）
      Text('✉️')
        .fontSize(20)
        .fontColor(this.theme().icon)
        .onClick(() => {
          this.themeMode = this.themeMode === 'light' ? 'dark' : 'light';
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 10, bottom: 8 })
  }

  // ---------- 频道 Tab ----------
  @Builder
  ChannelTabBuilder(channel: HotChannel, index: number) {
    Column() {
      Text(channel.name)
        .fontSize(15)
        .fontWeight(this.channelIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.channelIndex === index ? this.theme().tabActive : this.theme().tabInactive)
      Row()
        .width(this.channelIndex === index ? 22 : 0)
        .height(3)
        .borderRadius(2)
        .backgroundColor(this.theme().tabIndicator)
        .margin({ top: 6 })
    }
    .padding({ right: 18 })
    .onClick(() => {
      this.channelIndex = index;
    })
  }

  @Builder
  ChannelBarBuilder() {
    Row() {
      Scroll() {
        Row() {
          ForEach(this.channels, (ch: HotChannel, idx: number) => {
            this.ChannelTabBuilder(ch, idx);
          }, (ch: HotChannel) => ch.id)
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      Text('☰')
        .fontSize(18)
        .fontColor(this.theme().tabInactive)
        .padding({ left: 8, right: 4 })
    }
    .width('100%')
    .padding({ left: 16, right: 12, bottom: 4 })
  }

  // ---------- Banner（顶部动态展示栏：优先真实图，图内已含文案） ----------
  @Builder
  BannerSlideBuilder(slide: HotBanner) {
    Stack({ alignContent: Alignment.BottomStart }) {
      if (slide.coverImg) {
        Image(slide.coverImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Column() {
          Text(slide.cta)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .opacity(0.95)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 120,
          colors: [[slide.gradientColors[0], 0], [slide.gradientColors[1], 1]],
        })

        Column() {
          Row() {
            Text(slide.cta)
              .fontSize(11)
              .fontColor(Color.White)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .backgroundColor('#1A8CFF')
              .borderRadius(4)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ bottom: 8 })

          Text(slide.title)
            .fontSize(13)
            .fontColor(Color.White)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Center)
            .width('100%')
            .padding({ left: 12, right: 12, bottom: 12 })
        }
        .width('100%')
        .linearGradient({
          angle: 180,
          colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.65)', 1]],
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  BannerBuilder() {
    Column() {
      Swiper() {
        ForEach(this.banners, (b: HotBanner) => {
          this.BannerSlideBuilder(b);
        }, (b: HotBanner) => b.id)
      }
      .autoPlay(true)
      .interval(4000)
      .indicator(true)
      .onChange((idx: number) => {
        this.bannerIndex = idx;
      })
      .borderRadius(10)
      .clip(true)
      .height(148)
      .width('100%')
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 4 })
  }

  // ---------- 折扣宫格缩略图 ----------
  @Builder
  DealThumbBuilder(item: HotNewsItem) {
    Column() {
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(item.dealCells ?? [], (cell: DealCell) => {
          Column() {
            Text(cell.discount)
              .fontSize(10)
              .fontWeight(FontWeight.Bold)
              .fontColor(cell.highlight ? this.theme().dealHighlightText : this.theme().dealCellText)
            Text(cell.price)
              .fontSize(9)
              .fontColor(cell.highlight ? this.theme().dealHighlightText : this.theme().dealCellText)
              .margin({ top: 1 })
          }
          .width('48%')
          .padding({ top: 3, bottom: 3 })
          .backgroundColor(cell.highlight ? this.theme().dealHighlightBg : this.theme().dealCellBg)
          .borderRadius(2)
          .margin({ right: '2%', bottom: 2 })
          .alignItems(HorizontalAlign.Center)
        }, (cell: DealCell) => `${item.id}-${cell.discount}-${cell.price}`)
      }
    }
    .width(108)
    .height(78)
    .padding(4)
    .backgroundColor(this.theme().dealPanelBg)
    .borderRadius(6)
    .justifyContent(FlexAlign.Center)
  }

  // ---------- 普通 / 视频缩略图 ----------
  @Builder
  ImageThumbBuilder(item: HotNewsItem) {
    Stack({ alignContent: Alignment.Center }) {
      if (item.coverImg) {
        Image(item.coverImg)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      } else {
        Column() {
          Text(item.thumbLabel ?? '')
            .fontSize(11)
            .fontWeight(FontWeight.Medium)
            .fontColor('rgba(255,255,255,0.9)')
            .maxLines(2)
            .textAlign(TextAlign.Center)
            .padding({ left: 6, right: 6 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 120,
          colors: [[item.thumbColors[0], 0], [item.thumbColors[1], 1]],
        })
      }

      if (item.thumbType === 'video') {
        Row() {
          Text('▶')
            .fontSize(14)
            .fontColor(Color.White)
        }
        .width(28)
        .height(28)
        .borderRadius(14)
        .backgroundColor('rgba(0,0,0,0.45)')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width(108)
    .height(78)
    .borderRadius(6)
    .clip(true)
  }

  @Builder
  NewsThumbBuilder(item: HotNewsItem) {
    if (item.thumbType === 'deal') {
      this.DealThumbBuilder(item);
    } else {
      this.ImageThumbBuilder(item);
    }
  }

  // ---------- 新闻列表项 ----------
  @Builder
  NewsItemBuilder(item: HotNewsItem) {
    Row() {
      Column() {
        Text(item.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.theme().textPrimary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)

        Row() {
          Text(`${item.timeLabel}·${item.tag}`)
            .fontSize(11)
            .fontColor(this.theme().textSecondary)
          Text(' ×')
            .fontSize(10)
            .fontColor(this.theme().textTertiary)
            .margin({ left: 2 })

          Blank()

          Text(`💬 ${item.commentCount}`)
            .fontSize(11)
            .fontColor(this.theme().textSecondary)
        }
        .width('100%')
        .margin({ top: 10 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ right: 12 })

      this.NewsThumbBuilder(item);
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .alignItems(VerticalAlign.Top)
    .onClick(() => this.openNews(item.id))
  }

  // ---------- 全部 Feed ----------
  @Builder
  AllFeedBuilder() {
    List() {
      ListItem() {
        this.BannerBuilder();
      }

      ForEach(this.feedList, (item: HotNewsItem) => {
        ListItem() {
          this.NewsItemBuilder(item);
        }
      }, (item: HotNewsItem) => item.id)

      ListItem() {
        Text('已经到底啦')
          .fontSize(12)
          .fontColor(this.theme().emptyText)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 12, bottom: 24 })
      }
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }

  // ---------- 热榜（浅色：1–4 彩色序号底） ----------
  @Builder
  RankItemBuilder(item: HotRankItem) {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Text(`${item.rank}`)
          .fontSize(item.rank <= 4 ? 13 : 16)
          .fontWeight(FontWeight.Bold)
          .fontColor(item.rank <= 4 ? this.theme().rankBadgeText : this.theme().rankDefault)
      }
      .width(item.rank <= 4 ? 22 : 28)
      .height(item.rank <= 4 ? 22 : 28)
      .borderRadius(4)
      .backgroundColor(rankBadgeBackground(this.theme(), item.rank))

      Column() {
        Text(item.title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.theme().textPrimary)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)

        Row() {
          Text(`${item.readLabel}·${item.tag}`)
            .fontSize(11)
            .fontColor(this.theme().textSecondary)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(`💬 ${item.commentCount}`)
            .fontSize(11)
            .fontColor(this.theme().textSecondary)
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10, right: 10 })

      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Text(item.thumbLabel ?? '')
            .fontSize(10)
            .fontColor('rgba(255,255,255,0.9)')
            .maxLines(2)
            .textAlign(TextAlign.Center)
            .padding(4)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 120,
          colors: [[item.thumbColors[0], 0], [item.thumbColors[1], 1]],
        })
      }
      .width(96)
      .height(64)
      .borderRadius(6)
      .clip(true)
    }
    .width('100%')
    .padding({ left: 12, right: 16, top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Top)
    .onClick(() => this.openNews(item.newsId ?? item.id))
  }

  @Builder
  RankListBuilder() {
    List() {
      ForEach(this.rankList, (item: HotRankItem) => {
        ListItem() {
          this.RankItemBuilder(item);
        }
      }, (item: HotRankItem) => item.id)

      ListItem() {
        Text('已经到底啦')
          .fontSize(12)
          .fontColor(this.theme().emptyText)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 12, bottom: 24 })
      }
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }

  // ---------- 游戏频道待开发 ----------
  @Builder
  GamePlaceholderBuilder() {
    Column() {
      Text('🚧')
        .fontSize(48)
        .margin({ bottom: 16 })
      Text(`${this.currentChannel().name}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme().textPrimary)
      Text('该频道内容暂未提供，敬请期待')
        .fontSize(14)
        .fontColor(this.theme().textSecondary)
        .margin({ top: 10 })
      Text('（待开发）')
        .fontSize(13)
        .fontColor(this.theme().textTertiary)
        .margin({ top: 6 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  ContentBuilder() {
    if (this.currentChannel().type === 'all') {
      this.AllFeedBuilder();
    } else if (this.currentChannel().type === 'rank') {
      this.RankListBuilder();
    } else {
      this.GamePlaceholderBuilder();
    }
  }

  build() {
    Column() {
      this.HeaderBuilder();
      this.ChannelBarBuilder();
      this.ContentBuilder();
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(this.theme().pageBg)
  }
}
