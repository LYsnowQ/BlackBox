import { router } from '@kit.ArkUI';
import {
  HotAuthor,
  HotComment,
  HotContentBlock,
  HotGameCard,
  HotNewsDetailData,
  HotReply,
  getHotNewsById,
} from '../../model/HotModel';
import {
  HotThemeColors,
  HotThemeMode,
  HOT_DEFAULT_THEME_MODE,
  getHotTheme,
} from './HotTheme';

/**
 * 热点新闻详情（Hot HAR 业务组件，由 entry 路由壳挂载）
 * - 默认浅色（对照 Screen/Light 图3 正文 / 图4 评论）
 * - 深色可经路由 params.themeMode 或 HOT_DEFAULT_THEME_MODE 调试
 * 组件名 HotNewsDetail，数据模型为 HotNewsDetailData，避免 ArkTS 同名冲突。
 */
@Component
export struct HotNewsDetail {
  @State detail: HotNewsDetailData | undefined = undefined;
  @State detailTabIndex: number = 0; // 0 正文 / 1 评论（勿用 tabIndex）
  @State liked: boolean = false;
  @State starred: boolean = false;
  @State themeMode: HotThemeMode = HOT_DEFAULT_THEME_MODE;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    const mode = params ? (params['themeMode'] as string) : '';
    if (mode === 'dark' || mode === 'light') {
      this.themeMode = mode as HotThemeMode;
    }
    this.detail = getHotNewsById(id);
  }

  private theme(): HotThemeColors {
    return getHotTheme(this.themeMode);
  }

  // ---------- 顶栏 ----------
  @Builder
  NavBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(28)
        .fontColor(this.theme().icon)
        .width(36)
        .textAlign(TextAlign.Center)
        .onClick(() => router.back())

      Row() {
        Column() {
          Text('正文')
            .fontSize(16)
            .fontWeight(this.detailTabIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.detailTabIndex === 0 ? this.theme().tabActive : this.theme().tabInactive)
          Row()
            .width(this.detailTabIndex === 0 ? 28 : 0)
            .height(3)
            .borderRadius(2)
            .backgroundColor(this.theme().tabIndicator)
            .margin({ top: 6 })
        }
        .onClick(() => {
          this.detailTabIndex = 0;
        })

        Column() {
          Text('评论')
            .fontSize(16)
            .fontWeight(this.detailTabIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.detailTabIndex === 1 ? this.theme().tabActive : this.theme().tabInactive)
          Row()
            .width(this.detailTabIndex === 1 ? 28 : 0)
            .height(3)
            .borderRadius(2)
            .backgroundColor(this.theme().tabIndicator)
            .margin({ top: 6 })
        }
        .margin({ left: 36 })
        .onClick(() => {
          this.detailTabIndex = 1;
        })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Text('⤴')
        .fontSize(20)
        .fontColor(this.theme().icon)
        .width(36)
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ left: 8, right: 12, top: 6, bottom: 8 })
    .alignItems(VerticalAlign.Center)
  }

  // ---------- 头像（优先真实图） ----------
  @Builder
  AvatarBuilder(author: HotAuthor, size: number) {
    if (author.avatarImg) {
      Image(author.avatarImg)
        .width(size)
        .height(size)
        .borderRadius(size / 2)
        .objectFit(ImageFit.Cover)
    } else {
      Stack({ alignContent: Alignment.Center }) {
        Text(author.avatarText)
          .fontSize(size > 36 ? 14 : 13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width(size)
      .height(size)
      .borderRadius(size / 2)
      .linearGradient({
        angle: 135,
        colors: [[author.avatarColors[0], 0], [author.avatarColors[1], 1]],
      })
    }
  }

  // ---------- 作者名 + 等级 + 时间（不含头像） ----------
  @Builder
  AuthorMetaBuilder(author: HotAuthor) {
    Column() {
      Row() {
        Text(author.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.theme().textPrimary)
        if (author.verified) {
          Text(' ✓')
            .fontSize(12)
            .fontColor(this.theme().link)
        }
        if (author.isAuthor) {
          Text(' 作者')
            .fontSize(10)
            .fontColor(this.theme().authorTagText)
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .backgroundColor(this.theme().authorTagBg)
            .borderRadius(3)
            .margin({ left: 4 })
        }
        Text(author.level)
          .fontSize(10)
          .fontColor(Color.White)
          .padding({ left: 5, right: 5, top: 1, bottom: 1 })
          .backgroundColor(author.levelColor)
          .borderRadius(4)
          .margin({ left: 6 })
      }

      Text(author.timeLocation)
        .fontSize(11)
        .fontColor(this.theme().textSecondary)
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Start)
  }

  // ---------- 正文顶栏作者行（含头像 + 关注） ----------
  @Builder
  AuthorRowBuilder(author: HotAuthor, showFollow: boolean) {
    Row() {
      this.AvatarBuilder(author, 40)

      Column() {
        this.AuthorMetaBuilder(author)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .layoutWeight(1)

      if (showFollow) {
        Row() {
          Text('+ 关注')
            .fontSize(13)
            .fontColor(this.theme().followText)
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor(this.theme().followBg === 'transparent' ? Color.Transparent : this.theme().followBg)
        .border({
          width: this.themeMode === 'dark' ? 1 : 0,
          color: this.themeMode === 'dark' ? '#4A4A4A' : Color.Transparent,
        })
        .borderRadius(16)
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  // ---------- 游戏卡片 ----------
  @Builder
  GameCardBuilder(game: HotGameCard) {
    Row() {
      Stack({ alignContent: Alignment.TopEnd }) {
        if (game.coverImg) {
          Image(game.coverImg)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .borderRadius(6)
        } else {
          Stack({ alignContent: Alignment.Center }) {
            Text(game.name.substring(0, 2))
              .fontSize(14)
              .fontColor(Color.White)
          }
          .width('100%')
          .height('100%')
          .borderRadius(6)
          .linearGradient({
            angle: 120,
            colors: [[game.gradientColors[0], 0], [game.gradientColors[1], 1]],
          })
        }

        if (game.discountLabel) {
          Text(game.discountLabel)
            .fontSize(10)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .backgroundColor('#E53935')
            .borderRadius({ topRight: 6, bottomLeft: 4 })
        }
      }
      .width(56)
      .height(56)
      .borderRadius(6)
      .clip(true)

      Column() {
        Text(game.name)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.theme().textPrimary)

        Row() {
          Text(`🔥 ${game.rating}`)
            .fontSize(12)
            .fontColor(this.theme().ratingColor)
          Text(`  🏷 ${game.priceLabel}`)
            .fontSize(12)
            .fontColor(this.theme().textSecondary)
          if (game.badge) {
            Text(` ${game.badge}`)
              .fontSize(11)
              .fontColor(this.theme().badgeLowestText)
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .backgroundColor(this.theme().badgeLowestBg)
              .borderRadius(3)
              .margin({ left: 4 })
          }
        }
        .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .layoutWeight(1)

      if (game.ownLabel) {
        Text(game.ownLabel)
          .fontSize(12)
          .fontColor(this.theme().textSecondary)
      } else if (game.favoriteLabel) {
        Text(`♡ ${game.favoriteLabel}`)
          .fontSize(12)
          .fontColor(this.theme().textSecondary)
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(this.theme().cardBg)
    .borderRadius(10)
  }

  // ---------- 正文块 ----------
  @Builder
  BlockBuilder(block: HotContentBlock) {
    if (block.type === 'paragraph' && block.text) {
      Text(block.text)
        .fontSize(16)
        .fontColor(this.theme().textPrimary)
        .lineHeight(26)
        .width('100%')
        .margin({ bottom: 14 })
    } else if (block.type === 'heading' && block.text) {
      Text(block.text)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme().textPrimary)
        .width('100%')
        .margin({ top: 6, bottom: 12 })
    } else if (block.type === 'bullet' && block.bullets) {
      Column() {
        ForEach(block.bullets, (line: string) => {
          Row() {
            Text('•')
              .fontSize(16)
              .fontColor(this.theme().bulletColor)
              .margin({ right: 8 })
            Text(line)
              .fontSize(15)
              .fontColor(this.theme().textSecondary)
              .layoutWeight(1)
              .lineHeight(24)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .margin({ bottom: 6 })
        }, (line: string) => line)
      }
      .width('100%')
      .margin({ bottom: 14 })
      .padding({ left: 4 })
    } else if (block.type === 'game' && block.game) {
      Column() {
        this.GameCardBuilder(block.game);
      }
      .width('100%')
      .margin({ bottom: 14 })
    } else if (block.type === 'image') {
      Stack({ alignContent: Alignment.BottomEnd }) {
        if (block.imageSrc) {
          // 游戏截图 / 展示图：Contain 保比例；整页价格截图同理不被 Cover 裁切
          Image(block.imageSrc)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .borderRadius(8)
        } else {
          Column() {
            Text(block.imageLabel ?? '')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('rgba(255,255,255,0.85)')
          }
          .width('100%')
          .height(180)
          .justifyContent(FlexAlign.Center)
          .linearGradient({
            angle: 120,
            colors: [
              [block.imageColors ? block.imageColors[0] : '#3A3A3A', 0],
              [block.imageColors ? block.imageColors[1] : '#1A1A1A', 1],
            ],
          })
          .borderRadius(8)
        }

        if (block.imageIndex && !block.imageSrc) {
          Text(block.imageIndex)
            .fontSize(11)
            .fontColor(Color.White)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor('rgba(0,0,0,0.45)')
            .borderRadius(10)
            .margin({ right: 10, bottom: 10 })
        }
      }
      .width('100%')
      .clip(true)
      .margin({ bottom: 14 })
    }
  }

  // ---------- 正文页 ----------
  @Builder
  ArticleBuilder(detail: HotNewsDetailData) {
    Column() {
      Text(detail.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.theme().textPrimary)
        .lineHeight(30)
        .width('100%')
        .margin({ bottom: 16 })

      this.AuthorRowBuilder(detail.author, true)

      if (detail.platforms.length > 0) {
        Row() {
          ForEach(detail.platforms, (p: string) => {
            Row() {
              Text(p === 'Steam' ? '🅢' : '🎮')
                .fontSize(12)
                .fontColor(this.theme().textPrimary)
                .margin({ right: 4 })
              Text(p)
                .fontSize(13)
                .fontColor(this.theme().textPrimary)
            }
            .padding({ left: 8, right: 10, top: 4, bottom: 4 })
            .backgroundColor(this.theme().platformBg)
            .borderRadius(6)
            .margin({ right: 8 })
          }, (p: string) => p)
        }
        .width('100%')
        .margin({ top: 16, bottom: 8 })
      }

      if (detail.gameCard) {
        Column() {
          this.GameCardBuilder(detail.gameCard);
        }
        .width('100%')
        .margin({ top: 12, bottom: 8 })
      }

      Column() {
        ForEach(detail.blocks, (block: HotContentBlock) => {
          this.BlockBuilder(block);
        }, (block: HotContentBlock) =>
          `${block.type}-${block.text ?? ''}-${block.imageLabel ?? ''}-${block.imageIndex ?? ''}-${block.game?.name ?? ''}-${block.game?.priceLabel ?? ''}`)
      }
      .width('100%')
      .margin({ top: 16 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 24 })
    .alignItems(HorizontalAlign.Start)
  }

  // ---------- 评论 ----------
  @Builder
  ReplyBuilder(reply: HotReply) {
    Row() {
      Text(`${reply.userName}：`)
        .fontSize(13)
        .fontColor(this.theme().link)
      Text(reply.content)
        .fontSize(13)
        .fontColor(this.theme().textPrimary)
        .layoutWeight(1)
    }
    .width('100%')
    .margin({ bottom: 4 })

    Text(reply.timeLocation)
      .fontSize(11)
      .fontColor(this.theme().textTertiary)
      .margin({ bottom: 6 })
  }

  @Builder
  CommentItemBuilder(comment: HotComment) {
    Row() {
      Column() {
        if (comment.isPinned) {
          Text('置顶')
            .fontSize(9)
            .fontColor(this.theme().pinText)
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
            .backgroundColor(this.theme().pinBg)
            .borderRadius(3)
            .margin({ bottom: 4 })
        }
        this.AvatarBuilder(comment.author, 36)
      }
      .width(40)
      .margin({ right: 10 })
      .alignItems(HorizontalAlign.Center)

      Column() {
        this.AuthorMetaBuilder(comment.author)

        Text(comment.content)
          .fontSize(15)
          .fontColor(this.theme().textPrimary)
          .lineHeight(24)
          .width('100%')
          .margin({ top: 8 })

        if (comment.replies && comment.replies.length > 0) {
          Column() {
            ForEach(comment.replies, (r: HotReply) => {
              this.ReplyBuilder(r);
            }, (r: HotReply) => `${comment.id}-${r.userName}-${r.content}`)
          }
          .width('100%')
          .padding(10)
          .backgroundColor(this.theme().replyBg)
          .borderRadius(8)
          .margin({ top: 10 })
          .alignItems(HorizontalAlign.Start)
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Text('👍')
          .fontSize(14)
          .fontColor(this.theme().actionIcon)
        Text(`${comment.likeCount}`)
          .fontSize(11)
          .fontColor(this.theme().textSecondary)
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ left: 8 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  CommentsBuilder(detail: HotNewsDetailData) {
    Column() {
      Row() {
        Text(`评论 ${detail.commentCount}`)
          .fontSize(14)
          .fontColor(this.theme().textSecondary)
        Blank()
        Text('热门 ▾')
          .fontSize(13)
          .fontColor(this.theme().textSecondary)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 4 })

      ForEach(detail.comments, (c: HotComment) => {
        this.CommentItemBuilder(c);
      }, (c: HotComment) => c.id)

      Text('暂无更多内容')
        .fontSize(13)
        .fontColor(this.theme().emptyText)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 24, bottom: 40 })
    }
    .width('100%')
  }

  // ---------- 底部互动栏 ----------
  @Builder
  BottomBarBuilder(detail: HotNewsDetailData) {
    Row() {
      Row() {
        Text('来说点什么吧!')
          .fontSize(13)
          .fontColor(this.theme().inputPlaceholder)
      }
      .layoutWeight(1)
      .height(36)
      .padding({ left: 14 })
      .backgroundColor(this.theme().inputBg)
      .borderRadius(18)
      .alignItems(VerticalAlign.Center)

      Column() {
        Text(this.liked ? '👍' : '👍🏻')
          .fontSize(18)
        Text(`${detail.likeCount + (this.liked ? 1 : 0)}`)
          .fontSize(11)
          .fontColor(this.theme().actionIcon)
          .margin({ top: 2 })
      }
      .width(44)
      .onClick(() => {
        this.liked = !this.liked;
      })

      Column() {
        Text(this.starred ? '★' : '☆')
          .fontSize(18)
          .fontColor(this.starred ? '#FFD54A' : this.theme().actionIcon)
        Text(`${detail.starCount + (this.starred ? 1 : 0)}`)
          .fontSize(11)
          .fontColor(this.theme().actionIcon)
          .margin({ top: 2 })
      }
      .width(44)
      .onClick(() => {
        this.starred = !this.starred;
      })

      Column() {
        Text('⚡')
          .fontSize(18)
        Text(`${detail.shareCount}`)
          .fontSize(11)
          .fontColor(this.theme().actionIcon)
          .margin({ top: 2 })
      }
      .width(44)

      Column() {
        Text('💬')
          .fontSize(18)
        Text(`${detail.commentCount}`)
          .fontSize(11)
          .fontColor(this.theme().actionIcon)
          .margin({ top: 2 })
      }
      .width(44)
      .onClick(() => {
        this.detailTabIndex = 1;
      })
    }
    .width('100%')
    .padding({ left: 12, right: 8, top: 8, bottom: 10 })
    .backgroundColor(this.theme().bottomBarBg)
    .border({ width: { top: 1 }, color: this.theme().bottomBarBorder })
  }

  @Builder
  EmptyBuilder() {
    Column() {
      Text('内容不存在或已删除')
        .fontSize(15)
        .fontColor(this.theme().textSecondary)
      Text('返回')
        .fontSize(14)
        .fontColor(this.theme().link)
        .margin({ top: 16 })
        .onClick(() => router.back())
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      this.NavBarBuilder()

      if (this.detail) {
        Scroll() {
          if (this.detailTabIndex === 0) {
            this.ArticleBuilder(this.detail)
          } else {
            this.CommentsBuilder(this.detail)
          }
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .align(Alignment.Top)

        this.BottomBarBuilder(this.detail)
      } else {
        this.EmptyBuilder()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme().pageBg)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
