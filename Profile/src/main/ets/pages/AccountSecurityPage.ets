import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

interface RowItem {
  title: string;
  value?: string;
  showArrow?: boolean;
  action?: string;
}

/**
 * 账号与安全
 */
@Component
export struct AccountSecurityPage {
  private rows: RowItem[] = [
    { title: '手机号', value: '138****8888', showArrow: true, action: 'phone' },
    { title: '邮箱', value: '未绑定', showArrow: true, action: 'email' },
    { title: '登录密码', value: '已设置', showArrow: true, action: 'password' },
    { title: '第三方账号', value: '微信 / QQ', showArrow: true, action: 'oauth' },
    { title: '登录设备管理', showArrow: true, action: 'devices' },
  ];

  private onRowClick(item: RowItem): void {
    const map: Record<string, string> = {
      'phone': '更换手机号（演示）',
      'email': '绑定邮箱（演示）',
      'password': '修改密码（演示）',
      'oauth': '管理第三方账号（演示）',
      'devices': '当前仅本机在线（演示）',
    };
    const key = item.action ?? '';
    promptAction.showToast({ message: map[key] ?? item.title, duration: 2000 });
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

      Text('账号与安全')
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
  RowBuilder(item: RowItem, isLast: boolean) {
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
        }
        if (item.showArrow) {
          Text('›').fontSize(18).fontColor('#C0C0C0').width(16).textAlign(TextAlign.End)
        }
      }
      .width('100%')
      .height(52)
      .padding({ left: 16, right: 14 })
      .onClick(() => this.onRowClick(item))

      if (!isLast) {
        Divider().color('#F0F0F0').strokeWidth(0.5).margin({ left: 16, right: 14 })
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
          Text('保护账号安全，建议开启多重验证')
            .fontSize(12)
            .fontColor('#999999')
            .width('100%')
            .padding({ left: 4, top: 18, bottom: 8 })

          Column() {
            ForEach(this.rows, (item: RowItem, index: number) => {
              this.RowBuilder(item, index === this.rows.length - 1)
            }, (item: RowItem) => item.title)
          }
          .width('100%')
          .borderRadius(14)
          .clip(true)
          .backgroundColor(Color.White)
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 36 })
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
