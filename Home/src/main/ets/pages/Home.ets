import { router } from '@kit.ArkUI';
import { HomeInteractStore } from '../model/HomeInteractStore';
import { HomeRoutes } from '../router/HomeRoutes';
import { FollowFeed } from './FollowFeed';
import { HomeRecommend } from './HomeRecommend';

@Component
export struct Home {
  /** 0 = 关注，1 = 推荐（默认推荐，与截图一致） */
  @State topTabIndex: number = 1;

  aboutToAppear(): void {
    HomeInteractStore.ensureLoaded(getContext(this) as Context);
  }

  private goSearch(): void {
    router.pushUrl({ url: HomeRoutes.SEARCH });
  }

  private goMessages(): void {
    router.pushUrl({ url: HomeRoutes.MESSAGES });
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
        // 搜索：线性放大镜
        Text('⌕')
          .fontSize(20)
          .fontColor('#1A1A1A')
          .width(28)
          .height(28)
          .textAlign(TextAlign.Center)
          .margin({ right: 10 })
          .onClick(() => this.goSearch())
        // 消息：信封线框风格
        Text('✉')
          .fontSize(18)
          .fontColor('#1A1A1A')
          .width(28)
          .height(28)
          .textAlign(TextAlign.Center)
          .onClick(() => this.goMessages())
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
