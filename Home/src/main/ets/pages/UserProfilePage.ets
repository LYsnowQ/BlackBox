import { router } from '@kit.ArkUI';
import { FeedPost, followPosts, recommendPosts } from '../model/HomeModel';
import { PostCard } from './PostCard';

/**
 * 用户主页（mock）：头像/简介 + 其发布的帖子列表
 * entry 壳：pages/Home/UserProfile
 */
@Component
export struct UserProfilePage {
  @State name: string = '';
  @State avatarColor: string = '#CCCCCC';
  @State avatarText: string = '';
  @State levelLabel: string = '';
  @State authorId: string = '';
  @State following: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (!params) {
      return;
    }
    this.name = (params['name'] as string) ?? '';
    this.avatarColor = (params['avatarColor'] as string) ?? '#CCCCCC';
    this.avatarText = (params['avatarText'] as string) ?? '';
    this.levelLabel = (params['levelLabel'] as string) ?? '';
    this.authorId = (params['authorId'] as string) ?? '';
    if (this.avatarText.length === 0 && this.name.length > 0) {
      this.avatarText = this.name.substring(0, 1);
    }
  }

  private userPosts(): FeedPost[] {
    const out: FeedPost[] = [];
    const seen: string[] = [];
    const pushIf = (p: FeedPost): void => {
      if (seen.indexOf(p.id) >= 0) {
        return;
      }
      const byId = this.authorId.length > 0 && p.authorId === this.authorId;
      const byName = this.name.length > 0 && p.authorName === this.name;
      if (byId || byName) {
        out.push(p);
        seen.push(p.id);
      }
    };
    for (let i = 0; i < recommendPosts.length; i++) {
      pushIf(recommendPosts[i]);
    }
    for (let i = 0; i < followPosts.length; i++) {
      pushIf(followPosts[i]);
    }
    return out;
  }

  private bioText(): string {
    if (this.levelLabel.length > 0) {
      return `${this.levelLabel} · 小黑盒盒友 · 这个人很懒，什么都没写`;
    }
    return '小黑盒盒友 · 这个人很懒，什么都没写';
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

      Text('主页')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row().width(40).height(40)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 8 })
  }

  @Builder
  HeaderCardBuilder() {
    Column() {
      Stack() {
        Column()
          .width(72)
          .height(72)
          .borderRadius(36)
          .backgroundColor(this.avatarColor)
        Text(this.avatarText)
          .fontSize(28)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
      }
      .width(72)
      .height(72)

      Text(this.name.length > 0 ? this.name : '未知用户')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ top: 12 })

      if (this.levelLabel.length > 0) {
        Text(this.levelLabel)
          .fontSize(11)
          .fontColor('#C47B00')
          .backgroundColor('#FFF3D6')
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ top: 8 })
      }

      Text(this.bioText())
        .fontSize(13)
        .fontColor('#888888')
        .margin({ top: 10 })
        .textAlign(TextAlign.Center)
        .padding({ left: 24, right: 24 })

      Row({ space: 24 }) {
        Column() {
          Text(`${this.userPosts().length}`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('动态')
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ top: 2 })
        }
        Column() {
          Text('128')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('关注')
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ top: 2 })
        }
        Column() {
          Text('3.2k')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
          Text('粉丝')
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ top: 2 })
        }
      }
      .margin({ top: 16 })

      Text(this.following ? '已关注' : '+ 关注')
        .fontSize(14)
        .fontColor(this.following ? '#666666' : Color.White)
        .backgroundColor(this.following ? '#F0F0F0' : '#1A1A1A')
        .padding({ left: 36, right: 36, top: 8, bottom: 8 })
        .borderRadius(18)
        .margin({ top: 16 })
        .onClick(() => {
          this.following = !this.following;
        })
    }
    .width('100%')
    .padding({ top: 12, bottom: 20 })
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Column() {
      this.NavBarBuilder()
      Divider().color('#F0F0F0').strokeWidth(0.5)

      List() {
        ListItem() {
          this.HeaderCardBuilder()
        }

        ListItem() {
          Text('TA 的动态')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .width('100%')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .backgroundColor('#FAFAFA')
        }

        if (this.userPosts().length === 0) {
          ListItem() {
            Text('暂无动态')
              .fontSize(13)
              .fontColor('#B0B0B0')
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 40, bottom: 40 })
          }
        } else {
          ForEach(this.userPosts(), (post: FeedPost) => {
            ListItem() {
              Column() {
                Divider().color('#F0F0F0').strokeWidth(0.5)
                PostCard({ post: post, variant: 'recommend' })
              }
            }
          }, (post: FeedPost) => `up|${post.id}`)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
