import { GameItem, gameList } from '../../model/GameLibrary/GameLibraryModel';
import { GameLibraryRoutes } from '../../router/GameLibraryRoutes';
import { GameCard } from '../../components/GameCard';
import router from '@ohos.router';

@Entry
@Component
export struct GameSearchPage {
  @State searchQuery: string = '';
  @State searchHistory: string[] = ['黑神话悟空', '艾尔登法环', '幻兽帕鲁', 'CS2', '绝地求生'];
  @State selectedPlatform: string = '全部';
  @State selectedPriceFilter: string = '全部';
  @State selectedCategory: string = '全部';
  @State searchResults: GameItem[] = gameList;

  private platforms: string[] = ['全部', 'Steam', 'Epic', 'PS5', 'Switch', 'Xbox'];
  private priceFilters: string[] = ['全部', '折扣中', '新史低', '100元以下'];
  private categories: string[] = ['全部', '开放世界', '动作', 'RPG', '射击', '生存'];

  private filterGames() {
    this.searchResults = gameList.filter((game: GameItem) => {
      // 1. 关键词搜索
      if (this.searchQuery.trim() !== '') {
        const query = this.searchQuery.toLowerCase();
        const matchTitle = game.title.toLowerCase().includes(query);
        const matchEng = game.englishTitle.toLowerCase().includes(query);
        const matchTags = game.tags.some(tag => tag.toLowerCase().includes(query));
        if (!matchTitle && !matchEng && !matchTags) {
          return false;
        }
      }

      // 2. 价格过滤
      if (this.selectedPriceFilter === '折扣中' && !game.discountPercent) {
        return false;
      }
      if (this.selectedPriceFilter === '新史低' && game.lowestLabel !== '新史低') {
        return false;
      }
      if (this.selectedPriceFilter === '100元以下' && game.price >= 100) {
        return false;
      }

      // 3. 分类过滤
      if (this.selectedCategory !== '全部') {
        if (!game.tags.includes(this.selectedCategory)) {
          return false;
        }
      }

      return true;
    });
  }

  private performSearch(term: string) {
    this.searchQuery = term;
    if (term.trim() !== '' && !this.searchHistory.includes(term)) {
      this.searchHistory.unshift(term);
      if (this.searchHistory.length > 8) {
        this.searchHistory.pop();
      }
    }
    this.filterGames();
  }

  build() {
    Column() {
      // 1. 顶部搜索栏
      Row() {
        Text('❮')
          .fontSize(20)
          .fontColor('#1A1A1A')
          .padding(8)
          .onClick(() => {
            router.back();
          })

        Row() {
          Text('🔍')
            .fontSize(14)
            .margin({ left: 10 })

          TextInput({ text: this.searchQuery, placeholder: '搜索游戏、标签、厂商...' })
            .placeholderColor('#B0B0B0')
            .fontSize(14)
            .height(36)
            .backgroundColor(Color.Transparent)
            .layoutWeight(1)
            .onChange((value: string) => {
              this.searchQuery = value;
              this.filterGames();
            })

          if (this.searchQuery.length > 0) {
            Text('✕')
              .fontSize(14)
              .fontColor('#999999')
              .padding({ left: 6, right: 10 })
              .onClick(() => {
                this.searchQuery = '';
                this.filterGames();
              })
          }
        }
        .layoutWeight(1)
        .height(38)
        .backgroundColor('#F5F5F5')
        .borderRadius(19)
        .margin({ left: 8, right: 8 })

        Text('搜索')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .padding({ left: 6, right: 6 })
          .onClick(() => {
            this.performSearch(this.searchQuery);
          })
      }
      .width('100%')
      .padding({ left: 8, right: 12, top: 8, bottom: 8 })
      .backgroundColor(Color.White)

      // 2. 多维筛选工具栏
      Column() {
        // 平台选择
        Row() {
          Text('平台:')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ right: 8 })
          Scroll() {
            Row() {
              ForEach(this.platforms, (p: string) => {
                Text(p)
                  .fontSize(12)
                  .fontColor(this.selectedPlatform === p ? '#1A1A1A' : '#666666')
                  .fontWeight(this.selectedPlatform === p ? FontWeight.Bold : FontWeight.Normal)
                  .backgroundColor(this.selectedPlatform === p ? '#E8E8E8' : '#F7F7F7')
                  .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                  .borderRadius(12)
                  .margin({ right: 6 })
                  .onClick(() => {
                    this.selectedPlatform = p;
                    this.filterGames();
                  })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 6, bottom: 4 })

        // 优惠/价格过滤
        Row() {
          Text('价格:')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ right: 8 })
          Scroll() {
            Row() {
              ForEach(this.priceFilters, (pf: string) => {
                Text(pf)
                  .fontSize(12)
                  .fontColor(this.selectedPriceFilter === pf ? '#FF6B00' : '#666666')
                  .fontWeight(this.selectedPriceFilter === pf ? FontWeight.Bold : FontWeight.Normal)
                  .backgroundColor(this.selectedPriceFilter === pf ? '#FFF3E0' : '#F7F7F7')
                  .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                  .borderRadius(12)
                  .margin({ right: 6 })
                  .onClick(() => {
                    this.selectedPriceFilter = pf;
                    this.filterGames();
                  })
              })
            }
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 4, bottom: 6 })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      // 3. 搜索历史与结果列表
      Scroll() {
        Column() {
          if (this.searchQuery === '' && this.searchHistory.length > 0) {
            Column() {
              Row() {
                Text('搜索历史')
                  .fontSize(13)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1A1A1A')
                Blank()
                Text('清空')
                  .fontSize(12)
                  .fontColor('#999999')
                  .onClick(() => {
                    this.searchHistory = [];
                  })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 8 })

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.searchHistory, (item: string) => {
                  Text(item)
                    .fontSize(12)
                    .fontColor('#333333')
                    .backgroundColor('#F5F5F5')
                    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => {
                      this.performSearch(item);
                    })
                })
              }
              .padding({ left: 16, right: 16, bottom: 12 })
            }
            .width('100%')
            .backgroundColor(Color.White)
            .margin({ bottom: 10 })
          }

          // 搜索结果提示条
          Row() {
            Text(`共找到 ${this.searchResults.length} 款游戏`)
              .fontSize(12)
              .fontColor('#888888')
          }
          .width('100%')
          .padding({ left: 16, top: 8, bottom: 8 })

          // 游戏列表
          ForEach(this.searchResults, (game: GameItem) => {
            Column() {
              GameCard({
                game: game,
                onCardClick: () => {
                  router.pushUrl({
                    url: GameLibraryRoutes.GAME_DETAIL,
                    params: { gameId: game.id }
                  });
                }
              })
            }
            .padding({ left: 12, right: 12, bottom: 8 })
          })

          if (this.searchResults.length === 0) {
            Column() {
              Text('未找到相关游戏')
                .fontSize(14)
                .fontColor('#999999')
                .margin({ top: 40 })
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
          }
        }
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8')
  }
}
