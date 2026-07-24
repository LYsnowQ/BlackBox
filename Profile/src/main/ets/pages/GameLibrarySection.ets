import {
  libraryGames,
  LibraryGame,
  LibraryNavKey,
  OwnedSortKey,
  WishlistFilterKey,
} from '../model/ProfileModel';

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

  // ── 列表过滤 / 排序 ──

  private baseList(): LibraryGame[] {
    const src = libraryGames;
    const out: LibraryGame[] = [];
    for (let i = 0; i < src.length; i++) {
      const g = src[i];
      if (this.navKey === 'wishlist') {
        if (!g.inWishlist) {
          continue;
        }
        if (this.wishlistFilter === 'discount' && !g.onDiscount) {
          continue;
        }
        if (this.wishlistFilter === 'lowest' && !g.isLowest) {
          continue;
        }
        if (this.wishlistFilter === 'steam' && !g.inSteamWishlist) {
          continue;
        }
        out.push(g);
      } else if (this.navKey === 'owned') {
        if (g.owned) {
          out.push(g);
        }
      } else if (this.navKey === 'perfect') {
        if (g.owned && g.achievementTotal > 0 &&
          g.achievementUnlocked === g.achievementTotal) {
          out.push(g);
        }
      } else if (this.navKey === 'rated') {
        if (g.myRating !== undefined) {
          out.push(g);
        }
      }
    }
    return out;
  }

  private filteredList(): LibraryGame[] {
    let list = this.baseList();
    const q = this.searchText.trim().toLowerCase();
    if ((this.navKey === 'owned' || this.navKey === 'perfect') && q.length > 0) {
      const hit: LibraryGame[] = [];
      for (let i = 0; i < list.length; i++) {
        if (list[i].title.toLowerCase().indexOf(q) >= 0) {
          hit.push(list[i]);
        }
      }
      list = hit;
    }
    if (this.navKey === 'owned' || this.navKey === 'perfect') {
      return this.sortOwned(list);
    }
    return list;
  }

  private sortOwned(list: LibraryGame[]): LibraryGame[] {
    const copy: LibraryGame[] = [];
    for (let i = 0; i < list.length; i++) {
      copy.push(list[i]);
    }
    copy.sort((a: LibraryGame, b: LibraryGame) => {
      if (this.ownedSort === 'twoWeek') {
        return b.twoWeekHours - a.twoWeekHours;
      }
      if (this.ownedSort === 'achievement') {
        return b.achievementUnlocked - a.achievementUnlocked;
      }
      return b.totalHours - a.totalHours;
    });
    return copy;
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

  @Builder
  GameCardBuilder(game: LibraryGame) {
    Row() {
      // 封面：横向长方形，左缘与搜索框对齐
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

      // 信息：名称 / 评分 / 进度条+右侧时长
      Column() {
        Text(game.title)
          .fontSize(this.titleFontSize(game.title))
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        if (game.myRating !== undefined && this.navKey === 'rated') {
          Text(`${game.myRating.toFixed(1)} 分`)
            .fontSize(11)
            .fontColor('#2BC48A')
            .margin({ top: 3 })
            .width('100%')
        }

        // 进度条 + 右侧顶头时长（总时长 / 两周内，取决于排序）
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
      .layoutWeight(1)
      .padding({ left: 10, right: 4 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .constraintSize({ minHeight: this.coverH })

      // 成就列
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
