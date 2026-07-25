import { router } from '@kit.ArkUI';
import { UserProfile } from '../model/types/UserModel';
import { getCurrentUserSync, updateCurrentUser } from '../api/UserApi';

/**
 * 编辑个人资料页内容（由 entry 路由壳挂载，从设置进入）
 */
@Component
export struct EditProfilePage {
  @State nickname: string = '';
  @State signature: string = '';
  @State avatarChar: string = '';
  @State userId: string = '';
  @State level: string = '';

  aboutToAppear(): void {
    const user: UserProfile = getCurrentUserSync();
    this.nickname = user.nickname;
    this.signature = user.signature;
    this.avatarChar = user.avatarChar;
    this.userId = user.userId;
    this.level = user.level;
  }

  private onSave(): void {
    const res = updateCurrentUser({
      nickname: this.nickname,
      signature: this.signature,
    });
    if (res.code === 0) {
      router.back();
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

      Text('编辑个人资料')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .letterSpacing(0.5)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Text('保存')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#2BC48A')
        .width(48)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => this.onSave())
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 8 })
  }

  build() {
    Column() {
      Row().width('100%').height(36)
      this.NavBarBuilder()

      Scroll() {
        Column() {
          Column({ space: 10 }) {
            Column() {
              Text(this.avatarChar)
                .fontSize(28)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.White)
            }
            .width(72)
            .height(72)
            .borderRadius(36)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#2BC48A')

            Text('更换头像')
              .fontSize(13)
              .fontColor('#2BC48A')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({ top: 20, bottom: 24 })

          Column() {
            Text('昵称')
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
              .margin({ bottom: 8 })
            TextInput({ text: this.nickname })
              .height(44)
              .fontSize(15)
              .fontColor('#1A1A1A')
              .backgroundColor('#F5F5F7')
              .borderRadius(10)
              .padding({ left: 14, right: 14 })
              .width('100%')
              .onChange((v: string) => {
                this.nickname = v;
              })

            Text('ID')
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
              .margin({ top: 18, bottom: 8 })
            Text(this.userId)
              .fontSize(15)
              .fontColor('#B0B0B0')
              .width('100%')
              .height(44)
              .padding({ left: 14, right: 14 })
              .borderRadius(10)
              .backgroundColor('#F5F5F7')

            Text('等级')
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
              .margin({ top: 18, bottom: 8 })
            Text(this.level)
              .fontSize(15)
              .fontColor('#B0B0B0')
              .width('100%')
              .height(44)
              .padding({ left: 14, right: 14 })
              .borderRadius(10)
              .backgroundColor('#F5F5F7')

            Text('个人格言')
              .fontSize(12)
              .fontColor('#999999')
              .width('100%')
              .margin({ top: 18, bottom: 8 })
            TextInput({ text: this.signature })
              .height(44)
              .fontSize(15)
              .fontColor('#1A1A1A')
              .backgroundColor('#F5F5F7')
              .borderRadius(10)
              .padding({ left: 14, right: 14 })
              .width('100%')
              .onChange((v: string) => {
                this.signature = v;
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
