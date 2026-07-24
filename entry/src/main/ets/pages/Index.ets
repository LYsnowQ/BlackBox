import { Home } from './Home/Home';
import { Hot } from './Hot/Hot';
import { RecommendTab } from './GameLibrary/RecommendTab';
import { RankingTab } from './GameLibrary/RankingTab';
import { Me } from './Me/Me';

interface BottomNavItem {
  label: string;
  icon: string;
}

@Entry
@Component
struct Index {
  @State bottomTabIndex: number = 3;
  @State topTabIndex: number = 0;

  private bottomNavItems: BottomNavItem[] = [
    { label: '首页', icon: '△' },
    { label: '热点', icon: '○' },
    { label: '', icon: '＋' },
    { label: '游戏库', icon: '✕' },
    { label: '我', icon: '□' },
  ];

  @Builder
  GameLibraryHeaderBuilder() {
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

  @Builder
  BottomNavBuilder() {
    Row() {
      ForEach(this.bottomNavItems, (item: BottomNavItem, index: number) => {
        if (index === 2) {
          Column() {
            Text(item.icon)
              .fontSize(20)
              .fontColor(Color.White)
          }
          .width(44)
          .height(44)
          .borderRadius(12)
          .backgroundColor('#1A1A1A')
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
        } else {
          Column() {
            Text(item.icon)
              .fontSize(20)
              .fontColor(this.bottomTabIndex === index ? '#1A1A1A' : '#B0B0B0')
            Text(item.label)
              .fontSize(11)
              .fontColor(this.bottomTabIndex === index ? '#1A1A1A' : '#B0B0B0')
              .margin({ top: 3 })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .onClick(() => (this.bottomTabIndex = index))
        }
      })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: '#F0F0F0' })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  PageContentBuilder() {
    if (this.bottomTabIndex === 0) {
      Home()
    } else if (this.bottomTabIndex === 1) {
      Hot()
    } else if (this.bottomTabIndex === 3) {
      Column() {
        this.GameLibraryHeaderBuilder()
        if (this.topTabIndex === 0) {
          RecommendTab()
        } else {
          RankingTab()
        }
      }
      .width('100%')
      .layoutWeight(1)
    } else if (this.bottomTabIndex === 4) {
      Me()
    } else {
      Column() {
        Text('发布功能')
          .fontSize(20)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        this.PageContentBuilder()
      }
      .width('100%')
      .height('100%')
      .padding({ bottom: 56 })

      this.BottomNavBuilder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}