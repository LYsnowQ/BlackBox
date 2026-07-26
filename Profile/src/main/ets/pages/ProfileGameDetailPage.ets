import { router } from '@kit.ArkUI';
import { LibraryGame, LowestTagType } from '../model/types/LibraryModel';
import {
  formatFollowCount,
  formatPriceYuan,
  resolveLowestTag,
} from '../model/utils/LibraryFormat';
import { getLibraryGameByIdSync } from '../api/LibraryApi';

/**
 * 个人库游戏详情（Profile 自包含，不与 gamelibrary 联动）
 * 入参：router params { id: string } — 使用 LibraryGame.id（lg1…）
 * 由 entry 壳 pages/Profile/GameDetail 挂载
 *
 * UI 参考游戏库详情框架：顶栏 / 封面 / 价格 / 标签 / 统计 / 简介 / 底部操作
 * 数据全部来自 Profile LibraryMock。
 */
@Component
export struct ProfileGameDetailPage {
  @State game: LibraryGame | undefined = undefined;
  @State tabIndex: number = 0;
  @State wishlisted: boolean = false;
  @State favorited: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    this.game = getLibraryGameByIdSync(id);
    if (this.game !== undefined) {
      this.wishlisted = this.game.inWishlist;
    }
  }

  private formatHours(h: number): string {
    if (h <= 0) {
      return '0h';
    }
    if (h === Math.floor(h)) {
      return `${Math.floor(h)}h`;
    }
    return `${h.toFixed(1)}h`;
  }

  private lowestTagLabel(tag: LowestTagType): string {
    if (tag === 'newLowest') {
      return '新史低';
    }
    if (tag === 'lowest') {
      return '史低';
    }
    return '';
  }

  private statusLabel(g: LibraryGame): string {
    if (g.unreleased === true) {
      return g.releaseLabel !== undefined && g.releaseLabel.length > 0
        ? g.releaseLabel
        : '未发售';
    }
    if (g.owned) {
      return '已拥有';
    }
    if (g.inWishlist) {
      return '心愿单';
    }
    return '未拥有';
  }

  @Builder
  HeaderBuilder(g: LibraryGame | undefined) {
    Row() {
      Text('‹')
        .fontSize(28)
        .fontColor('#1A1A1A')
        .width(36)
        .onClick(() => router.back())

      Text(g !== undefined ? g.title : '游戏详情')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Text('⇧')
          .fontSize(18)
          .fontColor('#1A1A1A')
          .margin({ right: 12 })
        Text('⋯')
          .fontSize(18)
          .fontColor('#1A1A1A')
      }
      .width(56)
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
    .backgroundColor(Color.White)
  }

  @Builder
  BannerBuilder(g: LibraryGame) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Column() {
        Text(g.title.substring(0, 1))
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor('rgba(255,255,255,0.85)')
      }
      .width('100%')
      .height(220)
      .justifyContent(FlexAlign.Center)
      .linearGradient({
        angle: 135,
        colors: [
          [g.coverColors[0], 0],
          [g.coverColors[1], 1],
        ],
      })

      Row() {
        Text(this.statusLabel(g))
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .borderRadius(4)
          .backgroundColor('rgba(0,0,0,0.4)')
      }
      .width('100%')
      .padding({ left: 14, bottom: 14 })
    }
    .width('100%')
    .height(220)
    .clip(true)
  }

  @Builder
  PriceBarBuilder(g: LibraryGame) {
    Row() {
      Row() {
        if (g.unreleased === true) {
          Text(g.releaseLabel !== undefined && g.releaseLabel.length > 0
            ? g.releaseLabel
            : '即将宣布')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        } else {
          Text('¥')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text(`${g.price !== undefined ? g.price : 0}`)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)

          if (g.originalPrice !== undefined &&
            g.price !== undefined &&
            g.originalPrice > g.price) {
            Text(formatPriceYuan(g.originalPrice))
              .fontSize(12)
              .fontColor('rgba(255,255,255,0.65)')
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ left: 8 })
          }

          if (resolveLowestTag(g) !== 'none') {
            Text(this.lowestTagLabel(resolveLowestTag(g)))
              .fontSize(10)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.White)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(3)
              .backgroundColor(resolveLowestTag(g) === 'newLowest' ? '#1A7A4C' : '#2BC48A')
              .margin({ left: 8 })
          }
        }
      }
      .alignItems(VerticalAlign.Bottom)

      Blank()

      if (g.appScore !== undefined) {
        Column() {
          Text(g.appScore.toFixed(1))
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#2BC48A')
          Text('小黑盒评分')
            .fontSize(10)
            .fontColor('rgba(255,255,255,0.65)')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.End)
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#262930')
  }

  @Builder
  TitleBlockBuilder(g: LibraryGame) {
    Column() {
      Text(g.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')

      Flex({ wrap: FlexWrap.Wrap }) {
        Text(this.statusLabel(g))
          .fontSize(11)
          .fontColor('#2BC48A')
          .backgroundColor('rgba(43,196,138,0.10)')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(6)
          .margin({ right: 6, top: 8 })

        if (g.owned) {
          Text(`总时长 ${this.formatHours(g.totalHours)}`)
            .fontSize(11)
            .fontColor('#666666')
            .backgroundColor('#F2F2F5')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(6)
            .margin({ right: 6, top: 8 })

          Text(`两周 ${this.formatHours(g.twoWeekHours)}`)
            .fontSize(11)
            .fontColor('#666666')
            .backgroundColor('#F2F2F5')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(6)
            .margin({ right: 6, top: 8 })
        }

        if (g.myRating !== undefined) {
          Text(`我的评分 ${g.myRating.toFixed(1)}`)
            .fontSize(11)
            .fontColor('#C47B00')
            .backgroundColor('#FFF3D6')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(6)
            .margin({ right: 6, top: 8 })
        }

        if (g.onDiscount) {
          Text('折扣中')
            .fontSize(11)
            .fontColor('#FF5A5A')
            .backgroundColor('#FFF0F0')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(6)
            .margin({ right: 6, top: 8 })
        }

        if (g.inSteamWishlist) {
          Text('Steam 愿望单')
            .fontSize(11)
            .fontColor('#4A90D9')
            .backgroundColor('#EAF3FF')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(6)
            .margin({ right: 6, top: 8 })
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 8 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  StatCellBuilder(value: string, label: string) {
    Column() {
      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
      Text(label)
        .fontSize(10)
        .fontColor('#999999')
        .margin({ top: 4 })
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .padding({ top: 10, bottom: 10 })
  }

  @Builder
  StatsBuilder(g: LibraryGame) {
    Column() {
      Text('个人数据')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .width('100%')
        .margin({ bottom: 4 })

      Row() {
        this.StatCellBuilder(this.formatHours(g.totalHours), '总游戏时长')
        this.StatCellBuilder(this.formatHours(g.twoWeekHours), '近两周')
        this.StatCellBuilder(
          `${g.achievementUnlocked}/${g.achievementTotal}`,
          '成就进度'
        )
      }
      .width('100%')

      Row() {
        this.StatCellBuilder(
          g.appScore !== undefined ? g.appScore.toFixed(1) : '—',
          '小黑盒评分'
        )
        this.StatCellBuilder(
          g.myRating !== undefined ? g.myRating.toFixed(1) : '—',
          '我的评分'
        )
        this.StatCellBuilder(
          g.followCount !== undefined ? formatFollowCount(g.followCount) : '—',
          '关注人数'
        )
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .margin({ top: 8 })
    .backgroundColor(Color.White)
    .borderRadius(12)
  }

  @Builder
  IntroBuilder(g: LibraryGame) {
    Column() {
      Text('简介')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .width('100%')

      Text(this.buildIntro(g))
        .fontSize(14)
        .fontColor('#555555')
        .lineHeight(22)
        .width('100%')
        .margin({ top: 10 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .margin({ top: 8 })
    .backgroundColor(Color.White)
    .borderRadius(12)
    .alignItems(HorizontalAlign.Start)
  }

  private buildIntro(g: LibraryGame): string {
    const parts: string[] = [];
    parts.push(`《${g.title}》来自你的个人游戏库 mock 数据。`);
    if (g.owned) {
      parts.push(
        `你已拥有本作品，累计游玩 ${this.formatHours(g.totalHours)}，`
          + `近两周 ${this.formatHours(g.twoWeekHours)}。`
      );
      if (g.achievementTotal > 0) {
        parts.push(
          `成就进度 ${g.achievementUnlocked}/${g.achievementTotal}`
            + (g.achievementUnlocked === g.achievementTotal ? '（已完美通关）。' : '。')
        );
      }
    } else if (g.inWishlist) {
      parts.push('本作品在你的心愿单中。');
      if (g.unreleased === true) {
        parts.push(
          `尚未发售（${g.releaseLabel !== undefined ? g.releaseLabel : '时间待定'}）。`
        );
      } else if (g.price !== undefined) {
        parts.push(`当前展示价 ${formatPriceYuan(g.price)}。`);
      }
    }
    if (g.myRating !== undefined) {
      parts.push(`你给出了 ${g.myRating.toFixed(1)} 分。`);
    }
    parts.push('本页为 Profile 模块独立详情，不与游戏库 HAR 共享数据或路由。');
    let text = '';
    for (let i = 0; i < parts.length; i++) {
      if (i > 0) {
        text += ' ';
      }
      text += parts[i];
    }
    return text;
  }

  @Builder
  TabBarBuilder() {
    Row() {
      this.TabItemBuilder('概览', 0)
      this.TabItemBuilder('数据', 1)
      this.TabItemBuilder('关于', 2)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 4 })
    .backgroundColor(Color.White)
  }

  @Builder
  TabItemBuilder(name: string, index: number) {
    Text(name)
      .fontSize(14)
      .fontWeight(this.tabIndex === index ? FontWeight.Bold : FontWeight.Normal)
      .fontColor(this.tabIndex === index ? Color.White : '#666666')
      .backgroundColor(this.tabIndex === index ? '#1A1A1A' : Color.Transparent)
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .borderRadius(6)
      .margin({ right: 8 })
      .onClick(() => {
        this.tabIndex = index;
      })
  }

  @Builder
  BottomBarBuilder(g: LibraryGame) {
    Row() {
      Column() {
        Text(this.favorited ? '★' : '☆')
          .fontSize(18)
          .fontColor(this.favorited ? '#F5A623' : '#666666')
        Text('收藏')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
      }
      .width(48)
      .onClick(() => {
        this.favorited = !this.favorited;
      })

      Column() {
        Text(this.wishlisted ? '♥' : '♡')
          .fontSize(18)
          .fontColor(this.wishlisted ? '#FF3B30' : '#666666')
        Text('心愿')
          .fontSize(10)
          .fontColor('#999999')
          .margin({ top: 2 })
      }
      .width(48)
      .margin({ left: 4 })
      .onClick(() => {
        this.wishlisted = !this.wishlisted;
      })

      Blank()

      if (g.owned) {
        Text('已在库中')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .padding({ left: 28, right: 28, top: 12, bottom: 12 })
          .borderRadius(22)
          .backgroundColor('#2BC48A')
      } else if (g.unreleased === true) {
        Text('预约提醒')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .padding({ left: 28, right: 28, top: 12, bottom: 12 })
          .borderRadius(22)
          .backgroundColor('#1A1A1A')
      } else {
        Text(g.price !== undefined
          ? `购买 ${formatPriceYuan(g.price)}`
          : '查看价格')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .padding({ left: 28, right: 28, top: 12, bottom: 12 })
          .borderRadius(22)
          .backgroundColor('#1A1A1A')
      }
    }
    .width('100%')
    .padding({ left: 12, right: 16, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .border({ width: { top: 0.5 }, color: '#F0F0F0' })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  EmptyBuilder() {
    Column({ space: 8 }) {
      Text('未找到该游戏')
        .fontSize(15)
        .fontColor('#999999')
      Text('返回个人库')
        .fontSize(13)
        .fontColor('#2BC48A')
        .onClick(() => router.back())
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  OverviewTabBuilder(g: LibraryGame) {
    Column() {
      this.TitleBlockBuilder(g)
      this.StatsBuilder(g)
      this.IntroBuilder(g)
    }
    .width('100%')
  }

  @Builder
  DataTabBuilder(g: LibraryGame) {
    Column() {
      this.StatsBuilder(g)

      Column() {
        Text('成就')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .width('100%')

        Row() {
          Text(`${g.achievementUnlocked}`)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(
              g.achievementTotal > 0 &&
                g.achievementUnlocked === g.achievementTotal
                ? '#2BC48A'
                : '#1A1A1A'
            )
          Text(` / ${g.achievementTotal}`)
            .fontSize(16)
            .fontColor('#B0B0B0')
            .margin({ left: 4, bottom: 2 })
        }
        .margin({ top: 12 })
        .alignItems(VerticalAlign.Bottom)

        // 简易进度条
        Stack({ alignContent: Alignment.Start }) {
          Row()
            .width('100%')
            .height(8)
            .borderRadius(4)
            .backgroundColor('#EEEEF0')

          Row()
            .width(g.achievementTotal > 0
              ? `${(g.achievementUnlocked / g.achievementTotal) * 100}%`
              : '0%')
            .height(8)
            .borderRadius(4)
            .linearGradient({
              angle: 90,
              colors: [
                ['#2BC48A', 0],
                ['#F5A623', 1],
              ],
            })
        }
        .width('100%')
        .height(8)
        .margin({ top: 14 })

        Text(
          g.achievementTotal > 0 &&
            g.achievementUnlocked === g.achievementTotal
            ? '已达成全部成就 · 完美通关'
            : '继续游玩以解锁更多成就（mock）'
        )
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 10 })
          .width('100%')
      }
      .width('100%')
      .padding(16)
      .margin({ top: 8 })
      .backgroundColor(Color.White)
      .borderRadius(12)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 0, right: 0, top: 8 })
  }

  @Builder
  AboutTabBuilder(g: LibraryGame) {
    Column() {
      this.IntroBuilder(g)

      Column() {
        Text('模块说明')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .width('100%')
        Text(
          '路由：ProfileRoutes.GAME_DETAIL → pages/Profile/GameDetail\n'
            + `游戏 id：${g.id}\n`
            + '数据源：Profile/LibraryMock（与 Gamelibrary 模块隔离）'
        )
          .fontSize(13)
          .fontColor('#666666')
          .lineHeight(20)
          .width('100%')
          .margin({ top: 10 })
      }
      .width('100%')
      .padding(16)
      .margin({ top: 8 })
      .backgroundColor(Color.White)
      .borderRadius(12)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
  }

  build() {
    Column() {
      this.HeaderBuilder(this.game)

      if (this.game === undefined) {
        this.EmptyBuilder()
      } else {
        Scroll() {
          Column() {
            this.BannerBuilder(this.game)
            this.PriceBarBuilder(this.game)
            this.TabBarBuilder()

            Column() {
              if (this.tabIndex === 0) {
                this.OverviewTabBuilder(this.game)
              } else if (this.tabIndex === 1) {
                this.DataTabBuilder(this.game)
              } else {
                this.AboutTabBuilder(this.game)
              }
            }
            .width('100%')
            .padding({ left: 12, right: 12, bottom: 24 })
            .backgroundColor('#F7F7F8')
          }
          .width('100%')
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor('#F7F7F8')

        this.BottomBarBuilder(this.game)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}
