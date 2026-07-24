import { RecommendTab } from './RecommendTab';
import { RankingTab } from './RankingTab';

@Component
export struct GameLibraryContent {
  @State topTabIndex: number = 0;
  @State isForYouPageOpen: boolean = false;
  @State activeNavPage: string = '';

  @Builder
  TopHeaderBuilder() {
    Row() {
      Row() {
        Text('推荐')
          .fontSize(20)
          .fontWeight(this.topTabIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.topTabIndex === 0 ? '#1A1A1A' : '#B0B0B0')
          .onClick(() => (this.topTabIndex = 0))

        Text('榜单')
          .fontSize(20)
          .fontWeight(this.topTabIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.topTabIndex === 1 ? '#1A1A1A' : '#B0B0B0')
          .margin({ left: 22 })
          .onClick(() => (this.topTabIndex = 1))
      }

      Blank()

      Row() {
        Text('🔍')
          .fontSize(18)
          .margin({ right: 18 })
        Text('✉️')
          .fontSize(18)
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }

  build() {
    Column() {
      if (!this.isForYouPageOpen && this.activeNavPage === '') {
        this.TopHeaderBuilder()
      }

      if (this.topTabIndex === 0) {
        RecommendTab({ isForYouPageOpen: $isForYouPageOpen, activeNavPage: $activeNavPage })
      } else {
        RankingTab()
      }
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }
}