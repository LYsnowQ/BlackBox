import { router } from '@kit.ArkUI';
import { ProfileRoutes } from '../router/ProfileRoutes';

interface SettingItem {
  title: string;
  value?: string;
  showArrow?: boolean;
  action?: string; // 特殊动作标识
}

interface SettingGroup {
  title: string;
  items: SettingItem[];
}

/**
 * 设置页内容（由 entry 路由壳挂载）
 * 「编辑个人资料」收纳于此
 */
@Component
export struct SettingsPage {
  private groups: SettingGroup[] = [
    {
      title: '个人',
      items: [
        { title: '编辑个人资料', showArrow: true, action: 'edit_profile' },
      ],
    },
    {
      title: '账号',
      items: [
        { title: '账号与安全', showArrow: true },
        { title: '隐私设置', showArrow: true },
        { title: '黑名单', showArrow: true },
      ],
    },
    {
      title: '通用',
      items: [
        { title: '消息通知', showArrow: true },
        { title: '清除缓存', value: '128 MB', showArrow: true },
        { title: '深色模式', value: '跟随系统', showArrow: true },
      ],
    },
    {
      title: '关于',
      items: [
        { title: '关于小黑盒', showArrow: true },
        { title: '当前版本', value: '1.0.0' },
      ],
    },
  ];

  private onItemClick(item: SettingItem): void {
    if (item.action === 'edit_profile') {
      router.pushUrl({
        url: ProfileRoutes.EDIT_PROFILE,
      });
    }
  }

  @Builder
  NavBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(26)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#1A1A1A')
        .width(40)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => router.back())

      Text('设置')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .letterSpacing(0.5)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row().width(40).height(40)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
  }

  @Builder
  SettingRowBuilder(item: SettingItem, isLast: boolean) {
    Column() {
      Row() {
        Text(item.title)
          .fontSize(15)
          .fontColor('#1A1A1A')
          .layoutWeight(1)

        if (item.value) {
          Text(item.value)
            .fontSize(13)
            .fontColor('#999999')
            .margin({ right: item.showArrow ? 6 : 0 })
        }

        if (item.showArrow) {
          Text('›')
            .fontSize(18)
            .fontColor('#C0C0C0')
        }
      }
      .width('100%')
      .height(52)
      .padding({ left: 16, right: 16 })
      .onClick(() => this.onItemClick(item))

      if (!isLast) {
        Divider()
          .color('#F0F0F0')
          .strokeWidth(0.5)
          .margin({ left: 16 })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      Row().width('100%').height(36)
      this.NavBarBuilder()

      Scroll() {
        Column() {
          ForEach(this.groups, (group: SettingGroup) => {
            Column() {
              Text(group.title)
                .fontSize(12)
                .fontColor('#999999')
                .width('100%')
                .padding({ left: 16, top: 18, bottom: 8 })

              Column() {
                ForEach(group.items, (item: SettingItem, index: number) => {
                  this.SettingRowBuilder(item, index === group.items.length - 1)
                }, (item: SettingItem) => item.title)
              }
              .width('100%')
              .borderRadius(14)
              .clip(true)
              .margin({ left: 16, right: 16 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }, (group: SettingGroup) => group.title)

          Text('退出登录')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#E23B3B')
            .textAlign(TextAlign.Center)
            .width('100%')
            .height(48)
            .margin({ left: 16, right: 16, top: 28 })
            .borderRadius(14)
            .backgroundColor(Color.White)

          Text('已经到底了')
            .fontSize(12)
            .fontColor('#B0B0B0')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 28, bottom: 36 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
