import { router } from '@kit.ArkUI';
import { GameItem, HeaderToolItem, getGameById } from '../../model/GameModel';

interface StatCell {
  value: string;
  label: string;
  extra?: string; // 排名等附加信息，如 "#496"
  isTrend?: boolean;
}

@Entry
@Component
struct GameDetail {
  @State game: GameItem | undefined = undefined;
  @State detailTabIndex: number = 0;

  aboutToAppear(): void {
    try {
      const params = router.getParams() as Record<string, Object>;
      const id = params ? (params['id'] as string) : '';
      this.game = getGameById(id);
    } catch (err) {
      this.game = getGameById('palworld');
    }
  }

  private getTabs(game: GameItem): string[] {
    if (game.customTabs && game.customTabs.length > 0) {
      return game.customTabs;
    }
    if (game.hasDatabaseTab) {
      return ['游戏', '社区', '数据库', '统计'];
    }
    return ['游戏', '社区', '统计'];
  }

  private buildStatCells(game: GameItem): StatCell[] {
    return [
      { value: game.onlineNow ?? '1086', label: '当前在线 ▶' },
      { value: `¥ ${game.lowestPrice ?? (game.price * 0.7).toFixed(1)}`, label: '史低价格 ▶' },
      { value: '', label: '15日在线趋势', isTrend: true },
      { value: game.goodRate ?? '94%', label: '全语言好评率 ▶' },
      { value: game.yesterdayPeak ?? '2483', label: '昨日峰值在线', extra: game.peakRank ?? '#496' },
      { value: game.monthAvgOnline ?? '2807', label: '本月平均在线', extra: game.monthAvgRank ?? '#476' },
      { value: game.blackBoxPlayers ?? '421.4万', label: '小黑盒玩家数', extra: game.playersRank ?? '#68' },
      { value: game.avgPlayTime ?? '17.9h', label: '平均游戏时间 ▶', extra: game.playTimeRank ?? '#12094' },
    ];
  }

  @Builder
  HeaderBuilder(game: GameItem | undefined) {
    Row() {
      Text('←')
        .fontSize(20)
        .fontColor(game?.headerTheme === 'white' || !game?.headerTheme ? '#1A1A1A' : Color.White)
        .onClick(() => {
          try {
            router.back();
          } catch (err) {
          }
        })

      Text(game ? game.title : '游戏详情')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor(game?.headerTheme === 'white' || !game?.headerTheme ? '#1A1A1A' : Color.White)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Text('⇧')
          .fontSize(18)
          .fontColor(game?.headerTheme === 'white' || !game?.headerTheme ? '#1A1A1A' : Color.White)
          .margin({ right: 16 })
        Text('🔍')
          .fontSize(18)
          .fontColor(game?.headerTheme === 'white' || !game?.headerTheme ? '#1A1A1A' : Color.White)
          .margin({ right: 16 })
        Text('✉️')
          .fontSize(18)
          .fontColor(game?.headerTheme === 'white' || !game?.headerTheme ? '#1A1A1A' : Color.White)
      }
    }
    .width('100%')
    .padding({ left: 12, right: 16, top: 8, bottom: 10 })
  }

  @Builder
  HeaderToolsBuilder(game: GameItem) {
    if (game.headerTools && game.headerTools.length > 0) {
      if (game.headerTheme === 'orange') {
        Row({ space: 8 }) {
          ForEach(game.headerTools, (tool: HeaderToolItem) => {
            if (tool.title === '🛠️') {
              Column() {
                Text('🛠️')
                  .fontSize(18)
              }
              .width(52)
              .height(46)
              .backgroundColor('rgba(255,255,255,0.45)')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
            } else {
              Column() {
                Row() {
                  Text(tool.title)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1A1A1A')
                }
                .width('100%')

                Row() {
                  Blank()
                  Text(tool.icon ?? '💼')
                    .fontSize(16)
                }
                .width('100%')
                .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .width(106)
              .height(46)
              .padding({ left: 10, right: 10, top: 6, bottom: 6 })
              .backgroundColor(Color.White)
              .borderRadius(8)
            }
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 4, bottom: 12 })
      } else if (game.headerTheme === 'teal') {
        Scroll() {
          Row({ space: 10 }) {
            ForEach(game.headerTools, (tool: HeaderToolItem) => {
              Column() {
                Text(tool.title)
                  .fontSize(13)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1A1A1A')
                if (tool.version) {
                  Text(tool.version)
                    .fontSize(9)
                    .fontColor('#2BA6A6')
                    .margin({ top: 3 })
                }
                if (tool.icon) {
                  Text(tool.icon)
                    .fontSize(20)
                    .margin({ top: 8 })
                }
              }
              .alignItems(HorizontalAlign.Start)
              .width(115)
              .height(76)
              .padding(10)
              .backgroundColor(Color.White)
              .borderRadius(10)
            })
          }
          .padding({ left: 16, right: 16 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .margin({ top: 4, bottom: 10 })
      }
    }
  }

  @Builder
  DetailTabBuilder(name: string, index: number, theme?: string) {
    Text(name)
      .fontSize(14)
      .fontWeight(this.detailTabIndex === index ? FontWeight.Bold : FontWeight.Normal)
      .fontColor(this.detailTabIndex === index ? Color.White : (theme === 'white' || !theme ? '#4A4A4A' : 'rgba(255,255,255,0.8)'))
      .backgroundColor(
        this.detailTabIndex === index
          ? (theme === 'orange' ? '#E59400' : (theme === 'teal' ? '#2BA6A6' : '#262626'))
          : Color.Transparent
      )
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .borderRadius(6)
      .margin({ right: 6 })
      .onClick(() => (this.detailTabIndex = index))
  }

  @Builder
  BannerBuilder(game: GameItem) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Stack() {
        if (game.coverImg) {
          Image(game.coverImg)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
        } else {
          Column() {
            Text(game.englishTitle.toUpperCase())
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .linearGradient({
            angle: 120,
            colors: [[game.gradientColors[0], 0], [game.gradientColors[1], 1]],
          })
          .align(Alignment.Center)
        }

        // 播放按钮
        Row() {
          Text('▶')
            .fontSize(20)
            .fontColor(Color.White)
            .margin({ left: 2 })
        }
        .width(52)
        .height(52)
        .borderRadius(26)
        .backgroundColor('rgba(0,0,0,0.4)')
        .justifyContent(FlexAlign.Center)
        .align(Alignment.Center)

        Text('1/11')
          .fontSize(11)
          .fontColor(Color.White)
          .backgroundColor('rgba(0,0,0,0.45)')
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .borderRadius(10)
          .margin({ top: 12, right: 14 })
          .align(Alignment.TopEnd)
      }
      .width('100%')
      .height(240)

      // 缩略图横条
      Row() {
        Scroll() {
          Row({ space: 5 }) {
            ForEach([0, 1, 2, 3, 4, 5, 6, 7], (idx: number) => {
              Column() {
                if (game.coverImg) {
                  Image(game.coverImg)
                    .width('100%')
                    .height('100%')
                    .objectFit(ImageFit.Cover)
                }
              }
              .width(54)
              .height(34)
              .borderRadius(4)
              .clip(true)
              .opacity(idx === 0 ? 1 : 0.55)
              .border({ width: idx === 0 ? 1.5 : 0, color: Color.White })
            })
          }
          .padding({ left: 10, right: 10 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
      }
      .width('100%')
      .padding({ top: 6, bottom: 6 })
      .backgroundColor('rgba(0,0,0,0.3)')
    }
    .width('100%')
    .height(240)
    .clip(true)
  }

  @Builder
  PriceBarBuilder(game: GameItem) {
    Row() {
      Row() {
        if (game.couponLabel) {
          Text(`${game.couponLabel} `)
            .fontSize(13)
            .fontColor(Color.White)
        }
        Text('¥')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text(`${game.price}`)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        if (game.originalPrice) {
          Row() {
            Text('☖')
              .fontSize(10)
              .fontColor('rgba(255,255,255,0.7)')
              .margin({ right: 2 })
            Text(`¥${game.originalPrice}`)
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.7)')
              .decoration({ type: TextDecorationType.LineThrough })
          }
          .margin({ left: 8 })
        }
      }
      .alignItems(VerticalAlign.Bottom)

      Blank()

      Text('全区价格/趋势 ▶')
        .fontSize(11)
        .fontColor(Color.White)
        .backgroundColor('rgba(255,255,255,0.15)')
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
        .borderRadius(12)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#262930')
  }

  @Builder
  ChipBuilder(text: string, icon?: string, bgColor?: string, textColor?: string) {
    Row() {
      if (icon) {
        Text(icon)
          .fontSize(10)
          .margin({ right: 3 })
      }
      Text(text)
        .fontSize(11)
        .fontColor(textColor ?? '#4A4A4A')
    }
    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
    .backgroundColor(bgColor ?? '#F2F2F5')
    .borderRadius(6)
    .margin({ right: 6, bottom: 6 })
  }

  @Builder
  StatCellBuilder(cell: StatCell) {
    Column() {
      if (cell.isTrend) {
        Row({ space: 2 }) {
          ForEach([4, 8, 6, 12, 9, 14, 11], (h: number) => {
            Row()
              .width(3)
              .height(h)
              .backgroundColor('#888888')
              .borderRadius(1)
          })
        }
        .alignItems(VerticalAlign.Bottom)
        .height(17)
      } else {
        Row() {
          Text(cell.value)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          if (cell.extra) {
            Text(cell.extra)
              .fontSize(9)
              .fontColor('#B0B0B0')
              .margin({ left: 2 })
          }
        }
      }
      Text(cell.label)
        .fontSize(10)
        .fontColor('#999999')
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)
    .padding({ top: 10, bottom: 10 })
  }

  build() {
    Column() {
      // 顶部 Header 区域 (根据游戏配置动态渲染主题色与快捷工具)
      Column() {
        this.HeaderBuilder(this.game)
        if (this.game) {
          this.HeaderToolsBuilder(this.game)
        }
      }
      .width('100%')
      .backgroundColor(
        this.game?.headerTheme === 'orange'
          ? '#E59400'
          : (this.game?.headerTheme === 'teal' ? '#1F7A7A' : Color.White)
      )

      // 页签栏 (游戏 / 社区 / 数据库 / 统计)
      if (this.game) {
        Row() {
          ForEach(this.getTabs(this.game), (name: string, index: number) => {
            this.DetailTabBuilder(name, index, this.game?.headerTheme)
          })
        }
        .width('100%')
        .padding({ left: 16, top: 8, bottom: 8 })
        .backgroundColor(Color.White)

        Scroll() {
          Column() {
            this.BannerBuilder(this.game)
            this.PriceBarBuilder(this.game)

            Column() {
              // 标题与评分
              Row() {
                Column() {
                  Text(this.game.title)
                    .fontSize(21)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text(this.game.englishTitle)
                    .fontSize(12)
                    .fontColor('#999999')
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                if (this.game.rating) {
                  Column() {
                    Row() {
                      Text('⚡').fontSize(10).fontColor(Color.White)
                      Text(`${this.game.rating}`)
                        .fontSize(18)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.White)
                        .margin({ left: 2 })
                    }
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(6)
                    .backgroundColor(this.game.ratingColor ?? '#FF7A00')

                    if (this.game.ratingCount) {
                      Text(this.game.ratingCount)
                        .fontSize(10)
                        .fontColor('#999999')
                        .margin({ top: 4 })
                    }
                  }
                  .alignItems(HorizontalAlign.End)
                }
              }
              .width('100%')
              .alignItems(VerticalAlign.Top)

              // 平台与属性 Chip 标签栏
              Flex({ wrap: FlexWrap.Wrap }) {
                this.ChipBuilder('♨', undefined, '#1E232A', '#FFFFFF')
                this.ChipBuilder('中文 | 单人 ▶')
                if (this.game.deckSupport === 'verified') {
                  this.ChipBuilder('Steam Deck ▶', '🟢')
                } else if (this.game.deckSupport === 'playable') {
                  this.ChipBuilder('Steam Deck ▶', '🟡')
                }
                ForEach(this.game.tags, (tag: string) => {
                  this.ChipBuilder(tag)
                })
                if (this.game.secondaryTags) {
                  ForEach(this.game.secondaryTags, (tag: string) => {
                    this.ChipBuilder(tag)
                  })
                }
              }
              .width('100%')
              .margin({ top: 12 })

              // 8大数据指标网格 (2行4列)
              Grid() {
                ForEach(this.buildStatCells(this.game), (cell: StatCell) => {
                  GridItem() {
                    this.StatCellBuilder(cell)
                  }
                })
              }
              .columnsTemplate('1fr 1fr 1fr 1fr')
              .margin({ top: 16 })
              .width('100%')

              Row() {
                Text('查看玩家统计 ▶')
                  .fontSize(12)
                  .fontColor('#888888')
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 8, bottom: 8 })

              Divider().color('#F0F0F2').strokeWidth(6).margin({ top: 8, bottom: 12 })

              // 游戏简介板块
              Row() {
                Text('游戏简介')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')

                if (this.game.hasDeveloperIn) {
                  Text('开发者入驻')
                    .fontSize(10)
                    .fontColor('#2BA6A6')
                    .backgroundColor('#E3F4E9')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius(4)
                    .margin({ left: 8 })
                }
                Blank()
                Text('全部 >')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')

              if (this.game.awardLabel) {
                Row() {
                  Text('🏆 ')
                    .fontSize(14)
                  Text(this.game.awardLabel)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#7A5200')
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#FFFBF0')
                .borderRadius(8)
                .margin({ top: 10 })
              }

              if (this.game.intro) {
                Text(this.game.intro)
                  .fontSize(13)
                  .fontColor('#4A4A4A')
                  .lineHeight(20)
                  .margin({ top: 10 })
                  .width('100%')
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16, bottom: 20 })
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .width('100%')

        // 底部悬浮购买栏
        Row() {
          Column() {
            Text('♡')
              .fontSize(18)
              .fontColor('#999999')
            Text(this.game.wishlistCount ?? '32w')
              .fontSize(10)
              .fontColor('#999999')
          }
          .alignItems(HorizontalAlign.Center)
          .margin({ right: 14 })

          Column() {
            Text('4天')
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Text('距折扣结束')
              .fontSize(10)
              .fontColor('#B0B0B0')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          Stack({ alignContent: Alignment.TopEnd }) {
            Row() {
              if (this.game.couponLabel) {
                Text(`${this.game.couponLabel} `)
                  .fontSize(13)
                  .fontColor(Color.White)
              }
              Text(`¥ ${this.game.price}`)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              if (this.game.id === 'love-choice') {
                Text(' 购买')
                  .fontSize(14)
                  .fontColor(Color.White)
              }
            }
            .width(180)
            .height(44)
            .borderRadius(22)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#333333')

            if (this.game.discountPercent) {
              Text(`-${this.game.discountPercent}%`)
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('#E23B3B')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius({ topRight: 10, bottomLeft: 10 })
            }
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 10, bottom: 10 })
        .backgroundColor(Color.White)
        .border({ width: { top: 1 }, color: '#F0F0F0' })
      } else {
        Row() {
          Text('未找到游戏信息')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F7')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}


