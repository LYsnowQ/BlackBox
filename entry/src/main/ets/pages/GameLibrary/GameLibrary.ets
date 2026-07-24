import { RecommendTab } from './RecommendTab';
import { RankingTab } from './RankingTab';

interface BottomNavItem {
  label: string;
  icon: string;
}

@Entry
@Component
struct GameLibrary {
  // 0 = 推荐, 1 = 榜单
  @State topTabIndex: number = 0;
  // 底部导航当前选中项，本页面对应"游戏库"
  @State bottomTabIndex: number = 3;

  private bottomNavItems: BottomNavItem[] = [
    { label: '首页', icon: '△' },
    { label: '热点', icon: '○' },
    { label: '', icon: '＋' },
    { label: '游戏库', icon: '✕' },
    { label: '我', icon: '□' },
  ];

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

  @Builder
  BottomNavBuilder() {
    Row() {
      ForEach(this.bottomNavItems, (item: BottomNavItem, index: number) => {
        if (index === 2) {
          // 中间的"＋"发布按钮，样式独立突出
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
    .height(64)
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: '#F0F0F0' })
  }

  build() {
    Column() {
      this.TopHeaderBuilder()

      Stack() {
        if (this.topTabIndex === 0) {
          RecommendTab()
        } else {
          RankingTab()
        }
      }
      .width('100%')
      .layoutWeight(1)

      this.BottomNavBuilder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
