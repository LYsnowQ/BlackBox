import { router } from '@kit.ArkUI';
import { GameItem, getGameById } from '../../model/GameModel';

interface QuickEntry {
  title: string;
  icon: string;
  version: string;
}

interface StatCell {
  value: string;
  label: string;
  extra?: string; // 排名等附加信息，如 "#2"
}

@Entry
@Component
struct GameDetail {
  @State game: GameItem | undefined = undefined;
  @State detailTabIndex: number = 0;

  private quickEntries: QuickEntry[] = [
    { title: '实时地图', icon: '🗺️', version: '1.0正式版' },
    { title: '我的帕鲁', icon: '🧳', version: '1.0正式版' },
    { title: '帕鲁图鉴', icon: '📘', version: '1.0正式版' },
    { title: '孵蛋计算器', icon: '📊', version: '1.0正式版' },
    { title: '物品数据库', icon: '🗃️', version: '1.0正式版' },
  ];

  private detailTabs: string[] = ['游戏', '社区', '战绩', '图鉴', '统计'];

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    this.game = getGameById(id);
  }

  private buildStatCells(game: GameItem): StatCell[] {
    const cells: StatCell[] = [];
    if (game.onlineNow) {
      cells.push({ value: game.onlineNow, label: '当前在线' });
    }
    if (game.originalPrice) {
      cells.push({ value: `¥${game.price}`, label: '史低价格' });
    }
    cells.push({ value: '', label: '15日在线趋势' });
    if (game.goodRate) {
      cells.push({ value: game.goodRate, label: '全语言好评率' });
    }
    if (game.yesterdayPeak) {
      cells.push({ value: game.yesterdayPeak, label: '昨日峰值在线', extra: '#2' });
    }
    if (game.globalSalesRank) {
      cells.push({ value: game.globalSalesRank, label: '全球销量排行' });
    }
    if (game.blackBoxPlayers) {
      cells.push({ value: game.blackBoxPlayers, label: '小黑盒玩家数', extra: '#34' });
    }
    if (game.avgPlayTime) {
      cells.push({ value: game.avgPlayTime, label: '平均游戏时间', extra: '#2455' });
    }
    return cells;
  }

  @Builder
  HeaderBuilder(title: string) {
    Row() {
      Text('←')
        .fontSize(20)
        .fontColor(Color.White)
        .onClick(() => router.back())

      Text(title)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Text('⇧').fontSize(18).fontColor(Color.White).margin({ right: 16 })
        Text('🔍').fontSize(18).fontColor(Color.White).margin({ right: 16 })
        Text('✉️').fontSize(18).fontColor(Color.White)
      }
    }
    .width('100%')
    .padding({ left: 12, right: 16, top: 8, bottom: 12 })
  }

  @Builder
  QuickEntryBuilder(entry: QuickEntry) {
    Column() {
      Text(entry.title)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
      Row() {
        Text(entry.version)
          .fontSize(9)
          .fontColor('#2BA6A6')
      }
      .margin({ top: 4 })
      Text(entry.icon)
        .fontSize(22)
        .margin({ top: 10 })
    }
    .alignItems(HorizontalAlign.Start)
    .width(118)
    .height(78)
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ right: 10 })
  }

  @Builder
  DetailTabBuilder(name: string, index: number) {
    Text(name)
      .fontSize(14)
      .fontWeight(this.detailTabIndex === index ? FontWeight.Bold : FontWeight.Normal)
      .fontColor(this.detailTabIndex === index ? Color.White : '#4A4A4A')
      .backgroundColor(this.detailTabIndex === index ? '#2BA6A6' : Color.Transparent)
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .borderRadius(18)
      .onClick(() => (this.detailTabIndex = index))
  }

  @Builder
  BannerBuilder(game: GameItem) {
    Stack() {
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

      // 播放按钮
      Row() {
        Text('▶')
          .fontSize(20)
          .fontColor(Color.White)
      }
      .width(56)
      .height(56)
      .borderRadius(28)
      .backgroundColor('rgba(0,0,0,0.35)')
      .justifyContent(FlexAlign.Center)
      .align(Alignment.Center)

      Text('1/21')
        .fontSize(11)
        .fontColor(Color.White)
        .backgroundColor('rgba(0,0,0,0.45)')
        .padding({ left: 8, right: 8, top: 3, bottom: 3 })
        .borderRadius(10)
        .margin({ top: 12, right: 14 })
        .align(Alignment.TopEnd)
    }
    .width('100%')
    .height(280)
    .clip(true)
  }

  @Builder
  ThumbStripBuilder(game: GameItem) {
    Scroll() {
      Row({ space: 6 }) {
        ForEach([0, 1, 2, 3, 4, 5, 6], (index: number) => {
          Column()
            .width(64)
            .height(40)
            .borderRadius(6)
            .linearGradient({
              angle: 120,
              colors: [[game.gradientColors[0], 0], [game.gradientColors[1], 1]],
            })
            .opacity(index === 0 ? 1 : 0.55)
            .border({ width: index === 0 ? 1.5 : 0, color: '#2BC48A' })
        })
      }
      .padding({ left: 16, right: 16 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
  }

  @Builder
  PriceBarBuilder(game: GameItem) {
    Row() {
      Column() {
        Row() {
          Text('限时券后 ')
            .fontSize(12)
            .fontColor('#2E7D32')
          Text(`¥${(game.price * 0.98).toFixed(1)}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2E7D32')
        }
        if (game.lowestLabel) {
          Text(`${game.lowestLabel === '史低' ? '历史最低' : '新历史最低'} 剩余15小时`)
            .fontSize(10)
            .fontColor('#7A7A7A')
            .margin({ top: 2 })
        }
      }
      .alignItems(HorizontalAlign.Start)

      Row() {
        Text(`¥${game.price}`)
          .fontSize(12)
          .fontColor('#4A4A4A')
        if (game.originalPrice) {
          Text(`¥${game.originalPrice}`)
            .fontSize(11)
            .fontColor('#9AA79A')
            .decoration({ type: TextDecorationType.LineThrough })
            .margin({ left: 4 })
        }
        if (game.discountPercent) {
          Text(`-${game.discountPercent}%`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('#3A3A3A')
            .padding({ left: 5, right: 5, top: 1, bottom: 1 })
            .borderRadius(3)
            .margin({ left: 6 })
        }
      }
      .margin({ left: 12 })

      Blank()

      Text('全区价格/趋势 >')
        .fontSize(11)
        .fontColor('#2E7D32')
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#E3F4E9')
  }

  @Builder
  StatCellBuilder(cell: StatCell) {
    Column() {
      if (cell.value === '') {
        // 迷你趋势图占位，接入真实数据后可替换为折线/柱状图组件
        Row({ space: 2 }) {
          ForEach([6, 10, 8, 14, 11, 16, 13], (h: number) => {
            Row()
              .width(4)
              .height(h)
              .backgroundColor('#2BC48A')
              .borderRadius(1)
          })
        }
        .alignItems(VerticalAlign.Bottom)
        .height(17)
      } else {
        Row() {
          Text(cell.value)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          if (cell.extra) {
            Text(cell.extra)
              .fontSize(9)
              .fontColor('#B0B0B0')
              .margin({ left: 3 })
          }
        }
      }
      Text(cell.label)
        .fontSize(11)
        .fontColor('#999999')
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)
    .padding({ top: 12, bottom: 12 })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Column()
          .width('100%')
          .height(96)
          .linearGradient({
            angle: 180,
            colors: [['#1F7A7A', 0], ['#2BA6A6', 1]],
          })

        Column() {
          this.HeaderBuilder(this.game ? this.game.title : '游戏详情')

          Scroll() {
            Row({ space: 10 }) {
              ForEach(this.quickEntries, (entry: QuickEntry) => {
                this.QuickEntryBuilder(entry)
              })
            }
            .padding({ left: 16, right: 6 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .width('100%')
          .margin({ top: 4 })
        }
      }
      .width('100%')

      Row({ space: 6 }) {
        ForEach(this.detailTabs, (name: string, index: number) => {
          this.DetailTabBuilder(name, index)
        })
      }
      .width('100%')
      .padding({ left: 12, top: 10, bottom: 10 })
      .backgroundColor(Color.White)

      if (this.game) {
        Scroll() {
          Column() {
            this.BannerBuilder(this.game)

            Column() {
              this.ThumbStripBuilder(this.game)
            }
            .width('100%')
            .padding({ top: 10, bottom: 10 })

            this.PriceBarBuilder(this.game)

            Column() {
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
                      Text('🔥').fontSize(10)
                      Text(`${this.game.rating}`)
                        .fontSize(16)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.White)
                        .margin({ left: 2 })
                    }
                    .padding({ left: 8, right: 8, top: 3, bottom: 3 })
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

              Row() {
                Text('🎮 Steam | PlayStation | Xbox')
                  .fontSize(11)
                  .fontColor('#4A4A4A')
              }
              .margin({ top: 12 })

              Row() {
                Text('中文 | 单人/多人 | 联网 ›')
                  .fontSize(11)
                  .fontColor('#4A4A4A')
                Text('  ✔ Steam Deck ›')
                  .fontSize(11)
                  .fontColor('#4A4A4A')
                  .margin({ left: 8 })
              }
              .margin({ top: 8 })

              if (this.game.rankBoard) {
                Row() {
                  Text(this.game.rankBoard + ' ›')
                    .fontSize(11)
                    .fontColor('#2BA6A6')
                    .margin({ right: 8 })
                  Text(this.game.tags.join('   '))
                    .fontSize(11)
                    .fontColor('#4A4A4A')
                }
                .width('100%')
                .margin({ top: 10 })
              }

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
                Text('查看玩家统计 ›')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 6, bottom: 4 })

              Divider().color('#EFEFEF').strokeWidth(6).margin({ top: 8, bottom: 12 })

              Row() {
                Text('游戏简介')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Text(' 开发者入驻')
                  .fontSize(10)
                  .fontColor('#2BA6A6')
                  .backgroundColor('#E3F4E9')
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .borderRadius(4)
                  .margin({ left: 8 })
                Blank()
                Text('全部 >')
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')

              if (this.game.intro) {
                Text(this.game.intro)
                  .fontSize(13)
                  .fontColor('#4A4A4A')
                  .lineHeight(20)
                  .margin({ top: 10 })
                  .width('100%')
              }

              Row() {
                Text('🎟 限时 满50元减5元券 待使用')
                  .fontSize(12)
                  .fontColor('#E23B3B')
                Blank()
                Text('✕')
                  .fontSize(12)
                  .fontColor('#C0C0C0')
              }
              .width('100%')
              .padding(10)
              .backgroundColor('#FFF1F1')
              .borderRadius(8)
              .margin({ top: 16, bottom: 20 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16 })
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
            if (this.game.wishlistCount) {
              Text(this.game.wishlistCount)
                .fontSize(10)
                .fontColor('#999999')
            }
          }
          .alignItems(HorizontalAlign.Center)
          .margin({ right: 14 })

          Column() {
            Text('15:56:58')
              .fontSize(11)
              .fontColor('#999999')
            Text('距折扣结束')
              .fontSize(10)
              .fontColor('#B0B0B0')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          Stack({ alignContent: Alignment.TopEnd }) {
            Row() {
              Text('限时券后 ')
                .fontSize(13)
                .fontColor(Color.White)
              Text(`¥${(this.game.price * 0.98).toFixed(1)}`)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
            }
            .width(180)
            .height(44)
            .borderRadius(22)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#2BC48A')

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
