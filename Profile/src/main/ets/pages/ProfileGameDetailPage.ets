import {
  GameItem,
  HeaderToolItem,
  CommunityPost,
  PostComment,
  PostCommentReply,
  PostGameCard,
  DatabaseItem,
  RegionPrice,
} from '../model/types/GameCatalogModel';
import {
  getCatalogGameForLibraryIdSync,
  getGameCommunityPostsSync,
  getGameDatabaseItemsSync,
  getGameRegionPricesSync,
} from '../api/GameCatalogApi';

interface StatCell {
  value: string;
  label: string;
  extra?: string; // 排名等附加信息，如 "#496"
  isTrend?: boolean;
}

/**
 * Profile 自包含游戏详情（从 Gamelibrary GameDetail 整页复制）
 * 展示商城向介绍 / 评分 / 社区 / 统计，非个人时长成就页。
 * 入参 params.id 支持个人库 lg* 或详情 slug；数据经 GameCatalogApi。
 */
@Component
export struct ProfileGameDetailPage {
  @State game: GameItem | undefined = undefined;
  @State detailTabIndex: number = 0;
  @State isWishlisted: boolean = false;
  @State isBuyModalOpen: boolean = false;
  @State selectedPost: CommunityPost | undefined = undefined;
  @State postDetailTab: number = 0; // 0: 正文, 1: 评论
  @State communityFilterIndex: number = 0; // 0: 综合, 1: 热点, 2: 开发者
  @State newCommentInput: string = '';
  @State currentPostLikes: number = 0;
  private postScroller: Scroller = new Scroller();
  @State replyingCommentId: string = '';
  @State replyTargetUser: string = '';
  @State isCurrentPostLiked: boolean = false;
  @State isCurrentPostFavorited: boolean = false;
  @State isFollowingAuthor: boolean = false;
  @State pokedexFilter: string = '全部';

  aboutToAppear(): void {
    try {
      const params = this.getUIContext().getRouter().getParams() as Record<string, Object>;
      let rawId: string = '';
      if (params !== undefined && params !== null) {
        const idVal: Object | undefined = params['id'];
        if (typeof idVal === 'string') {
          rawId = idVal;
        }
      }
      this.game = getCatalogGameForLibraryIdSync(rawId);
    } catch {
      this.game = getCatalogGameForLibraryIdSync('palworld');
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
            this.getUIContext().getRouter().back();
          } catch {
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
  GameCardBuilder(card: PostGameCard) {
    Row() {
      if (card.coverImg) {
        Image(card.coverImg)
          .width(84)
          .height(104)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)
      }
      Column() {
        Text('CHAINED TOGETHER')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text(card.title)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ top: 2 })
        if (card.subTitle) {
          Text(card.subTitle)
            .fontSize(10)
            .fontColor('rgba(255,255,255,0.75)')
            .margin({ top: 8 })
        }
        Row() {
          Text(`${card.lowestTag ?? '史低成交价'} `)
            .fontSize(9)
            .fontColor('#FFD700')
          Text('¥')
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFD700')
          Text(card.price)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFD700')
          if (card.discount) {
            Text(card.discount)
              .fontSize(9)
              .fontColor(Color.White)
              .backgroundColor('#2BC48A')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ left: 6 })
          }
        }
        .margin({ top: 6 })
        .alignItems(VerticalAlign.Bottom)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 10 })
    }
    .width(260)
    .padding(10)
    .borderRadius(10)
    .linearGradient({
      angle: 135,
      colors: [['#E59400', 0], ['#D96A4A', 1]],
    })
    .margin({ top: 10 })
  }

  @Builder
  CommunityContentBuilder(gameId: string) {
    Column() {
      // 1. 社区子筛选栏 (综合 | 热点 | 开发者   ⇯ 智能排序)
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
      .margin({ bottom: 12 })

      // 2. 帖子列表
      ForEach(getGameCommunityPostsSync(gameId), (post: CommunityPost) => {
        Column() {
          // 作者信息行 (头像, 昵称, 等级, 三点更多)
          Row() {
            Text(post.authorName.charAt(0))
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .width(32)
              .height(32)
              .borderRadius(16)
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

          // 帖子标题与文本内容
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

          // 专属内嵌游戏购买卡片 (截图 1)
          if (post.gameCard) {
            this.GameCardBuilder(post.gameCard)
          } else if (post.coverImg) {
            // 帖子封面配图 (截图 1 笔记本实拍照片)
            Image(post.coverImg)
              .width(180)
              .height(120)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)
              .margin({ top: 10 })
              .align(Alignment.Start)
          }

          // 底部元数据栏 (话题标签 # 合作, 时间, 点赞评论)
          Row() {
            if (post.tag) {
              Row() {
                Text('# ')
                  .fontSize(11)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#3399FF')
                Text(post.tag)
                  .fontSize(11)
                  .fontColor('#3399FF')
              }
              .padding({ left: 6, right: 8, top: 3, bottom: 3 })
              .backgroundColor('#EBF5FF')
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
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 14, right: 14, top: 10, bottom: 90 })
  }

  @Builder
  CommentsListBuilder(post: CommunityPost) {
    if (!post.comments || post.comments.length === 0) {
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
      ForEach(post.comments, (comment: PostComment) => {
        Row() {
          Text(comment.authorName.charAt(0))
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .width(32)
            .height(32)
            .borderRadius(16)
            .backgroundColor(comment.authorAvatarBg)
            .textAlign(TextAlign.Center)

          Column() {
            Row() {
              Text(comment.authorName)
                .fontSize(13)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
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
              Row() {
                Text('👍 ')
                  .fontSize(11)
                  .fontColor('#999999')
                Text(`${comment.likesCount}`)
                  .fontSize(11)
                  .fontColor('#999999')
              }
            }
            .width('100%')

            Text(comment.timeAgo)
              .fontSize(10)
              .fontColor('#B0B0B0')
              .margin({ top: 2 })

            Text(comment.content)
              .fontSize(13)
              .fontColor('#1A1A1A')
              .lineHeight(19)
              .margin({ top: 6 })
              .width('100%')

            // 楼中楼评论 (显示单条或多条玩家回复)
            if ((comment.replies && comment.replies.length > 0) || comment.reply) {
              Column() {
                ForEach(
                  comment.replies && comment.replies.length > 0
                    ? comment.replies
                    : (comment.reply ? [comment.reply] : []),
                  (rep: PostCommentReply) => {
                    Row() {
                      Text() {
                        Span(`${rep.authorName}`)
                          .fontSize(12)
                          .fontWeight(FontWeight.Bold)
                          .fontColor('#3399FF')
                        if (rep.targetUser) {
                          Span(' 回复 ')
                            .fontSize(11)
                            .fontColor('#888888')
                          Span(`@${rep.targetUser}`)
                            .fontSize(12)
                            .fontWeight(FontWeight.Medium)
                            .fontColor('#3399FF')
                        }
                        Span(`: ${rep.content}`)
                          .fontSize(12)
                          .fontColor('#4A4A4A')
                        Span(`  ${rep.timeAgo}${rep.location ? '·' + rep.location : ''}`)
                          .fontSize(10)
                          .fontColor('#B0B0B0')
                      }
                      .lineHeight(18)
                      .width('100%')
                    }
                    .width('100%')
                    .margin({ bottom: 4 })
                  }
                )
              }
              .width('100%')
              .padding(8)
              .backgroundColor('#F7F8FA')
              .borderRadius(6)
              .margin({ top: 8 })
            }

            Row() {
              Text('💬 回复')
                .fontSize(11)
                .fontColor('#888888')
            }
            .margin({ top: 6 })
            .onClick(() => {
              this.replyingCommentId = comment.id ?? '';
              this.replyTargetUser = comment.authorName;
            })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .margin({ left: 10 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .border({ width: { bottom: 1 }, color: '#F5F5F7' })
        .onClick(() => {
          this.replyingCommentId = comment.id ?? '';
          this.replyTargetUser = comment.authorName;
        })
      })
    }
  }

  @Builder
  PostDetailOverlayBuilder(post: CommunityPost) {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 顶部 Header 导航栏 (截图 2: [正文 | 评论], 截图 3: [头像 xin. + 关注])
        Row() {
          Text('←')
            .fontSize(20)
            .fontColor('#1A1A1A')
            .padding({ left: 14, right: 14 })
            .onClick(() => {
              this.selectedPost = undefined;
              this.replyingCommentId = '';
              this.replyTargetUser = '';
            })

          if (this.postDetailTab === 0) {
            // 截图 2 Header: 正文 / 评论 Tab 页签
            Row() {
              Column() {
                Text('正文')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Row()
                  .width(24)
                  .height(3)
                  .borderRadius(2)
                  .backgroundColor('#1A1A1A')
                  .margin({ top: 4 })
              }
              .padding({ left: 12, right: 12 })

              Column() {
                Text('评论')
                  .fontSize(16)
                  .fontWeight(FontWeight.Normal)
                  .fontColor('#888888')
                Row()
                  .width(0)
                  .height(3)
                  .borderRadius(2)
                  .backgroundColor('#1A1A1A')
                  .margin({ top: 4 })
              }
              .padding({ left: 12, right: 12 })
              .onClick(() => {
                this.postDetailTab = 1;
                try {
                  this.postScroller.scrollTo({ xOffset: 0, yOffset: 0 });
                } catch {
                }
              })
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            // 截图 3 Header: 帖子作者紧凑导航栏 [头像 xin.  +关注]
            Row() {
              Text(post.authorName.charAt(0))
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .width(28)
                .height(28)
                .borderRadius(14)
                .backgroundColor(post.authorAvatarBg)
                .textAlign(TextAlign.Center)

              Text(post.authorName)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ left: 8 })

              Text(this.isFollowingAuthor ? '已关注' : '+ 关注')
                .fontSize(11)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.isFollowingAuthor ? '#666666' : Color.White)
                .backgroundColor(this.isFollowingAuthor ? '#E0E0E0' : '#1A1A1A')
                .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                .borderRadius(12)
                .margin({ left: 10 })
                .onClick(() => (this.isFollowingAuthor = !this.isFollowingAuthor))
            }
            .layoutWeight(1)
            .alignItems(VerticalAlign.Center)
          }

          Text('📤')
            .fontSize(18)
            .padding({ right: 16 })
        }
        .width('100%')
        .height(50)
        .backgroundColor(Color.White)
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })

        // 内容展示区 (顶部紧贴, 消除留白)
        Scroll(this.postScroller) {
          Column() {
            if (this.postDetailTab === 0) {
              // 1. "正文" 视图 (截图 2)
              if (post.coverImg) {
                Stack({ alignContent: Alignment.BottomEnd }) {
                  Image(post.coverImg)
                    .width('100%')
                    .height(280)
                    .objectFit(ImageFit.Cover)

                  // 顶部角标 (左侧 实况 / 右侧 1/1)
                  Row() {
                    Row() {
                      Text('📷 ')
                        .fontSize(11)
                        .fontColor(Color.White)
                      Text('实况')
                        .fontSize(11)
                        .fontColor(Color.White)
                    }
                    .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                    .backgroundColor('rgba(0,0,0,0.6)')
                    .borderRadius(12)
                    .margin({ top: 12, left: 12 })

                    Blank()

                    Text('1/1')
                      .fontSize(11)
                      .fontColor(Color.White)
                      .backgroundColor('rgba(0,0,0,0.6)')
                      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                      .borderRadius(12)
                      .margin({ top: 12, right: 12 })
                  }
                  .width('100%')
                  .align(Alignment.TopStart)

                  // 右下角 静音按钮
                  Text('🔇')
                    .fontSize(14)
                    .fontColor(Color.White)
                    .backgroundColor('rgba(0,0,0,0.6)')
                    .padding(6)
                    .borderRadius(14)
                    .margin({ bottom: 12, right: 12 })
                }
                .width('100%')
              }

              // 作者栏 (头像 xin. + 关注 按钮)
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

                Text(this.isFollowingAuthor ? '已关注' : '+ 关注')
                  .fontSize(12)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.isFollowingAuthor ? '#666666' : Color.White)
                  .backgroundColor(this.isFollowingAuthor ? '#E0E0E0' : '#1A1A1A')
                  .padding({ left: 14, right: 14, top: 6, bottom: 6 })
                  .borderRadius(6)
                  .onClick(() => (this.isFollowingAuthor = !this.isFollowingAuthor))
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14 })

              // 正文标题与内容 (截图 2: "求助，有没有大佬帮忙过去...")
              Text(post.title)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ left: 16, right: 16, top: 12 })
                .width('100%')

              if (post.content !== post.title) {
                Text(post.content)
                  .fontSize(14)
                  .fontColor('#333333')
                  .lineHeight(20)
                  .margin({ left: 16, right: 16, top: 6 })
                  .width('100%')
              }

              // 相关搜索栏 Widget (截图 2)
              Row() {
                Text('🔍 ')
                  .fontSize(13)
                Text(post.relatedSearch ?? `相关搜索 · ${this.game ? this.game.title : '链在一起'} 卡关求助`)
                  .fontSize(12)
                  .fontColor('#333333')
                Blank()
                Text('去搜索 >')
                  .fontSize(11)
                  .fontColor('#999999')
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 10, bottom: 10 })
              .backgroundColor('#F8F8FA')
              .borderRadius(8)
              .margin({ left: 16, right: 16, top: 14 })

              // 游戏主题 Chip 标签 (截图 2: 链在一起)
              Row() {
                Text('🔥 ')
                  .fontSize(10)
                Text(this.game ? this.game.title : '链在一起')
                  .fontSize(11)
                  .fontColor('#4A4A4A')
              }
              .padding({ left: 8, right: 10, top: 4, bottom: 4 })
              .backgroundColor('#F0F0F2')
              .borderRadius(6)
              .margin({ left: 16, top: 10 })

              // 发布时间与 IP 属地 (截图 2: 2天前·湖北)
              Text(`${post.postDate ?? (post.timeAgo + ' · ' + (post.location ?? '湖北'))}`)
                .fontSize(11)
                .fontColor('#B0B0B0')
                .margin({ left: 16, right: 16, top: 10, bottom: 16 })
                .width('100%')

              Divider().color('#F5F5F7').strokeWidth(8)

              // 评论区域 (截图 2 底部评论入口)
              Column() {
                Row() {
                  Text(`评论 ${post.comments ? post.comments.length : post.commentsCount}`)
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

                this.CommentsListBuilder(post)
              }
              .width('100%')

            } else {
              // 2. "评论" Tab 视图 (顶部无留白，紧贴页面)
              Column() {
                Row() {
                  Text(`评论 ${post.comments ? post.comments.length : post.commentsCount}`)
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

                this.CommentsListBuilder(post)
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .align(Alignment.Top)
        .layoutWeight(1)
        .width('100%')

        // 底部固定操作栏 (支持向玩家回复评论及取消模式)
        Column() {
          if (this.replyTargetUser) {
            Row() {
              Text(`正在回复 @${this.replyTargetUser}`)
                .fontSize(11)
                .fontColor('#3399FF')
              Blank()
              Text('✕ 取消')
                .fontSize(11)
                .fontColor('#999999')
                .onClick(() => {
                  this.replyingCommentId = '';
                  this.replyTargetUser = '';
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 4, bottom: 4 })
            .backgroundColor('#EBF5FF')
          }

          Row() {
            TextInput({
              placeholder: this.replyTargetUser ? `回复 @${this.replyTargetUser}：` : '来说点什么吧！',
              text: $$this.newCommentInput,
            })
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

                  if (this.replyingCommentId && this.replyTargetUser) {
                    // 玩家回复已有评论/回复
                    const targetComment = post.comments.find(
                      (c: PostComment) => c.id === this.replyingCommentId
                    );
                    if (targetComment) {
                      const newReply: PostCommentReply = {
                        authorName: '盒友999',
                        content: this.newCommentInput.trim(),
                        timeAgo: '刚刚',
                        location: '湖北',
                        targetUser: this.replyTargetUser,
                      };
                      if (!targetComment.replies) {
                        targetComment.replies = [];
                      }
                      if (targetComment.reply && targetComment.replies.length === 0) {
                        targetComment.replies.push(targetComment.reply);
                      }
                      targetComment.replies.push(newReply);
                    }
                    this.replyingCommentId = '';
                    this.replyTargetUser = '';
                  } else {
                    // 发布独立新评论
                    post.comments.push({
                      id: `c-${Date.now()}`,
                      authorName: '盒友999',
                      authorAvatarBg: '#FF9500',
                      authorLevel: 'Lv.6',
                      timeAgo: '刚刚',
                      location: '湖北',
                      content: this.newCommentInput.trim(),
                      likesCount: 0,
                    });
                  }
                  post.commentsCount = post.comments.length;
                  this.newCommentInput = '';
                  this.postDetailTab = 1;
                }
              })

            Row() {
              Text('👍')
                .fontSize(16)
                .fontColor(this.isCurrentPostLiked ? '#FF9500' : '#666666')
              Text(` ${this.currentPostLikes}`)
                .fontSize(12)
                .fontColor(this.isCurrentPostLiked ? '#FF9500' : '#666666')
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
              Text(this.isCurrentPostFavorited ? '★' : '⭐')
                .fontSize(16)
                .fontColor(this.isCurrentPostFavorited ? '#FF9500' : '#666666')
              Text(this.isCurrentPostFavorited ? ' 已收藏' : ' 收藏')
                .fontSize(12)
                .fontColor(this.isCurrentPostFavorited ? '#FF9500' : '#666666')
            }
            .margin({ left: 14 })
            .onClick(() => {
              this.isCurrentPostFavorited = !this.isCurrentPostFavorited;
            })

            Row() {
              Text('💬')
                .fontSize(16)
                .fontColor('#666666')
              Text(` ${post.comments ? post.comments.length : post.commentsCount}`)
                .fontSize(12)
                .fontColor('#666666')
            }
            .margin({ left: 14 })
            .onClick(() => {
              this.postDetailTab = 1;
              try {
                this.postScroller.scrollTo({ xOffset: 0, yOffset: 0 });
              } catch {
              }
            })
          }
          .width('100%')
          .padding({ left: 14, right: 14, top: 8, bottom: 8 })
          .backgroundColor(Color.White)
        }
        .width('100%')
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
        ForEach(getGameDatabaseItemsSync(gameId), (item: DatabaseItem) => {
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
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 14, right: 14, top: 10, bottom: 90 })
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

        ForEach(getGameRegionPricesSync(gameId), (region: RegionPrice) => {
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
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 14, right: 14, top: 10, bottom: 90 })
  }

  @Builder
  RecordContentBuilder(gameId: string) {
    Column() {
      // 1. 玩家主卡片 (名片风格)
      Column() {
        Row() {
          Text('盒')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .width(44)
            .height(44)
            .borderRadius(22)
            .backgroundColor('#2BA6A6')
            .textAlign(TextAlign.Center)

          Column() {
            Row() {
              Text('盒友9527 / 帕鲁黑工王')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
              Text('Lv.55')
                .fontSize(9)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .backgroundColor('#FF7A00')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(4)
                .margin({ left: 8 })
            }

            Text('已连续打工 324 天 · 世界等级 5')
              .fontSize(11)
              .fontColor('#888888')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
          .layoutWeight(1)
        }
        .width('100%')

        Divider().color('#F5F5F7').strokeWidth(1).margin({ top: 12, bottom: 12 })

        // 核心探索指标
        Row() {
          Column() {
            Text('94.8%')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Text('地图探索率')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)

          Column() {
            Text('1,482 只')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Text('帕鲁捕获总量')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)

          Column() {
            Text('4 / 4')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#2BA6A6')
            Text('据点基地满载')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)

          Column() {
            Text('5 / 5')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF7A00')
            Text('高塔 BOSS 通关')
              .fontSize(10)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .padding(14)
      .backgroundColor(Color.White)
      .borderRadius(12)

      // 2. 顶尖四金对战阵容
      Column() {
        Row() {
          Text('⚔️ 个人顶尖主力阵容 (四金战队)')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Blank()
          Text('配置管理 >')
            .fontSize(11)
            .fontColor('#999999')
        }
        .width('100%')
        .margin({ bottom: 10 })

        Grid() {
          GridItem() {
            Column() {
              Row() {
                Text('🐉')
                  .fontSize(22)
                Column() {
                  Text('空涡龙')
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('Lv.55 · 传说/脑筋/凶猛/神速')
                    .fontSize(9)
                    .fontColor('#FF7A00')
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 6 })
              }
              .width('100%')
              Row() {
                Text('攻击: 1,840')
                  .fontSize(10)
                  .fontColor('#666666')
                Blank()
                Text('飞行 3300')
                  .fontSize(10)
                  .fontColor('#2BA6A6')
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .padding(10)
            .backgroundColor('#F8F9FA')
            .borderRadius(8)
          }

          GridItem() {
            Column() {
              Row() {
                Text('❄️')
                  .fontSize(22)
                Column() {
                  Text('唤冬兽')
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('Lv.55 · 冰帝/脑筋/绝代/传说')
                    .fontSize(9)
                    .fontColor('#3399FF')
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 6 })
              }
              .width('100%')
              Row() {
                Text('攻击: 1,720')
                  .fontSize(10)
                  .fontColor('#666666')
                Blank()
                Text('冷却 Lv.4')
                  .fontSize(10)
                  .fontColor('#3399FF')
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .padding(10)
            .backgroundColor('#F8F9FA')
            .borderRadius(8)
          }

          GridItem() {
            Column() {
              Row() {
                Text('🗿')
                  .fontSize(22)
                Column() {
                  Text('阿努比斯')
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('Lv.55 · 工匠/认真/稀有/社畜')
                    .fontSize(9)
                    .fontColor('#8B572A')
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 6 })
              }
              .width('100%')
              Row() {
                Text('手工: Lv.4')
                  .fontSize(10)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E65100')
                Blank()
                Text('采矿 Lv.3')
                  .fontSize(10)
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .padding(10)
            .backgroundColor('#F8F9FA')
            .borderRadius(8)
          }

          GridItem() {
            Column() {
              Row() {
                Text('⚡')
                  .fontSize(22)
                Column() {
                  Text('波鲁杰克斯')
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1A1A1A')
                  Text('Lv.55 · 电帝/充能/认真/神速')
                    .fontSize(9)
                    .fontColor('#F5A623')
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 6 })
              }
              .width('100%')
              Row() {
                Text('发电: Lv.4')
                  .fontSize(10)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#F5A623')
                Blank()
                Text('搬运 Lv.3')
                  .fontSize(10)
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .padding(10)
            .backgroundColor('#F8F9FA')
            .borderRadius(8)
          }
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(8)
        .rowsGap(8)
        .width('100%')
      }
      .width('100%')
      .padding(14)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .margin({ top: 12 })

      // 3. 游戏成就墙
      Column() {
        Row() {
          Text('🏆 帕鲁黑工勋章墙 (4/4)')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
        }
        .width('100%')
        .margin({ bottom: 10 })

        Row({ space: 8 }) {
          Column() {
            Text('👑')
              .fontSize(24)
            Text('百兽全通')
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ top: 4 })
            Text('解锁全部图鉴')
              .fontSize(9)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)
          .padding(8)
          .backgroundColor('#FFFBF0')
          .borderRadius(8)
          .alignItems(HorizontalAlign.Center)

          Column() {
            Text('⚡')
              .fontSize(24)
            Text('黑心资本家')
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ top: 4 })
            Text('无修打工500h')
              .fontSize(9)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)
          .padding(8)
          .backgroundColor('#F0FBF6')
          .borderRadius(8)
          .alignItems(HorizontalAlign.Center)

          Column() {
            Text('🥚')
              .fontSize(24)
            Text('欧皇孵蛋')
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .margin({ top: 4 })
            Text('孵化2800蛋')
              .fontSize(9)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)
          .padding(8)
          .backgroundColor('#FDF0F5')
          .borderRadius(8)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
      }
      .width('100%')
      .padding(14)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .margin({ top: 12 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 14, right: 14, top: 10, bottom: 90 })
  }

  @Builder
  PokedexContentBuilder(gameId: string) {
    Column() {
      // 快速筛选 Tab
      Row({ space: 8 }) {
        ForEach(['全部', '🔥 战斗主力', '🔨 基地打工', '🏇 疾速坐骑'], (tab: string) => {
          Text(tab)
            .fontSize(12)
            .fontWeight(this.pokedexFilter === tab ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.pokedexFilter === tab ? Color.White : '#4A4A4A')
            .backgroundColor(this.pokedexFilter === tab ? '#2BA6A6' : '#FFFFFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(14)
            .onClick(() => (this.pokedexFilter = tab))
        })
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 帕鲁图鉴列表 (两列卡片)
      Grid() {
        // No.110 空涡龙
        GridItem() {
          Column() {
            Row() {
              Text('No.110')
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor('#999999')
              Blank()
              Text('神兽')
                .fontSize(9)
                .fontColor(Color.White)
                .backgroundColor('#FF7A00')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(3)
            }
            .width('100%')

            Row() {
              Text('🐉')
                .fontSize(32)
              Column() {
                Text('空涡龙')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Row() {
                  Text('龙')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#8B3A2A')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(2)
                  Text('飞行')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#3399FF')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(2)
                    .margin({ left: 4 })
                }
                .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
            }
            .width('100%')
            .margin({ top: 4 })

            Text('工作: 采矿 Lv.3 / 搬运 Lv.3')
              .fontSize(10)
              .fontColor('#666666')
              .margin({ top: 6 })
              .width('100%')

            Text('速度 3300 全服极速')
              .fontSize(10)
              .fontColor('#2BA6A6')
              .margin({ top: 2 })
              .width('100%')
          }
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }

        // No.102 唤冬兽
        GridItem() {
          Column() {
            Row() {
              Text('No.102')
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor('#999999')
              Blank()
              Text('神兽')
                .fontSize(9)
                .fontColor(Color.White)
                .backgroundColor('#3399FF')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(3)
            }
            .width('100%')

            Row() {
              Text('❄️')
                .fontSize(32)
              Column() {
                Text('唤冬兽')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Row() {
                  Text('冰系')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#00BFFF')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(2)
                }
                .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
            }
            .width('100%')
            .margin({ top: 4 })

            Text('工作: 冷却 Lv.4 (永久制冷)')
              .fontSize(10)
              .fontColor('#666666')
              .margin({ top: 6 })
              .width('100%')

            Text('技能: 绝对零度冰极暴风')
              .fontSize(10)
              .fontColor('#3399FF')
              .margin({ top: 2 })
              .width('100%')
          }
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }

        // No.100 阿努比斯
        GridItem() {
          Column() {
            Row() {
              Text('No.100')
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor('#999999')
              Blank()
              Text('打工战神')
                .fontSize(9)
                .fontColor(Color.White)
                .backgroundColor('#E65100')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(3)
            }
            .width('100%')

            Row() {
              Text('🗿')
                .fontSize(32)
              Column() {
                Text('阿努比斯')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Row() {
                  Text('地系')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#8B572A')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(2)
                }
                .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
            }
            .width('100%')
            .margin({ top: 4 })

            Text('工作: 手工 Lv.4 / 采矿 Lv.3')
              .fontSize(10)
              .fontColor('#E65100')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 6 })
              .width('100%')

            Text('特点: 手工搓球天花板')
              .fontSize(10)
              .fontColor('#666666')
              .margin({ top: 2 })
              .width('100%')
          }
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }

        // No.069 疾旋鼬
        GridItem() {
          Column() {
            Row() {
              Text('No.069')
                .fontSize(10)
                .fontWeight(FontWeight.Bold)
                .fontColor('#999999')
              Blank()
              Text('人气王')
                .fontSize(9)
                .fontColor(Color.White)
                .backgroundColor('#E91E63')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(3)
            }
            .width('100%')

            Row() {
              Text('🦦')
                .fontSize(32)
              Column() {
                Text('疾旋鼬')
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Row() {
                  Text('冰')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#00BFFF')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(2)
                  Text('龙')
                    .fontSize(9)
                    .fontColor(Color.White)
                    .backgroundColor('#8B3A2A')
                    .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                    .borderRadius(2)
                    .margin({ left: 4 })
                }
                .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
            }
            .width('100%')
            .margin({ top: 4 })

            Text('工作: 冷却 Lv.1 / 采集 Lv.1')
              .fontSize(10)
              .fontColor('#666666')
              .margin({ top: 6 })
              .width('100%')

            Text('特点: 表情包大明星，骑乘转冰伤')
              .fontSize(10)
              .fontColor('#E91E63')
              .margin({ top: 2 })
              .width('100%')
          }
          .padding(10)
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')

      // 孵蛋/配种计算器快速入口
      Row() {
        Text('🥚 帕鲁孵蛋配种计算器')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Blank()
        Text('查询最佳配种公式 >')
          .fontSize(11)
          .fontColor('#FFD700')
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#1A1A1A')
      .borderRadius(10)
      .margin({ top: 12 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 14, right: 14, top: 10, bottom: 90 })
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

          Stack({ alignContent: Alignment.Bottom }) {
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
                } else if (this.game.customTabs && this.game.customTabs.length > 0) {
                  // 3. 动态自定义 Tab 页签 (支持 战绩 / 图鉴 / 统计)
                  if (this.game.customTabs[this.detailTabIndex] === '战绩') {
                    this.RecordContentBuilder(this.game.id)
                  } else if (this.game.customTabs[this.detailTabIndex] === '图鉴') {
                    this.PokedexContentBuilder(this.game.id)
                  } else if (this.game.customTabs[this.detailTabIndex] === '数据库') {
                    this.DatabaseContentBuilder(this.game.id)
                  } else {
                    this.StatsContentBuilder(this.game.id)
                  }
                } else if (this.detailTabIndex === 2 && this.game.hasDatabaseTab) {
                  // 4. "数据库" Tab 页签
                  this.DatabaseContentBuilder(this.game.id)
                } else {
                  // 5. "统计" Tab 页签
                  this.StatsContentBuilder(this.game.id)
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(HorizontalAlign.Start)
            }
            .align(Alignment.Top)
            .scrollBar(BarState.Off)
            .width('100%')
            .height('100%')

            // 社区页专属：常驻屏幕底部固定悬浮 "参与讨论" 按钮 (截图同款)
            if (this.detailTabIndex === 1) {
              Row() {
                Text(this.game.id === 'palworld' ? '🗣️' : '👤')
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
              .margin({ bottom: 76 })
              .shadow({ radius: 8, color: 'rgba(0,0,0,0.25)', offsetY: 4 })
            }

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
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          }
          .width('100%')
          .layoutWeight(1)
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



