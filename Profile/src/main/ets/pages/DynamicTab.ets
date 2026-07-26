import { router } from '@kit.ArkUI';
import { FeedImage, FeedItem } from '../model/types/FeedModel';
import { getFeedListSync } from '../api/FeedApi';
import { getProfileCoverSync } from '../api/MediaApi';
import { ProfileRoutes } from '../router/ProfileRoutes';

/**
 * 「动态」Tab — 帖子卡风格对齐首页 PostCard（对照实现，不 import home）
 * 配图仅走 Profile MediaApi
 */
@Component
export struct DynamicTab {
  private feeds: FeedItem[] = getFeedListSync();

  private openFeedDetail(item: FeedItem): void {
    router.pushUrl({
      url: ProfileRoutes.FEED_DETAIL,
      params: {
        'id': item.id,
      },
    });
  }

  private tagBg(tone?: string): string {
    if (tone === 'hot') {
      return '#FFF0F0';
    }
    if (tone === 'wiki') {
      return '#EAF7F0';
    }
    if (tone === 'topic') {
      return '#EEF2FF';
    }
    return '#F5F5F7';
  }

  private tagColor(tone?: string): string {
    if (tone === 'hot') {
      return '#FF5A5A';
    }
    if (tone === 'wiki') {
      return '#2F9B63';
    }
    if (tone === 'topic') {
      return '#5B6CFF';
    }
    return '#888888';
  }

  private likeNum(item: FeedItem): number {
    return item.likeCount !== undefined ? item.likeCount : 0;
  }

  private commentNum(item: FeedItem): number {
    return item.commentCount !== undefined ? item.commentCount : 0;
  }

  private imagesOf(item: FeedItem): FeedImage[] {
    return item.images !== undefined ? item.images : [];
  }

  private imageCountOf(item: FeedItem): number {
    if (item.imageCount !== undefined) {
      return item.imageCount;
    }
    return this.imagesOf(item).length;
  }

  @Builder
  AvatarBuilder(size: number, color: string, text: string) {
    Stack() {
      Column()
        .width(size)
        .height(size)
        .borderRadius(size / 2)
        .backgroundColor(color)
      Text(text)
        .fontSize(size * 0.36)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
    }
    .width(size)
    .height(size)
  }

  @Builder
  MediaImageBuilder(img: FeedImage) {
    if (img.mediaKey !== '') {
      Image(getProfileCoverSync(img.mediaKey))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(img.placeholderColor)
    }
  }

  @Builder
  ImageTileBuilder(img: FeedImage, tileWidth: Length, tileHeight: number, showCount: boolean, item: FeedItem) {
    Stack({ alignContent: Alignment.BottomEnd }) {
      this.MediaImageBuilder(img)

      if (showCount && this.imageCountOf(item) > this.imagesOf(item).length) {
        Text(`共${this.imageCountOf(item)}张`)
          .fontSize(10)
          .fontColor(Color.White)
          .backgroundColor('rgba(0,0,0,0.55)')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ right: 6, bottom: 6 })
      }
    }
    .width(tileWidth)
    .height(tileHeight)
    .clip(true)
    .borderRadius(8)
  }

  @Builder
  RightImageBodyBuilder(item: FeedItem) {
    Row() {
      Column() {
        Text(item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)
        Text(item.content)
          .fontSize(13)
          .fontColor('#8A8A8A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6 })
          .lineHeight(18)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .padding({ right: 10 })

      if (this.imagesOf(item).length > 0) {
        this.ImageTileBuilder(this.imagesOf(item)[0], 108, 108, false, item)
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  GridImagesBuilder(item: FeedItem) {
    if (this.imagesOf(item).length === 1) {
      this.ImageTileBuilder(
        this.imagesOf(item)[0],
        '100%',
        180,
        this.imageCountOf(item) > 1,
        item
      )
    } else if (this.imagesOf(item).length === 2) {
      Row({ space: 6 }) {
        Stack({ alignContent: Alignment.BottomEnd }) {
          this.MediaImageBuilder(this.imagesOf(item)[0])
        }
        .layoutWeight(1)
        .height(110)
        .clip(true)
        .borderRadius(8)

        Stack({ alignContent: Alignment.BottomEnd }) {
          this.MediaImageBuilder(this.imagesOf(item)[1])
          if (this.imageCountOf(item) > 2) {
            Text(`共${this.imageCountOf(item)}张`)
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor('rgba(0,0,0,0.55)')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
              .margin({ right: 6, bottom: 6 })
          }
        }
        .layoutWeight(1)
        .height(110)
        .clip(true)
        .borderRadius(8)
      }
      .width('100%')
    } else if (this.imagesOf(item).length >= 3) {
      Row({ space: 6 }) {
        Stack() {
          this.MediaImageBuilder(this.imagesOf(item)[0])
        }
        .layoutWeight(1.25)
        .height(150)
        .clip(true)
        .borderRadius(8)

        Column({ space: 6 }) {
          Stack() {
            this.MediaImageBuilder(this.imagesOf(item)[1])
          }
          .width('100%')
          .height(72)
          .clip(true)
          .borderRadius(8)

          Stack({ alignContent: Alignment.BottomEnd }) {
            this.MediaImageBuilder(this.imagesOf(item)[2])
            if (this.imageCountOf(item) > 3) {
              Text(`共${this.imageCountOf(item)}张`)
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('rgba(0,0,0,0.55)')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(4)
                .margin({ right: 6, bottom: 6 })
            }
          }
          .width('100%')
          .height(72)
          .clip(true)
          .borderRadius(8)
        }
        .layoutWeight(1)
        .height(150)
      }
      .width('100%')
      .height(150)
    }
  }

  @Builder
  FooterBuilder(item: FeedItem) {
    Row() {
      Row() {
        if (item.gameTag !== undefined && item.gameTag !== '') {
          Text(item.gameTag)
            .fontSize(11)
            .fontColor('#666666')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .constraintSize({ maxWidth: 140 })
        } else if (item.tag !== '') {
          Text(item.tag)
            .fontSize(11)
            .fontColor(this.tagColor(item.tagTone))
            .backgroundColor(this.tagBg(item.tagTone))
            .padding({ left: 6, right: 6, top: 3, bottom: 3 })
            .borderRadius(4)
        }
        if (item.timeText !== undefined && item.timeText !== '') {
          Text(item.timeText)
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ left: 8 })
        }
      }
      .layoutWeight(1)

      Row() {
        Text('💬')
          .fontSize(13)
          .fontColor('#B0B0B0')
        Text(`${this.commentNum(item)}`)
          .fontSize(12)
          .fontColor('#B0B0B0')
          .margin({ left: 3, right: 14 })
        Text('👍')
          .fontSize(13)
          .fontColor('#B0B0B0')
        Text(`${this.likeNum(item)}`)
          .fontSize(12)
          .fontColor('#B0B0B0')
          .margin({ left: 3 })
      }
    }
    .width('100%')
    .margin({ top: 10 })
  }

  @Builder
  FeedCardBuilder(item: FeedItem) {
    Column() {
      Row() {
        this.AvatarBuilder(34, item.authorAvatarColor, item.authorAvatarChar)

        Row() {
          Text(item.authorName)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })

          if (item.isOfficial === true) {
            Text('✔')
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor('#3B82F6')
              .width(14)
              .height(14)
              .textAlign(TextAlign.Center)
              .borderRadius(7)
              .margin({ left: 4 })
          }

          if (item.levelLabel !== '') {
            Text(item.levelLabel)
              .fontSize(10)
              .fontColor('#C47B00')
              .backgroundColor('#FFF3D6')
              .padding({ left: 5, right: 5, top: 1, bottom: 1 })
              .borderRadius(4)
              .margin({ left: 6 })
          }
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Center)

        Text('···')
          .fontSize(16)
          .fontColor('#C0C0C0')
          .padding({ left: 8, right: 2 })
      }
      .width('100%')
      .margin({ bottom: 10 })

      if (item.imageLayout === 'right') {
        this.RightImageBodyBuilder(item)
      } else {
        Text(item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)
          .width('100%')

        if (item.content !== '') {
          Text(item.content)
            .fontSize(13)
            .fontColor('#8A8A8A')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 6 })
            .lineHeight(18)
            .width('100%')
        }

        if (this.imagesOf(item).length > 0) {
          Column() {
            this.GridImagesBuilder(item)
          }
          .width('100%')
          .margin({ top: 10 })
        }
      }

      this.FooterBuilder(item)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => this.openFeedDetail(item))
  }

  @Builder
  EmptyBuilder() {
    Column({ space: 8 }) {
      Text('暂无动态')
        .fontSize(14)
        .fontColor('#999999')
      Text('稍后再来看看')
        .fontSize(12)
        .fontColor('#B0B0B0')
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    List() {
      if (this.feeds.length === 0) {
        ListItem() {
          this.EmptyBuilder()
        }
      } else {
        ForEach(this.feeds, (item: FeedItem) => {
          ListItem() {
            Column() {
              Divider()
                .color('#F0F0F0')
                .strokeWidth(0.5)
              this.FeedCardBuilder(item)
            }
          }
        }, (item: FeedItem) => item.id)

        ListItem() {
          Text('已经到底了')
            .fontSize(12)
            .fontColor('#C0C0C0')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ top: 12, bottom: 24 })
        }
      }
    }
    .width('100%')
    .layoutWeight(1)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
    .backgroundColor(Color.White)
  }
}
