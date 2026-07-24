import { HomeInteractStore } from '../model/HomeInteractStore';
import { FollowFeed } from './FollowFeed';
import { HomeRecommend } from './HomeRecommend';

@Component
export struct Home {
  /** 0 = 关注，1 = 推荐（默认推荐，与截图一致） */
  @State topTabIndex: number = 1;

  aboutToAppear(): void {
    HomeInteractStore.ensureLoaded(getContext(this) as Context);
  }

  @Builder
  HeaderBuilder() {
    Row() {
      Row() {
        Text('关注')
          .fontSize(this.topTabIndex === 0 ? 20 : 17)
          .fontWeight(this.topTabIndex === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.topTabIndex === 0 ? '#1A1A1A' : '#B0B0B0')
          .onClick(() => {
            this.topTabIndex = 0;
          })

        Text('推荐')
          .fontSize(this.topTabIndex === 1 ? 20 : 17)
          .fontWeight(this.topTabIndex === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.topTabIndex === 1 ? '#1A1A1A' : '#B0B0B0')
          .margin({ left: 20 })
          .onClick(() => {
            this.topTabIndex = 1;
          })
      }

      Blank()

      Row() {
        Text('🔍')
          .fontSize(18)
          .fontColor('#1A1A1A')
          .margin({ right: 18 })
        Text('✉️')
          .fontSize(18)
          .fontColor('#1A1A1A')
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 10, bottom: 8 })
  }

  build() {
    Column() {
      this.HeaderBuilder()

      if (this.topTabIndex === 0) {
        FollowFeed()
      } else {
        HomeRecommend()
      }
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }
}
