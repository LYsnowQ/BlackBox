import { ProfileStat, UserProfile } from '../model/types/UserModel';
import { getCurrentUserSync } from '../api/UserApi';
import { PlatformPanel } from './PlatformPanel';
import { GameLibrarySection } from './GameLibrarySection';

/**
 * 「数据」Tab
 * 上：个人信息矩形区（无边框）
 * 下：平台绑定圆角窗口
 */
@Component
export struct DataTab {
  private user: UserProfile = getCurrentUserSync();

  @Builder
  AvatarBuilder() {
    Column() {
      Text(this.user.avatarChar)
        .fontSize(26)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
    }
    .width(64)
    .height(64)
    .borderRadius(32)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#2BC48A')
  }

  /**
   * 个人信息区：矩形、无边框
   * 头像 / 昵称 / 等级 / ID / 格言 / 关注·粉丝·获赞·收藏·历史总览
   */
  @Builder
  ProfileCardBuilder() {
    Column() {
      Row() {
        this.AvatarBuilder()

        Column() {
          Row() {
            Text(this.user.nickname)
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
              .letterSpacing(0.3)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.user.level)
              .fontSize(11)
              .fontWeight(FontWeight.Medium)
              .fontColor('#2BC48A')
              .padding({ left: 7, right: 7, top: 2, bottom: 2 })
              .borderRadius(4)
              .backgroundColor('rgba(43,196,138,0.12)')
              .margin({ left: 10 })
          }
          .alignItems(VerticalAlign.Center)

          Text(`ID ${this.user.userId}`)
            .fontSize(12)
            .fontColor('#999999')
            .letterSpacing(0.2)
            .margin({ top: 6 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 14 })
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 个人格言
      Text(this.user.signature)
        .fontSize(13)
        .fontColor('#666666')
        .lineHeight(20)
        .margin({ top: 14 })
        .width('100%')

      // 关注 / 粉丝 / 获赞 / 收藏 / 历史总览
      Row() {
        ForEach(this.user.stats, (item: ProfileStat) => {
          Column({ space: 4 }) {
            Text(item.value)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            Text(item.label)
              .fontSize(11)
              .fontColor('#999999')
              .letterSpacing(0.2)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        }, (item: ProfileStat) => item.label)
      }
      .width('100%')
      .margin({ top: 18 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
    // 矩形无边框：仅靠底色分区，不加 border / shadow
  }

  build() {
    Scroll() {
      Column() {
        this.ProfileCardBuilder()

        // 紧邻个人信息下方的平台绑定窗口
        Column() {
          PlatformPanel()
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12 })

        // 平台卡片下方：游戏库导航 + 列表
        Column() {
          GameLibrarySection()
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12 })

        Text('已经到底了')
          .fontSize(12)
          .fontColor('#B0B0B0')
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ top: 24, bottom: 28 })
      }
      .width('100%')
      .padding({ bottom: 8 })
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#F7F7F8')
  }
}
