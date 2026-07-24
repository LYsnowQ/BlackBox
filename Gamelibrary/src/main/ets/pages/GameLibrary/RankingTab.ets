import { GameItem, GameDataSource, getFilteredGames } from '../../model/GameLibrary/GameLibraryModel';
import { GameLibraryRoutes } from '../../router/GameLibraryRoutes';

@Component
export struct RankingTab {
  @State platformIndex: number = 0;
  @State categoryIndex: number = 0;
  @State activeFilterMenu: string = ''; // '' | '付费' | '游戏类型' | '折扣区间' | '评分'
  @State selectedPayFilter: string = '全部';
  @State selectedTypeFilter: string = '全部';
  @State selectedDiscountFilter: string = '全部';
  @State selectedScoreFilter: string = '全部';
  @State isFilterDrawerOpen: boolean = false;

  private dataSource: GameDataSource = new GameDataSource(getFilteredGames(0, 0));

  private platforms: string[] = ['PC', 'Switch', 'PSN', 'Xbox'];
  private categories: string[] = ['最受欢迎', '优惠促销', '最受期待', '商城热销', '当前在线'];
  private filters: string[] = ['付费', '游戏类型', '折扣区间', '评分'];

  private payOptions: string[] = ['全部', '免费游玩', '100元以下', '100-200元', '200元以上'];
  private typeOptions: string[] = ['全部', '动作', '角色扮演', '开放世界', '解谜', '休闲', '沙盒'];
  private discountOptions: string[] = ['全部', '特惠中', '5折及以上', '7折及以上'];
  private scoreOptions: string[] = ['全部', '9.0分以上', '9.5分以上'];

  private goDetail(id: string): void {
    try {
      this.getUIContext().getRouter().pushUrl({
        url: GameLibraryRoutes.GAME_DETAIL,
        params: { id },
      });
    } catch (err) {
    }
  }

  private updateList(): void {
    this.dataSource.setItems(getFilteredGames(
      this.platformIndex,
      this.categoryIndex,
      this.selectedPayFilter,
      this.selectedTypeFilter,
      this.selectedDiscountFilter,
      this.selectedScoreFilter
    ));
  }

  private resetAllFilters(): void {
    this.selectedPayFilter = '全部';
    this.selectedTypeFilter = '全部';
    this.selectedDiscountFilter = '全部';
    this.selectedScoreFilter = '全部';
    this.activeFilterMenu = '';
    this.updateList();
  }

  private getChipLabel(name: string): string {
    if (name === '付费' && this.selectedPayFilter !== '全部') {
      return this.selectedPayFilter;
    }
    if (name === '游戏类型' && this.selectedTypeFilter !== '全部') {
      return this.selectedTypeFilter;
    }
    if (name === '折扣区间' && this.selectedDiscountFilter !== '全部') {
      return this.selectedDiscountFilter;
    }
    if (name === '评分' && this.selectedScoreFilter !== '全部') {
      return this.selectedScoreFilter;
    }
    return name;
  }

  private isChipActive(name: string): boolean {
    if (this.activeFilterMenu === name) {
      return true;
    }
    if (name === '付费' && this.selectedPayFilter !== '全部') return true;
    if (name === '游戏类型' && this.selectedTypeFilter !== '全部') return true;
    if (name === '折扣区间' && this.selectedDiscountFilter !== '全部') return true;
    if (name === '评分' && this.selectedScoreFilter !== '全部') return true;
    return false;
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
    .onClick(() => {
      this.platformIndex = index;
      this.updateList();
    })
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
    .onClick(() => {
      this.categoryIndex = index;
      this.updateList();
    })
  }

  @Builder
  FilterChipBuilder(name: string) {
    Row() {
      Text(this.getChipLabel(name))
        .fontSize(12)
        .fontColor(this.isChipActive(name) ? '#2BC48A' : '#666666')
        .fontWeight(this.isChipActive(name) ? FontWeight.Bold : FontWeight.Normal)
      Text(' ▾')
        .fontSize(10)
        .fontColor(this.isChipActive(name) ? '#2BC48A' : '#999999')
    }
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
    .backgroundColor(this.isChipActive(name) ? '#E3F4E9' : '#F5F5F7')
    .borderRadius(8)
    .margin({ right: 8 })
    .onClick(() => {
      if (this.activeFilterMenu === name) {
        this.activeFilterMenu = '';
      } else {
        this.activeFilterMenu = name;
      }
    })
  }

  @Builder
  RankBadgeBuilder(rank: number) {
    if (rank === 1) {
      Text('1')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#FFB300')
        .width(20)
        .height(20)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .margin({ right: 8 })
    } else if (rank === 2) {
      Text('2')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#90A4AE')
        .width(20)
        .height(20)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .margin({ right: 8 })
    } else if (rank === 3) {
      Text('3')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#CD7F32')
        .width(20)
        .height(20)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .margin({ right: 8 })
    } else {
      Text(`${rank}`)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor('#B0B0B0')
        .width(20)
        .textAlign(TextAlign.Center)
        .margin({ right: 8 })
    }
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
          .alt($r('app.media.background'))
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
    .width(108)
    .aspectRatio(1.72)
    .borderRadius(10)
    .clip(true)
  }

  @Builder
  GameRowBuilder(item: GameItem, rank: number) {
    Row() {
      this.RankBadgeBuilder(rank)
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
        .margin({ top: 6 })

        Row() {
          Text(item.tags.slice(0, 2).join(' | '))
            .fontSize(11)
            .fontColor('#999999')
        }
        .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .padding({ left: 10 })

      this.RatingBadgeBuilder(item)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .padding({ top: 14, bottom: 14 })
    .onClick(() => this.goDetail(item.id))
  }

  @Builder
  FilterOptionsSubBarBuilder() {
    if (this.activeFilterMenu !== '') {
      Scroll() {
        Row({ space: 8 }) {
          if (this.activeFilterMenu === '付费') {
            ForEach(this.payOptions, (opt: string) => {
              Text(opt)
                .fontSize(12)
                .fontColor(this.selectedPayFilter === opt ? Color.White : '#1A1A1A')
                .backgroundColor(this.selectedPayFilter === opt ? '#2BC48A' : '#F0F0F2')
                .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                .borderRadius(14)
                .onClick(() => {
                  this.selectedPayFilter = opt;
                  this.updateList();
                })
            })
          } else if (this.activeFilterMenu === '游戏类型') {
            ForEach(this.typeOptions, (opt: string) => {
              Text(opt)
                .fontSize(12)
                .fontColor(this.selectedTypeFilter === opt ? Color.White : '#1A1A1A')
                .backgroundColor(this.selectedTypeFilter === opt ? '#2BC48A' : '#F0F0F2')
                .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                .borderRadius(14)
                .onClick(() => {
                  this.selectedTypeFilter = opt;
                  this.updateList();
                })
            })
          } else if (this.activeFilterMenu === '折扣区间') {
            ForEach(this.discountOptions, (opt: string) => {
              Text(opt)
                .fontSize(12)
                .fontColor(this.selectedDiscountFilter === opt ? Color.White : '#1A1A1A')
                .backgroundColor(this.selectedDiscountFilter === opt ? '#2BC48A' : '#F0F0F2')
                .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                .borderRadius(14)
                .onClick(() => {
                  this.selectedDiscountFilter = opt;
                  this.updateList();
                })
            })
          } else if (this.activeFilterMenu === '评分') {
            ForEach(this.scoreOptions, (opt: string) => {
              Text(opt)
                .fontSize(12)
                .fontColor(this.selectedScoreFilter === opt ? Color.White : '#1A1A1A')
                .backgroundColor(this.selectedScoreFilter === opt ? '#2BC48A' : '#F0F0F2')
                .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                .borderRadius(14)
                .onClick(() => {
                  this.selectedScoreFilter = opt;
                  this.updateList();
                })
            })
          }
        }
        .padding({ top: 4, bottom: 8 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
    }
  }

  @Builder
  FilterDrawerModalBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.isFilterDrawerOpen = false))

      // 底部抽屉面板
      Column() {
        // 面板 Header
        Row() {
          Text('高级筛选')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Blank()
          Text('✕')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.isFilterDrawerOpen = false))
        }
        .width('100%')
        .padding(16)
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })

        Scroll() {
          Column({ space: 16 }) {
            // 付费模式
            Column() {
              Text('付费模式')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ bottom: 10 })
                .width('100%')

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.payOptions, (opt: string) => {
                  Text(opt)
                    .fontSize(12)
                    .fontColor(this.selectedPayFilter === opt ? Color.White : '#1A1A1A')
                    .backgroundColor(this.selectedPayFilter === opt ? '#2BC48A' : '#F5F5F7')
                    .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => (this.selectedPayFilter = opt))
                })
              }
            }

            // 游戏类型
            Column() {
              Text('游戏类型')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ bottom: 10 })
                .width('100%')

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.typeOptions, (opt: string) => {
                  Text(opt)
                    .fontSize(12)
                    .fontColor(this.selectedTypeFilter === opt ? Color.White : '#1A1A1A')
                    .backgroundColor(this.selectedTypeFilter === opt ? '#2BC48A' : '#F5F5F7')
                    .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => (this.selectedTypeFilter = opt))
                })
              }
            }

            // 折扣区间
            Column() {
              Text('折扣区间')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ bottom: 10 })
                .width('100%')

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.discountOptions, (opt: string) => {
                  Text(opt)
                    .fontSize(12)
                    .fontColor(this.selectedDiscountFilter === opt ? Color.White : '#1A1A1A')
                    .backgroundColor(this.selectedDiscountFilter === opt ? '#2BC48A' : '#F5F5F7')
                    .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => (this.selectedDiscountFilter = opt))
                })
              }
            }

            // 评分筛选
            Column() {
              Text('评分筛选')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ bottom: 10 })
                .width('100%')

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.scoreOptions, (opt: string) => {
                  Text(opt)
                    .fontSize(12)
                    .fontColor(this.selectedScoreFilter === opt ? Color.White : '#1A1A1A')
                    .backgroundColor(this.selectedScoreFilter === opt ? '#2BC48A' : '#F5F5F7')
                    .padding({ left: 14, right: 14, top: 7, bottom: 7 })
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => (this.selectedScoreFilter = opt))
                })
              }
            }
          }
          .padding(16)
        }
        .layoutWeight(1)
        .width('100%')

        // 底部重置 & 完成按钮 (增加 bottom 边距避开主底栏重叠)
        Row({ space: 12 }) {
          Button('重置')
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor('#1A1A1A')
            .backgroundColor('#F0F0F2')
            .borderRadius(20)
            .layoutWeight(1)
            .height(40)
            .onClick(() => this.resetAllFilters())

          Button('完成')
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#2BC48A')
            .borderRadius(20)
            .layoutWeight(2)
            .height(40)
            .onClick(() => {
              this.updateList();
              this.isFilterDrawerOpen = false;
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 10, bottom: 60 })
        .backgroundColor(Color.White)
        .border({ width: { top: 1 }, color: '#F0F0F0' })
      }
      .width('100%')
      .height('70%')
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Row() {
          ForEach(this.platforms, (name: string, index: number) => {
            this.PlatformTabBuilder(name, index)
          })
        }
        .width('100%')
        .padding({ top: 8, bottom: 8 })

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
        .margin({ top: 2, bottom: 4 })

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
              .fontColor(this.isFilterDrawerOpen ? '#2BC48A' : '#666666')
            Text(' 筛选')
              .fontSize(12)
              .fontColor(this.isFilterDrawerOpen ? '#2BC48A' : '#666666')
              .fontWeight(this.isFilterDrawerOpen ? FontWeight.Bold : FontWeight.Normal)
          }
          .padding({ left: 8, right: 6, top: 5, bottom: 5 })
          .backgroundColor(this.isFilterDrawerOpen ? '#E3F4E9' : '#F5F5F7')
          .borderRadius(8)
          .onClick(() => (this.isFilterDrawerOpen = true))
        }
        .width('100%')
        .margin({ top: 6, bottom: 4 })

        // 展开的子选项栏
        this.FilterOptionsSubBarBuilder()

        List() {
          LazyForEach(this.dataSource, (item: GameItem, index: number) => {
            ListItem() {
              Column() {
                this.GameRowBuilder(item, index + 1)
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

      if (this.isFilterDrawerOpen) {
        this.FilterDrawerModalBuilder()
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
}

