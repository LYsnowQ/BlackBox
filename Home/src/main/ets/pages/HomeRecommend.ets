import { CircleItem, FeedPost, circleList, recommendPosts } from '../model/HomeModel';
import { PostCard } from './PostCard';

const PAGE_SIZE: number = 6;

@Component
export struct HomeRecommend {
  @State selectedCircleId: string = 'all';
  /** 全量打乱池 */
  @State shuffledPosts: FeedPost[] = [];
  /** 当前展示条数（触底递增） */
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
    this.shuffledPosts = this.shufflePosts(recommendPosts);
    this.visibleCount = PAGE_SIZE;
    this.loadEpoch = this.loadEpoch + 1;
  }

  private filteredAll(): FeedPost[] {
    if (this.selectedCircleId === 'all') {
      return this.shuffledPosts;
    }
    return this.shuffledPosts.filter((post: FeedPost) => post.circleId === this.selectedCircleId);
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
    // 触底故意停顿，体感像真实分页
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

  @Builder
  CircleItemBuilder(item: CircleItem) {
    Column() {
      Stack() {
        Column()
          .width(48)
          .height(48)
          .borderRadius(14)
          .backgroundColor(item.bgColor)
        Text(item.iconText)
          .fontSize(item.iconText.length > 2 ? 10 : 16)
          .fontWeight(FontWeight.Medium)
          .fontColor(item.fgColor)
      }
      .width(48)
      .height(48)

      Text(item.name)
        .fontSize(11)
        .fontColor(this.selectedCircleId === item.id ? '#1A1A1A' : '#666666')
        .fontWeight(this.selectedCircleId === item.id ? FontWeight.Medium : FontWeight.Normal)
        .margin({ top: 6 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width(64)
    .alignItems(HorizontalAlign.Center)
    .opacity(this.selectedCircleId === item.id || this.selectedCircleId === 'all' || item.id === 'all' ? 1 : 0.85)
    .onClick(() => {
      this.selectedCircleId = item.id;
      this.visibleCount = PAGE_SIZE;
    })
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ListItem() {
          Scroll() {
            Row({ space: 4 }) {
              ForEach(circleList, (item: CircleItem) => {
                this.CircleItemBuilder(item)
              }, (item: CircleItem) => item.id)
            }
            .padding({ left: 12, right: 12, top: 8, bottom: 12 })
          }
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
          .width('100%')
        }

        ForEach(this.displayedPosts(), (post: FeedPost) => {
          ListItem() {
            Column() {
              Divider()
                .color('#F0F0F0')
                .strokeWidth(0.5)
              PostCard({ post: post, variant: 'recommend' })
            }
          }
        }, (post: FeedPost) => `${this.loadEpoch}|${this.selectedCircleId}|${post.id}`)

        ListItem() {
          Text(this.filteredAll().length === 0 ? '暂无内容' :
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
