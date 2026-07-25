import { CircleItem, FeedPost, circleList, recommendPosts } from '../model/HomeModel';
import { PostCard } from './PostCard';

@Component
export struct HomeRecommend {
  @State selectedCircleId: string = 'all';
  /** 进入页时打乱后的推荐流顺序 */
  @State shuffledPosts: FeedPost[] = [];

  aboutToAppear(): void {
    this.shuffledPosts = this.shufflePosts(recommendPosts);
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
    if (this.selectedCircleId === 'all') {
      return this.shuffledPosts;
    }
    return this.shuffledPosts.filter((post: FeedPost) => post.circleId === this.selectedCircleId);
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
    })
  }

  build() {
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

      ForEach(this.filteredPosts(), (post: FeedPost) => {
        ListItem() {
          Column() {
            Divider()
              .color('#F0F0F0')
              .strokeWidth(0.5)
            PostCard({ post: post, variant: 'recommend' })
          }
        }
      }, (post: FeedPost) => `${this.selectedCircleId}|${post.id}`)

      ListItem() {
        Text(this.filteredPosts().length === 0 ? '暂无内容' : '已经到底了')
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
