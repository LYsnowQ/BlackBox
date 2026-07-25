import { router } from '@kit.ArkUI';
import { FeedPost, FollowUser, followPosts, followUsers } from '../model/HomeModel';
import { HomeRoutes } from '../router/HomeRoutes';
import { PostCard } from './PostCard';

const PAGE_SIZE: number = 6;

@Component
export struct FollowFeed {
  @State selectedUserId: string = '';
  @State shuffledPosts: FeedPost[] = [];
  @State visibleCount: number = PAGE_SIZE;
  @State isRefreshing: boolean = false;
  @State loadEpoch: number = 0;

  aboutToAppear(): void {
    this.resetPool();
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

  private resetPool(): void {
    this.shuffledPosts = this.shufflePosts(followPosts);
    this.visibleCount = PAGE_SIZE;
    this.loadEpoch = this.loadEpoch + 1;
  }

  private filteredAll(): FeedPost[] {
    if (this.selectedUserId === '') {
      return this.shuffledPosts;
    }
    return this.shuffledPosts.filter((post: FeedPost) => post.authorId === this.selectedUserId);
  }

  private displayedPosts(): FeedPost[] {
    const all = this.filteredAll();
    const n = Math.min(this.visibleCount, all.length);
    const out: FeedPost[] = [];
    for (let i = 0; i < n; i++) {
      out.push(all[i]);
    }
    return out;
  }

  private hasMore(): boolean {
    return this.visibleCount < this.filteredAll().length;
  }

  @State isLoadingMore: boolean = false;

  private loadMore(): void {
    if (!this.hasMore() || this.isLoadingMore) {
      return;
    }
    this.isLoadingMore = true;
    setTimeout(() => {
      this.visibleCount = Math.min(this.visibleCount + PAGE_SIZE, this.filteredAll().length);
      this.isLoadingMore = false;
    }, 650);
  }

  private doRefresh(): void {
    this.isRefreshing = true;
    setTimeout(() => {
      this.resetPool();
      this.isRefreshing = false;
    }, 700);
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
          this.visibleCount = PAGE_SIZE;
        })
    }
    .width(68)
    .alignItems(HorizontalAlign.Center)
    .opacity(this.selectedUserId === '' || this.selectedUserId === user.id ? 1 : 0.55)
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
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

        ForEach(this.displayedPosts(), (post: FeedPost) => {
          ListItem() {
            Column() {
              Divider()
                .color('#F0F0F0')
                .strokeWidth(0.5)
              PostCard({ post: post, variant: 'follow' })
            }
          }
        }, (post: FeedPost) => `${this.loadEpoch}|${this.selectedUserId}|${post.id}`)

        ListItem() {
          Text(this.filteredAll().length === 0 ? '暂无动态' :
            (this.isLoadingMore ? '加载中…' :
              (this.hasMore() ? '上拉加载更多' : '已经到底了')))
            .fontSize(12)
            .fontColor('#C0C0C0')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ top: 12, bottom: 24 })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .backgroundColor(Color.White)
      .onReachEnd(() => this.loadMore())
    }
    .onRefreshing(() => this.doRefresh())
    .width('100%')
    .layoutWeight(1)
  }
}
