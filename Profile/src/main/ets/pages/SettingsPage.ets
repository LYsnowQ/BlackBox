import { promptAction, router } from '@kit.ArkUI';
import { ProfileRoutes } from '../router/ProfileRoutes';

interface SettingItem {
  title: string;
  value?: string;
  showArrow?: boolean;
  /** 路由常量；无则不跳转 */
  route?: string;
  /** 特殊动作标识 */
  action?: string;
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
  @State cacheSize: string = '128 MB';
  @State darkModeLabel: string = '跟随系统';

  private getGroups(): SettingGroup[] {
    return [
      {
        title: '个人',
        items: [
          { title: '编辑个人资料', showArrow: true, route: ProfileRoutes.EDIT_PROFILE },
        ],
      },
      {
        title: '账号',
        items: [
          { title: '账号与安全', showArrow: true, route: ProfileRoutes.ACCOUNT_SECURITY },
          { title: '隐私设置', showArrow: true, route: ProfileRoutes.PRIVACY },
          { title: '黑名单', showArrow: true, route: ProfileRoutes.BLACKLIST },
        ],
      },
      {
        title: '通用',
        items: [
          { title: '消息通知', showArrow: true, route: ProfileRoutes.NOTIFICATION },
          { title: '清除缓存', value: this.cacheSize, showArrow: true, action: 'clear_cache' },
          {
            title: '深色模式',
            value: this.darkModeLabel,
            showArrow: true,
            route: ProfileRoutes.DARK_MODE,
          },
        ],
      },
      {
        title: '关于',
        items: [
          { title: '关于小黑盒', showArrow: true, route: ProfileRoutes.ABOUT },
          { title: '当前版本', value: '1.0.0' },
        ],
      },
    ];
  }

  private onItemClick(item: SettingItem): void {
    if (item.action === 'clear_cache') {
      this.onClearCache();
      return;
    }
    if (item.route) {
      router.pushUrl({ url: item.route });
    }
  }

  private onClearCache(): void {
    promptAction.showDialog({
      title: '清除缓存',
      message: `将清除本地图片与临时文件（当前 ${this.cacheSize}），不影响账号数据。`,
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '清除', color: '#2BC48A' },
      ],
    }).then((result) => {
      if (result.index === 1) {
        this.cacheSize = '0 MB';
        promptAction.showToast({ message: '缓存已清除', duration: 2000 });
      }
    }).catch(() => {
      // 用户关闭弹窗
    });
  }

  private onLogout(): void {
    promptAction.showDialog({
      title: '退出登录',
      message: '确定退出当前账号吗？（演示，不会真正登出）',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '退出', color: '#E23B3B' },
      ],
    }).then((result) => {
      if (result.index === 1) {
        promptAction.showToast({ message: '已退出登录（演示）', duration: 2000 });
        router.back();
      }
    }).catch(() => {
    });
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
            .margin({ right: item.showArrow ? 8 : 0 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

        if (item.showArrow) {
          Text('›')
            .fontSize(18)
            .fontColor('#C0C0C0')
            .width(16)
            .textAlign(TextAlign.End)
        }
      }
      .width('100%')
      .height(52)
      // 卡片内左右留白，右侧箭头/文案不再贴边
      .padding({ left: 16, right: 14 })
      .onClick(() => this.onItemClick(item))

      if (!isLast) {
        Divider()
          .color('#F0F0F0')
          .strokeWidth(0.5)
          .margin({ left: 16, right: 14 })
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
        // 关键：外层统一左右内边距，卡片 width 100% 不再 + margin 导致右侧溢出裁成直角
        Column() {
          ForEach(this.getGroups(), (group: SettingGroup) => {
            Column() {
              Text(group.title)
                .fontSize(12)
                .fontColor('#999999')
                .width('100%')
                .padding({ left: 4, top: 18, bottom: 8 })

              Column() {
                ForEach(group.items, (item: SettingItem, index: number) => {
                  this.SettingRowBuilder(item, index === group.items.length - 1)
                }, (item: SettingItem) => `${item.title}|${item.value ?? ''}`)
              }
              .width('100%')
              .borderRadius(14)
              .clip(true)
              .backgroundColor(Color.White)
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
            .margin({ top: 28 })
            .borderRadius(14)
            .backgroundColor(Color.White)
            .onClick(() => this.onLogout())

          Text('已经到底了')
            .fontSize(12)
            .fontColor('#B0B0B0')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 28, bottom: 36 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F8')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
