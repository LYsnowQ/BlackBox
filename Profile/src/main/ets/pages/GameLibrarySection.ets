import {
  LibraryGame,
  LibraryNavKey,
  OwnedSortKey,
  WishlistFilterKey,
  LowestTagType,
} from '../model/types/LibraryModel';
import {
  formatFollowCount,
  formatPriceYuan,
  resolveLowestTag,
} from '../model/utils/LibraryFormat';
import { getLibraryGamesSync } from '../api/LibraryApi';

/**
 * 平台卡片下方 · 游戏库分区
 *
 * 水平栅格（筛选行与卡片共用）：
 *   封面列 coverW · 信息列 flex · 成就列 achieveW
 * 进度条右侧顶头显示当前指标时长；「两周内」与该数字列对齐；「成就」与成就列对齐。
 */
@Component
export struct GameLibrarySection {
  @State navKey: LibraryNavKey = 'owned';
  @State wishlistFilter: WishlistFilterKey = 'discount';
  @State ownedSort: OwnedSortKey = 'total';
  @State searchText: string = '';

  /** 封面列宽（长方形横图，与搜索框同宽同左缘） */
  private readonly coverW: number = 96;
  /** 成就列宽（与「成就」筛选按钮同宽右对齐） */
  private readonly achieveW: number = 44;
  /** 进度条右侧时长数字列宽（与「两周内」按钮对齐） */
  private readonly hoursW: number = 44;
  /** 卡片行高（横图略扁长） */
  private readonly coverH: number = 56;

  // ── 进度条：总时长 0–300h / 两周 0–100h，绿→橙 ──

  private progressRatio(hours: number, cap: number): number {
    if (hours <= 0) {
      return 0;
    }
    if (hours >= cap) {
      return 1;
    }
    return hours / cap;
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

  /** 名称过长时缩小字号，尽量单行完整展示 */
  private titleFontSize(title: string): number {
    const len = title.length;
    if (len <= 8) {
      return 14;
    }
    if (len <= 12) {
      return 13;
    }
    if (len <= 16) {
      return 12;
    }
    if (len <= 22) {
      return 11;
    }
    return 10;
  }

  /** 当前进度条对应的时长（总时长 or 两周内） */
  private activeHours(game: LibraryGame): number {
    return this.ownedSort === 'twoWeek' ? game.twoWeekHours : game.totalHours;
  }

  private activeCap(): number {
    return this.ownedSort === 'twoWeek' ? 100 : 300;
  }

  // ── 列表：统一走 LibraryApi ──

  private filteredList(): LibraryGame[] {
    return getLibraryGamesSync({
      nav: this.navKey,
      wishlistFilter: this.wishlistFilter,
      ownedSort: this.ownedSort,
      keyword: this.searchText,
    });
  }

  private onNav(key: LibraryNavKey): void {
    this.navKey = key;
    this.searchText = '';
    if (key === 'owned' || key === 'perfect') {
      this.ownedSort = 'total';
    }
  }

  // ── 主导航：四钮紧贴 + 分隔线 ──

  @Builder
  MainNavBuilder() {
    Row() {
      this.NavCellBuilder('心愿单', 'wishlist', false)
      Divider()
        .vertical(true)
        .color('#E5E5E8')
        .strokeWidth(0.5)
        .height(14)
      this.NavCellBuilder('拥有游戏', 'owned', true)
      Divider()
        .vertical(true)
        .color('#E5E5E8')
        .strokeWidth(0.5)
        .height(14)
      this.NavCellBuilder('完美通关', 'perfect', false)
      Divider()
        .vertical(true)
        .color('#E5E5E8')
        .strokeWidth(0.5)
        .height(14)
      this.NavCellBuilder('我的评分', 'rated', false)
    }
    .width('100%')
    .height(36)
    .borderRadius(13)
    .border({ width: 0.5, color: '#E0E0E4' })
    .clip(true)
    .backgroundColor('#FFFFFF')
  }

  @Builder
  NavCellBuilder(label: string, key: LibraryNavKey, showSteam: boolean) {
    Row({ space: 3 }) {
      if (showSteam) {
        Text('◈')
          .fontSize(10)
          .fontColor(this.navKey === key ? '#2BC48A' : '#999999')
      }
      Text(label)
        .fontSize(11)
        .fontWeight(this.navKey === key ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.navKey === key ? '#2BC48A' : '#666666')
        .maxLines(1)
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor(this.navKey === key ? 'rgba(43,196,138,0.08)' : Color.Transparent)
    .onClick(() => this.onNav(key))
  }

  // ── 二级筛选 ──

  @Builder
  FilterRowBuilder() {
    if (this.navKey === 'wishlist') {
      this.WishlistFilterBuilder()
    } else if (this.navKey === 'owned' || this.navKey === 'perfect') {
      this.OwnedFilterBuilder()
    }
  }

  @Builder
  WishlistFilterBuilder() {
    Row() {
      Text('正在折扣')
        .fontSize(11)
        .fontWeight(this.wishlistFilter === 'discount' ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.wishlistFilter === 'discount' ? '#2BC48A' : '#999999')
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
        .borderRadius(12)
        .backgroundColor(this.wishlistFilter === 'discount' ? 'rgba(43,196,138,0.10)' : 'rgba(0,0,0,0.03)')
        .margin({ right: 8 })
        .onClick(() => {
          this.wishlistFilter = 'discount';
        })

      Text('史低')
        .fontSize(11)
        .fontWeight(this.wishlistFilter === 'lowest' ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.wishlistFilter === 'lowest' ? '#2BC48A' : '#999999')
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
        .borderRadius(12)
        .backgroundColor(this.wishlistFilter === 'lowest' ? 'rgba(43,196,138,0.10)' : 'rgba(0,0,0,0.03)')
        .margin({ right: 8 })
        .onClick(() => {
          this.wishlistFilter = 'lowest';
        })

      Text('steam愿望单')
        .fontSize(11)
        .fontWeight(this.wishlistFilter === 'steam' ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.wishlistFilter === 'steam' ? '#2BC48A' : '#999999')
        .padding({ left: 10, right: 10, top: 5, bottom: 5 })
        .borderRadius(12)
        .backgroundColor(this.wishlistFilter === 'steam' ? 'rgba(43,196,138,0.10)' : 'rgba(0,0,0,0.03)')
        .onClick(() => {
          this.wishlistFilter = 'steam';
        })
    }
    .width('100%')
    .height(32)
    .margin({ top: 10 })
    .justifyContent(FlexAlign.Start)
  }

  /**
   * 拥有 / 完美通关 筛选行
   * 栅格与卡片一致：搜索(封面宽) | 总时长…两周内(信息区) | 成就(成就列)
   */
  @Builder
  OwnedFilterBuilder() {
    Row() {
      // 搜索框：宽=封面，左缘与图片左缘对齐
      TextInput({ placeholder: '搜索', text: this.searchText })
        .width(this.coverW)
        .height(28)
        .fontSize(10)
        .fontColor('#1A1A1A')
        .placeholderColor('#B0B0B0')
        .placeholderFont({ size: 10 })
        .backgroundColor('#F0F0F2')
        .borderRadius(14)
        .padding({ left: 10, right: 10 })
        .onChange((v: string) => {
          this.searchText = v;
        })

      // 信息区：总时长靠左 · 两周内靠右（与进度条右侧数字列对齐）
      Row() {
        Text('总时长')
          .fontSize(11)
          .fontWeight(this.ownedSort === 'total' ? FontWeight.Medium : FontWeight.Normal)
          .fontColor(this.ownedSort === 'total' ? '#2BC48A' : '#999999')
          .padding({ left: 8, right: 4, top: 4, bottom: 4 })
          .onClick(() => {
            this.ownedSort = 'total';
          })

        Blank()

        // 与进度条右侧 hoursW 列垂直对齐
        Text('两周内')
          .fontSize(11)
          .fontWeight(this.ownedSort === 'twoWeek' ? FontWeight.Medium : FontWeight.Normal)
          .fontColor(this.ownedSort === 'twoWeek' ? '#2BC48A' : '#999999')
          .width(this.hoursW)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.ownedSort = 'twoWeek';
          })
      }
      .layoutWeight(1)
      .padding({ left: 10 })
      .alignItems(VerticalAlign.Center)

      // 成就：与成就数据列同宽居中对齐
      Text('成就')
        .fontSize(11)
        .fontWeight(this.ownedSort === 'achievement' ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.ownedSort === 'achievement' ? '#2BC48A' : '#999999')
        .width(this.achieveW)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.ownedSort = 'achievement';
        })
    }
    .width('100%')
    .height(32)
    .margin({ top: 10 })
    .padding({ left: 12, right: 12 })
    .alignItems(VerticalAlign.Center)
  }

  // ── 游戏卡片 ──

  private isWishlistPriceMode(): boolean {
    return this.navKey === 'wishlist';
  }

  private showWishlistPriceMeta(game: LibraryGame): boolean {
    // 正在折扣 / 史低：价格行；steam 愿望单：已发售价格 or 未发售关注
    if (this.wishlistFilter === 'discount' || this.wishlistFilter === 'lowest') {
      return true;
    }
    if (this.wishlistFilter === 'steam') {
      return true;
    }
    return false;
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

  private lowestTagBg(tag: LowestTagType): string {
    // 史低：绿色；新史低：深绿色
    if (tag === 'newLowest') {
      return '#1A7A4C';
    }
    return '#2BC48A';
  }

  private scoreText(game: LibraryGame): string {
    if (game.appScore !== undefined) {
      return game.appScore.toFixed(1);
    }
    if (game.myRating !== undefined) {
      return game.myRating.toFixed(1);
    }
    return '—';
  }

  @Builder
  CoverBuilder(game: LibraryGame) {
    Column() {
      Text(game.title.substring(0, 1))
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
    }
    .width(this.coverW)
    .height(this.coverH)
    .borderRadius(6)
    .justifyContent(FlexAlign.Center)
    .clip(true)
    .linearGradient({
      angle: 135,
      colors: [
        [game.coverColors[0], 0],
        [game.coverColors[1], 1],
      ],
    })
  }

  /** 史低方形标签 */
  @Builder
  LowestTagBuilder(tag: LowestTagType) {
    if (tag === 'lowest' || tag === 'newLowest') {
      Text(this.lowestTagLabel(tag))
        .fontSize(9)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .padding({ left: 4, right: 4, top: 1, bottom: 1 })
        .borderRadius(2)
        .backgroundColor(this.lowestTagBg(tag))
        .margin({ left: 6 })
    }
  }

  /**
   * 心愿单价格行：
   * 左：现价 + 原价(删除线) + 可选史低标签
   * 右：评分顶格同行
   * 未发售（steam）：左 releaseLabel，右 爱心+关注人数(红)
   */
  @Builder
  WishlistMetaRowBuilder(game: LibraryGame) {
    if (this.wishlistFilter === 'steam' && game.unreleased === true) {
      Row() {
        Text(game.releaseLabel !== undefined && game.releaseLabel.length > 0
          ? game.releaseLabel
          : '即将宣布')
          .fontSize(12)
          .fontColor('#999999')
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 3 }) {
          Text('♥')
            .fontSize(12)
            .fontColor('#FF3B30')
          Text(formatFollowCount(game.followCount !== undefined ? game.followCount : 0))
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FF3B30')
        }
      }
      .width('100%')
      .margin({ top: 8 })
      .alignItems(VerticalAlign.Center)
    } else {
      Row() {
        Row() {
          Text(formatPriceYuan(game.price !== undefined ? game.price : 0))
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')

          if (game.originalPrice !== undefined &&
            game.price !== undefined &&
            game.originalPrice > game.price) {
            Text(formatPriceYuan(game.originalPrice))
              .fontSize(11)
              .fontColor('#B0B0B0')
              .decoration({ type: TextDecorationType.LineThrough, color: '#B0B0B0' })
              .margin({ left: 6 })
          }

          this.LowestTagBuilder(resolveLowestTag(game))
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Center)

        // 右侧顶格：小黑盒评分
        Text(this.scoreText(game))
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2BC48A')
      }
      .width('100%')
      .margin({ top: 8 })
      .alignItems(VerticalAlign.Center)
    }
  }

  /** 拥有 / 完美通关 / 评分：进度条 + 时长 + 成就列 */
  @Builder
  OwnedMetaBuilder(game: LibraryGame) {
    if (game.myRating !== undefined && this.navKey === 'rated') {
      Text(`${game.myRating.toFixed(1)} 分`)
        .fontSize(11)
        .fontColor('#2BC48A')
        .margin({ top: 3 })
        .width('100%')
    }

    Row() {
      Stack({ alignContent: Alignment.Start }) {
        Row()
          .width('100%')
          .height(5)
          .borderRadius(2.5)
          .backgroundColor('#EEEEF0')

        Row()
          .width(`${this.progressRatio(this.activeHours(game), this.activeCap()) * 100}%`)
          .height(5)
          .borderRadius(2.5)
          .linearGradient({
            angle: 90,
            colors: [
              ['#2BC48A', 0],
              ['#F5A623', 1],
            ],
          })
      }
      .layoutWeight(1)
      .height(5)

      Text(this.formatHours(this.activeHours(game)))
        .fontSize(11)
        .fontColor('#666666')
        .width(this.hoursW)
        .textAlign(TextAlign.End)
        .margin({ left: 6 })
    }
    .width('100%')
    .margin({ top: 8 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  GameCardBuilder(game: LibraryGame) {
    Row() {
      this.CoverBuilder(game)

      Column() {
        Text(game.title)
          .fontSize(this.titleFontSize(game.title))
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        if (this.isWishlistPriceMode() && this.showWishlistPriceMeta(game)) {
          this.WishlistMetaRowBuilder(game)
        } else {
          this.OwnedMetaBuilder(game)
        }
      }
      .layoutWeight(1)
      .padding({ left: 10, right: this.isWishlistPriceMode() ? 0 : 4 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .constraintSize({ minHeight: this.coverH })

      // 心愿单价格模式不显示成就列；右侧评分已在 meta 行顶格
      if (!this.isWishlistPriceMode()) {
        Column({ space: 2 }) {
          Text(`${game.achievementUnlocked}`)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor(
              game.achievementTotal > 0 &&
                game.achievementUnlocked === game.achievementTotal
                ? '#2BC48A'
                : '#1A1A1A'
            )
          Text(`/${game.achievementTotal}`)
            .fontSize(10)
            .fontColor('#B0B0B0')
        }
        .width(this.achieveW)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .constraintSize({ minHeight: this.coverH })
      }
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  EmptyBuilder() {
    Column({ space: 6 }) {
      Text('暂无游戏')
        .fontSize(13)
        .fontColor('#999999')
      Text('换个筛选条件试试')
        .fontSize(11)
        .fontColor('#B0B0B0')
    }
    .width('100%')
    .padding({ top: 28, bottom: 20 })
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Column() {
      this.MainNavBuilder()
      this.FilterRowBuilder()

      Column() {
        if (this.filteredList().length === 0) {
          this.EmptyBuilder()
        } else {
          ForEach(this.filteredList(), (game: LibraryGame) => {
            Column() {
              this.GameCardBuilder(game)
              Divider()
                .color('#F0F0F0')
                .strokeWidth(0.5)
            }
            .width('100%')
          }, (game: LibraryGame) =>
            `${game.id}_${this.navKey}_${this.ownedSort}_${this.wishlistFilter}_${this.searchText}`)
        }
      }
      .width('100%')
      .margin({ top: 4 })
      .borderRadius(12)
      .backgroundColor('#FFFFFF')
      .clip(true)
      .padding({ left: 12, right: 12 })
    }
    .width('100%')
  }
}
