import { router } from '@kit.ArkUI';
import {
  GameItem,
  HeaderToolItem,
  getGameById,
  getGameCommunityPosts,
  getGameDatabaseItems,
  getGameRegionPrices,
  CommunityPost,
  PostComment,
  DatabaseItem,
  RegionPrice,
} from '../../model/GameModel';

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
  @State isWishlisted: boolean = false;
  @State isBuyModalOpen: boolean = false;
  @State selectedPost: CommunityPost | undefined = undefined;
  @State postDetailTab: number = 0; // 0: 正文, 1: 评论
  @State communityFilterIndex: number = 0; // 0: 综合, 1: 热点, 2: 开发者
  @State newCommentInput: string = '';
  @State currentPostLikes: number = 0;
  @State isCurrentPostLiked: boolean = false;
  @State isCurrentPostFavorited: boolean = false;

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
      .fontColor(this.detailTabIndex === index ? Color.White : '#333333')
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
            .alt($r('app.media.background'))
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

  @Builder
  CommunityContentBuilder(gameId: string) {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 1. 顶部活动卡片 Banner (如 幻兽帕鲁脑洞大挑战)
        Stack({ alignContent: Alignment.BottomStart }) {
          Column()
            .width('100%')
            .height(96)
            .borderRadius(10)
            .linearGradient({
              angle: 120,
              colors: [['#106A78', 0], ['#1B9AAA', 1]],
            })

          Row() {
            Column() {
              Text('✨ 脑洞大挑战')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('参与活动发帖抽帕鲁玩具 ▶')
                .fontSize(11)
                .fontColor('rgba(255,255,255,0.85)')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .padding(14)
          }
        }
        .width('100%')
        .margin({ bottom: 12 })

        // 2. 社区子筛选栏 (综合 | 热点 | 开发者   ⇯ 智能排序)
        Row() {
          ForEach(['综合', '热点', '开发者'], (item: string, idx: number) => {
            Column() {
              Text(item)
                .fontSize(14)
                .fontWeight(this.communityFilterIndex === idx ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.communityFilterIndex === idx ? '#1A1A1A' : '#666666')
              Row()
                .width(this.communityFilterIndex === idx ? 18 : 0)
                .height(3)
                .borderRadius(2)
                .backgroundColor('#2BC48A')
                .margin({ top: 4 })
            }
            .margin({ right: 20 })
            .onClick(() => (this.communityFilterIndex = idx))
          })

          Blank()

          Row() {
            Text('⇯ 智能排序')
              .fontSize(12)
              .fontColor('#999999')
          }
        }
        .width('100%')
        .margin({ bottom: 14 })

        // 3. 帖子列表
        ForEach(getGameCommunityPosts(gameId), (post: CommunityPost) => {
          Column() {
            // 作者信息行
            Row() {
              Text(post.authorName.charAt(0))
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .width(30)
                .height(30)
                .borderRadius(15)
                .backgroundColor(post.authorAvatarBg)
                .textAlign(TextAlign.Center)

              Text(post.authorName)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ left: 8 })

              if (post.authorLevel) {
                Text(post.authorLevel)
                  .fontSize(9)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .backgroundColor('#E91E63')
                  .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                  .borderRadius(4)
                  .margin({ left: 6 })
              }

              Blank()

              Text('···')
                .fontSize(16)
                .fontColor('#B0B0B0')
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)

            // 帖子标题与内容
            Text(post.title)
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ top: 10 })
              .width('100%')

            if (post.content !== post.title) {
              Text(post.content)
                .fontSize(13)
                .fontColor('#4A4A4A')
                .lineHeight(19)
                .margin({ top: 4 })
                .width('100%')
            }

            // 帖子封面配图
            if (post.coverImg) {
              Image(post.coverImg)
                .width(160)
                .height(110)
                .borderRadius(8)
                .objectFit(ImageFit.Cover)
                .margin({ top: 10 })
                .align(Alignment.Start)
            }

            // 底部元数据栏 (工具标签, 时间, 点赞评论)
            Row() {
              if (post.tag) {
                Row() {
                  Text('🩵 ')
                    .fontSize(10)
                  Text(post.tag)
                    .fontSize(11)
                    .fontColor('#2BC48A')
                }
                .padding({ left: 6, right: 8, top: 3, bottom: 3 })
                .backgroundColor('#E3F4E9')
                .borderRadius(4)
                .margin({ right: 8 })
              }

              Text(post.timeAgo)
                .fontSize(11)
                .fontColor('#999999')

              Blank()

              Row() {
                Text('💬 ')
                  .fontSize(12)
                Text(`${post.commentsCount}`)
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .margin({ right: 16 })

              Row() {
                Text('👍 ')
                  .fontSize(12)
                Text(`${post.likesCount}`)
                  .fontSize(12)
                  .fontColor('#999999')
              }
            }
            .width('100%')
            .margin({ top: 12 })
          }
          .width('100%')
          .padding(14)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ bottom: 10 })
          .onClick(() => {
            this.selectedPost = post;
            this.currentPostLikes = post.likesCount;
            this.isCurrentPostLiked = false;
            this.isCurrentPostFavorited = false;
            this.postDetailTab = 0;
          })
        })
      }
      .width('100%')
      .padding({ left: 14, right: 14, top: 10, bottom: 60 })

      // 底部悬浮 "参与讨论" 按钮 (截图 1)
      Row() {
        Text('👤')
          .fontSize(14)
          .margin({ right: 6 })
        Text('参与讨论')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
      .width(140)
      .height(42)
      .borderRadius(21)
      .backgroundColor('#1A1A1A')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 16 })
    }
    .width('100%')
  }

  @Builder
  PostDetailOverlayBuilder(post: CommunityPost) {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 顶部 Header 导航栏 (截图 2/3)
        Row() {
          Text('←')
            .fontSize(20)
            .fontColor('#1A1A1A')
            .padding({ left: 14, right: 14 })
            .onClick(() => {
              this.selectedPost = undefined;
            })

          Row() {
            Column() {
              Text('正文')
                .fontSize(16)
                .fontWeight(this.postDetailTab === 0 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.postDetailTab === 0 ? '#1A1A1A' : '#888888')
              Row()
                .width(this.postDetailTab === 0 ? 24 : 0)
                .height(3)
                .borderRadius(2)
                .backgroundColor('#1A1A1A')
                .margin({ top: 4 })
            }
            .padding({ left: 12, right: 12 })
            .onClick(() => (this.postDetailTab = 0))

            Column() {
              Text('评论')
                .fontSize(16)
                .fontWeight(this.postDetailTab === 1 ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.postDetailTab === 1 ? '#1A1A1A' : '#888888')
              Row()
                .width(this.postDetailTab === 1 ? 24 : 0)
                .height(3)
                .borderRadius(2)
                .backgroundColor('#1A1A1A')
                .margin({ top: 4 })
            }
            .padding({ left: 12, right: 12 })
            .onClick(() => (this.postDetailTab = 1))
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)

          Text('📤')
            .fontSize(18)
            .padding({ right: 16 })
        }
        .width('100%')
        .height(50)
        .backgroundColor(Color.White)
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })

        // 内容展示区
        Scroll() {
          Column() {
            if (this.postDetailTab === 0) {
              // 1. "正文" 视图 (截图 2)
              if (post.coverImg) {
                Stack({ alignContent: Alignment.TopEnd }) {
                  Image(post.coverImg)
                    .width('100%')
                    .height(300)
                    .objectFit(ImageFit.Cover)

                  Text('1/1')
                    .fontSize(11)
                    .fontColor(Color.White)
                    .backgroundColor('rgba(0,0,0,0.5)')
                    .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                    .borderRadius(10)
                    .margin({ top: 12, right: 12 })
                }
                .width('100%')
              }

              if (post.toolName) {
                Row() {
                  Text('🤖 ')
                    .fontSize(16)
                  Text(`试一试 · ${post.toolName}`)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1A1A1A')
                  Blank()
                  Text('去体验 >')
                    .fontSize(12)
                    .fontColor('#888888')
                }
                .width('100%')
                .padding(14)
                .backgroundColor('#F9F9FB')
                .borderRadius(8)
                .margin({ top: 12, left: 16, right: 16 })
              }

              // 作者栏
              Row() {
                Text(post.authorName.charAt(0))
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .width(36)
                  .height(36)
                  .borderRadius(18)
                  .backgroundColor(post.authorAvatarBg)
                  .textAlign(TextAlign.Center)

                Column() {
                  Row() {
                    Text(post.authorName)
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#1A1A1A')
                    if (post.authorLevel) {
                      Text(post.authorLevel)
                        .fontSize(9)
                        .fontColor(Color.White)
                        .backgroundColor('#E91E63')
                        .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                        .borderRadius(3)
                        .margin({ left: 6 })
                    }
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 10 })
                .layoutWeight(1)

                Text('+ 关注')
                  .fontSize(12)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .backgroundColor('#1A1A1A')
                  .padding({ left: 14, right: 14, top: 6, bottom: 6 })
                  .borderRadius(6)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14 })

              // 正文标题
              Text(post.title)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ left: 16, right: 16, top: 14 })
                .width('100%')

              // 标签 Chip
              Row({ space: 8 }) {
                Text('🦕 幻兽帕鲁')
                  .fontSize(11)
                  .fontColor('#3399FF')
                  .backgroundColor('#EBF5FF')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(6)
                if (post.tag) {
                  Text(`# ${post.tag}`)
                    .fontSize(11)
                    .fontColor('#3399FF')
                    .backgroundColor('#EBF5FF')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(6)
                }
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12 })

              // 发布时间与地点
              Text(`${post.timeAgo} · ${post.location ?? 'IP 属地未知'}`)
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ left: 16, right: 16, top: 10, bottom: 20 })
                .width('100%')

            } else {
              // 2. "评论" 视图 (截图 3)
              Column() {
                Row() {
                  Text('评论')
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Blank()
                  Text('⇯ 热门')
                    .fontSize(12)
                    .fontColor('#999999')
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                .border({ width: { bottom: 1 }, color: '#F0F0F0' })

                if (!post.comments || post.comments.length === 0) {
                  // 空状态 (截图 3)
                  Column() {
                    Text('⊞')
                      .fontSize(42)
                      .fontColor('#DDD')
                      .margin({ top: 40 })

                    Text('这里空空如也，来发布第一条评论吧！')
                      .fontSize(13)
                      .fontColor('#999999')
                      .margin({ top: 12 })

                    Text('💬 点击评论')
                      .fontSize(13)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(Color.White)
                      .backgroundColor('#262626')
                      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                      .borderRadius(6)
                      .margin({ top: 16, bottom: 40 })
                  }
                  .width('100%')
                  .alignItems(HorizontalAlign.Center)
                } else {
                  // 评论列表
                  ForEach(post.comments, (comment: PostComment) => {
                    Row() {
                      Text(comment.authorName.charAt(0))
                        .fontSize(12)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.White)
                        .width(28)
                        .height(28)
                        .borderRadius(14)
                        .backgroundColor(comment.authorAvatarBg)
                        .textAlign(TextAlign.Center)

                      Column() {
                        Row() {
                          Text(comment.authorName)
                            .fontSize(12)
                            .fontWeight(FontWeight.Bold)
                            .fontColor('#1A1A1A')
                          if (comment.authorLevel) {
                            Text(comment.authorLevel)
                              .fontSize(8)
                              .fontColor(Color.White)
                              .backgroundColor('#E91E63')
                              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                              .borderRadius(3)
                              .margin({ left: 4 })
                          }
                          Blank()
                          Text(comment.timeAgo)
                            .fontSize(10)
                            .fontColor('#B0B0B0')
                        }
                        .width('100%')

                        Text(comment.content)
                          .fontSize(13)
                          .fontColor('#333333')
                          .margin({ top: 4 })
                          .width('100%')
                      }
                      .alignItems(HorizontalAlign.Start)
                      .layoutWeight(1)
                      .margin({ left: 10 })
                    }
                    .width('100%')
                    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                    .border({ width: { bottom: 1 }, color: '#F5F5F7' })
                  })
                }
              }
              .width('100%')
            }
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .width('100%')

        // 底部评论输入与交互栏 (截图 2/3)
        Row() {
          TextInput({ placeholder: '来说点什么吧！', text: $$this.newCommentInput })
            .fontSize(13)
            .placeholderColor('#B0B0B0')
            .backgroundColor('#F5F5F7')
            .height(36)
            .borderRadius(18)
            .layoutWeight(1)
            .onSubmit(() => {
              if (this.newCommentInput.trim() !== '') {
                if (!post.comments) {
                  post.comments = [];
                }
                post.comments.push({
                  id: `c-${Date.now()}`,
                  authorName: '盒友999',
                  authorAvatarBg: '#FF9500',
                  authorLevel: 'Lv.6',
                  timeAgo: '刚刚',
                  content: this.newCommentInput.trim(),
                  likesCount: 0,
                });
                post.commentsCount = post.comments.length;
                this.newCommentInput = '';
                this.postDetailTab = 1;
              }
            })

          Row() {
            Text('👍')
              .fontSize(16)
              .fontColor(this.isCurrentPostLiked ? '#FF9500' : '#888888')
            Text(` ${this.currentPostLikes}`)
              .fontSize(12)
              .fontColor(this.isCurrentPostLiked ? '#FF9500' : '#888888')
          }
          .margin({ left: 16 })
          .onClick(() => {
            this.isCurrentPostLiked = !this.isCurrentPostLiked;
            if (this.isCurrentPostLiked) {
              this.currentPostLikes += 1;
            } else {
              this.currentPostLikes -= 1;
            }
          })

          Row() {
            Text(this.isCurrentPostFavorited ? '★' : '☆')
              .fontSize(16)
              .fontColor(this.isCurrentPostFavorited ? '#FF9500' : '#888888')
            Text(this.isCurrentPostFavorited ? ' 已收藏' : ' 收藏')
              .fontSize(12)
              .fontColor(this.isCurrentPostFavorited ? '#FF9500' : '#888888')
          }
          .margin({ left: 16 })
          .onClick(() => {
            this.isCurrentPostFavorited = !this.isCurrentPostFavorited;
          })

          Row() {
            Text('💬')
              .fontSize(16)
              .fontColor('#888888')
            Text(` ${post.comments ? post.comments.length : post.commentsCount}`)
              .fontSize(12)
              .fontColor('#888888')
          }
          .margin({ left: 16 })
          .onClick(() => {
            this.postDetailTab = 1;
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(Color.White)
        .border({ width: { top: 1 }, color: '#F0F0F0' })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  DatabaseContentBuilder(gameId: string) {
    Column() {
      Row() {
        Text('全部分类 ▾')
          .fontSize(12)
          .fontColor('#1A1A1A')
          .fontWeight(FontWeight.Medium)
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(Color.White)
          .borderRadius(14)

        Text('按稀有度 ▾')
          .fontSize(12)
          .fontColor('#666666')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor(Color.White)
          .borderRadius(14)
          .margin({ left: 8 })
      }
      .width('100%')
      .margin({ bottom: 12 })

      Grid() {
        ForEach(getGameDatabaseItems(gameId), (item: DatabaseItem) => {
          GridItem() {
            Column() {
              Row() {
                Text(item.icon)
                  .fontSize(28)
                Blank()
                if (item.rarity) {
                  Text(item.rarity)
                    .fontSize(10)
                    .fontColor(Color.White)
                    .backgroundColor(item.rarityColor ?? '#FF9500')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius(4)
                }
              }
              .width('100%')

              Text(item.name)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ top: 8 })
                .width('100%')

              Text(item.desc)
                .fontSize(11)
                .fontColor('#777777')
                .margin({ top: 4 })
                .width('100%')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(10)
            .alignItems(HorizontalAlign.Start)
          }
        })
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
    }
    .width('100%')
    .padding(14)
  }

  @Builder
  StatsContentBuilder(gameId: string) {
    Column() {
      // 在线走势看板
      Column() {
        Text('近15日在线玩家峰值走势')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .width('100%')

        Row({ space: 6 }) {
          ForEach([30, 45, 60, 50, 75, 90, 85, 110, 95, 120, 105, 140, 130, 150, 165], (heightVal: number, idx: number) => {
            Column() {
              Row()
                .width(14)
                .height(heightVal * 0.6)
                .backgroundColor(idx === 14 ? '#2BC48A' : '#D0EBE0')
                .borderRadius({ topLeft: 3, topRight: 3 })
              Text(`${idx + 1}`)
                .fontSize(9)
                .fontColor('#999999')
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Center)
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Bottom)
        .margin({ top: 16, bottom: 8 })
      }
      .width('100%')
      .padding(14)
      .backgroundColor(Color.White)
      .borderRadius(10)
      .margin({ bottom: 12 })

      // 全区价格对比表
      Column() {
        Text('全球 Steam 区域价格对比')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .width('100%')
          .margin({ bottom: 10 })

        ForEach(getGameRegionPrices(gameId), (region: RegionPrice) => {
          Row() {
            Text(region.flagEmoji)
              .fontSize(18)
            Text(region.regionName)
              .fontSize(13)
              .fontColor('#1A1A1A')
              .margin({ left: 8 })
            if (region.isLowest) {
              Text('史低')
                .fontSize(9)
                .fontColor(Color.White)
                .backgroundColor('#2BC48A')
                .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                .borderRadius(3)
                .margin({ left: 6 })
            }
            Blank()
            Column() {
              Text(region.priceCNY)
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text(region.priceLocal)
                .fontSize(10)
                .fontColor('#999999')
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          .border({ width: { bottom: 1 }, color: '#F5F5F7' })
        })
      }
      .width('100%')
      .padding(14)
      .backgroundColor(Color.White)
      .borderRadius(10)
    }
    .width('100%')
    .padding(14)
  }

  @Builder
  BuyModalBuilder(game: GameItem) {
    Stack({ alignContent: Alignment.Bottom }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => (this.isBuyModalOpen = false))

      Column() {
        Row() {
          Text('确认激活码购买')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Blank()
          Text('✕')
            .fontSize(18)
            .fontColor('#999999')
            .onClick(() => (this.isBuyModalOpen = false))
        }
        .width('100%')

        Row() {
          if (game.coverImg) {
            Image(game.coverImg)
              .width(80)
              .height(48)
              .borderRadius(6)
              .objectFit(ImageFit.Cover)
          }
          Column() {
            Text(game.title)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Text(game.platformIcon ? 'Steam 激活码 Key' : 'Steam 全区国区平价自动发货')
              .fontSize(11)
              .fontColor('#888888')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 10 })
          .layoutWeight(1)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F9F9FB')
        .borderRadius(8)
        .margin({ top: 14 })

        Row() {
          Text('优惠券抵扣')
            .fontSize(13)
            .fontColor('#1A1A1A')
          Blank()
          Text(game.couponLabel ?? '新用户立减优惠券')
            .fontSize(12)
            .fontColor('#E23B3B')
        }
        .width('100%')
        .margin({ top: 16 })

        Row() {
          Text('黑盒黑籽抵扣')
            .fontSize(13)
            .fontColor('#1A1A1A')
          Blank()
          Text('可抵扣 ¥ 2.00')
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .margin({ top: 12 })

        Row() {
          Text('实付款')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Blank()
          Text('¥ ')
            .fontSize(14)
            .fontColor('#E23B3B')
          Text(`${game.price}`)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#E23B3B')
        }
        .width('100%')
        .margin({ top: 20, bottom: 20 })

        Row() {
          Text('立即支付')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .height(46)
        .borderRadius(23)
        .backgroundColor('#FF9500')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.isBuyModalOpen = false;
        })
      }
      .width('100%')
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
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
              if (this.detailTabIndex === 0) {
                // 1. "游戏" 主 Tab 页签
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
              } else if (this.detailTabIndex === 1) {
                // 2. "社区" Tab 页签
                this.CommunityContentBuilder(this.game.id)
              } else if (this.detailTabIndex === 2 && this.game.hasDatabaseTab) {
                // 3. "数据库" Tab 页签
                this.DatabaseContentBuilder(this.game.id)
              } else {
                // 4. "统计" Tab 页签
                this.StatsContentBuilder(this.game.id)
              }
            }
          }
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .width('100%')

          // 底部悬浮购买栏
          Row() {
            Column() {
              Text(this.isWishlisted ? '❤️' : '♡')
                .fontSize(18)
                .fontColor(this.isWishlisted ? '#E23B3B' : '#999999')
              Text(this.game.wishlistCount ?? '32w')
                .fontSize(10)
                .fontColor(this.isWishlisted ? '#E23B3B' : '#999999')
            }
            .alignItems(HorizontalAlign.Center)
            .margin({ right: 14 })
            .onClick(() => {
              this.isWishlisted = !this.isWishlisted;
            })

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
              .onClick(() => (this.isBuyModalOpen = true))

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

      if (this.isBuyModalOpen && this.game) {
        this.BuyModalBuilder(this.game)
      }

      if (this.selectedPost) {
        this.PostDetailOverlayBuilder(this.selectedPost)
      }
    }
    .width('100%')
    .height('100%')
  }
}



