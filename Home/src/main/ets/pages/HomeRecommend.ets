import { CircleItem, FeedPost, circleList, recommendPosts } from '../model/HomeModel';
import { PostCard } from './PostCard';

@Component
export struct HomeRecommend {
  @State selectedCircleId: string = 'all';

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

      ForEach(recommendPosts, (post: FeedPost) => {
        ListItem() {
          Column() {
            Divider()
              .color('#F0F0F0')
              .strokeWidth(0.5)
            PostCard({ post: post, variant: 'recommend' })
          }
        }
      }, (post: FeedPost) => post.id)

      ListItem() {
        Text('已经到底了')
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
