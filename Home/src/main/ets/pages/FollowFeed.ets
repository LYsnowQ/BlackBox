import { router } from '@kit.ArkUI';
import { FeedPost, FollowUser, followPosts, followUsers } from '../model/HomeModel';
import { HomeRoutes } from '../router/HomeRoutes';
import { PostCard } from './PostCard';

@Component
export struct FollowFeed {
  @State selectedUserId: string = '';
  /** 进入页时打乱后的关注流动态顺序 */
  @State shuffledPosts: FeedPost[] = [];

  aboutToAppear(): void {
    this.shuffledPosts = this.shufflePosts(followPosts);
  }

  private shufflePosts(src: FeedPost[]): FeedPost[] {
    const arr: FeedPost[] = [];
    for (let i = 0; i < src.length; i++) {
      arr.push(src[i]);
    }
    for (let i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
    }
    return arr;
  }

  private filteredPosts(): FeedPost[] {
    if (this.selectedUserId === '') {
      return this.shuffledPosts;
    }
    return this.shuffledPosts.filter((post: FeedPost) => post.authorId === this.selectedUserId);
  }

  private openUserProfile(user: FollowUser): void {
    router.pushUrl({
      url: HomeRoutes.USER_PROFILE,
      params: {
        name: user.name,
        avatarColor: user.avatarColor,
        avatarText: user.avatarText,
        levelLabel: '',
        authorId: user.id,
      },
    });
  }

  @Builder
  UserItemBuilder(user: FollowUser) {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Stack() {
          Column()
            .width(52)
            .height(52)
            .borderRadius(26)
            .backgroundColor(user.avatarColor)
          Text(user.avatarText)
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
        }
        .width(52)
        .height(52)

        if (user.hasUpdate) {
          Column()
            .width(10)
            .height(10)
            .borderRadius(5)
            .backgroundColor('#FF3B30')
            .border({ width: 2, color: Color.White })
            .margin({ top: 1, right: 1 })
        }
      }
      .width(52)
      .height(52)
      .onClick(() => this.openUserProfile(user))

      Text(user.name)
        .fontSize(11)
        .fontColor(this.selectedUserId === user.id ? '#1A1A1A' : '#666666')
        .fontWeight(this.selectedUserId === user.id ? FontWeight.Medium : FontWeight.Normal)
        .margin({ top: 6 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .constraintSize({ maxWidth: 64 })
        .onClick(() => {
          this.selectedUserId = this.selectedUserId === user.id ? '' : user.id;
        })
    }
    .width(68)
    .alignItems(HorizontalAlign.Center)
    .opacity(this.selectedUserId === '' || this.selectedUserId === user.id ? 1 : 0.55)
  }

  build() {
    List() {
      ListItem() {
        Scroll() {
          Row({ space: 6 }) {
            ForEach(followUsers, (user: FollowUser) => {
              this.UserItemBuilder(user)
            }, (user: FollowUser) => user.id)
          }
          .padding({ left: 12, right: 12, top: 6, bottom: 10 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
      }

      if (this.selectedUserId === '') {
        ListItem() {
          Text('盒友动态')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .width('100%')
            .padding({ left: 16, right: 16, top: 4, bottom: 6 })
        }
      }

      ForEach(this.filteredPosts(), (post: FeedPost) => {
        ListItem() {
          Column() {
            Divider()
              .color('#F0F0F0')
              .strokeWidth(0.5)
            PostCard({ post: post, variant: 'follow' })
          }
        }
      }, (post: FeedPost) => `${this.selectedUserId}|${post.id}`)

      ListItem() {
        Text(this.filteredPosts().length === 0 ? '暂无动态' : '已经到底了')
          .fontSize(12)
          .fontColor('#C0C0C0')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 12, bottom: 24 })
      }
    }
    .width('100%')
    .layoutWeight(1)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
    .backgroundColor(Color.White)
  }
}
