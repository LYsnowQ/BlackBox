import { MAIN_TABS, RouteNames, TabItem } from '../common/RouteNames';
import { HomePage } from './home/HomePage';
import { HotPage } from './HotPage/HotPage';
import { GameLibraryPage } from './game/GameLibraryPage';
import { ProfilePage } from './profile/ProfilePage';

/**
 * 应用主壳：底部四 Tab
 * 顺序（左→右）：首页(lq) | 热点(wgl) | 游戏库(ysf) | 我(ghl)
 * 各 Tab 内容由对应负责人在各自目录实现，本文件只负责切换容器。
 *
 * 约定：
 * - 不要在本文件写各 Tab 业务 UI
 * - 新增子页面请在对应模块目录创建，并在 docs/dev/ 补充开发文档
 */
@Entry
@Component
struct Index {
  @State currentIndex: number = 0;

  @Builder
  TabContentView(key: string) {
    if (key === RouteNames.HOME) {
      HomePage()
    } else if (key === RouteNames.HOT) {
      HotPage()
    } else if (key === RouteNames.GAME) {
      GameLibraryPage()
    } else {
      ProfilePage()
    }
  }

  build() {
    Column() {
      Column() {
        this.TabContentView(MAIN_TABS[this.currentIndex].key)
      }
      .layoutWeight(1)
      .width('100%')

      Divider()
        .color($r('app.color.divider'))
        .strokeWidth(0.5)

      Row() {
        ForEach(MAIN_TABS, (item: TabItem, index: number) => {
          Column() {
            Text(item.title)
              .fontSize($r('app.float.tab_font_size'))
              .fontColor(this.currentIndex === index ?
                $r('app.color.tab_active') : $r('app.color.tab_inactive'))
              .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Regular)
          }
          .layoutWeight(1)
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.currentIndex = index;
          })
        }, (item: TabItem) => item.key)
      }
      .width('100%')
      .height($r('app.float.tab_bar_height'))
      .backgroundColor($r('app.color.tab_background'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }
}
