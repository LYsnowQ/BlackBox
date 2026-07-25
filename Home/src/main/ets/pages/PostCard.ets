import { router } from '@kit.ArkUI';
import { HomeInteractStore } from '../model/HomeInteractStore';
import { FeedPost, PostImage } from '../model/HomeModel';
import { HomeRoutes } from '../router/HomeRoutes';

@Component
export struct PostCard {
  @Prop post: FeedPost = {
    id: '',
    authorId: '',
    circleId: '',
    authorName: '',
    authorAvatarColor: '#CCCCCC',
    authorAvatarText: '',
    levelLabel: '',
    isOfficial: false,
    isFollowing: false,
    title: '',
    summary: '',
    images: [],
    imageCount: 0,
    imageLayout: 'grid',
    tagText: '',
    tagTone: '',
    gameTag: '',
    timeText: '',
    commentCount: 0,
    likeCount: 0,
  };
  /** follow = 关注流；recommend = 推荐流 */
  @Prop variant: string = 'recommend';
  /** 详情页互动持久化后递增，驱动列表计数刷新 */
  @StorageProp('homeInteractVersion') interactVersion: number = 0;

  private displayCommentCount(): number {
    // 读取 interactVersion，保证持久化后 Footer 会重绘
    const _v = this.interactVersion;
    return HomeInteractStore.getCommentCount(this.post.id, this.post.commentCount) + _v * 0;
  }

  private displayLikeCount(): number {
    const _v = this.interactVersion;
    return HomeInteractStore.getLikeCount(this.post.id, this.post.likeCount) + _v * 0;
  }

  private tagBg(): string {
    if (this.post.tagTone === 'hot') {
      return '#FFF0F0';
    }
    if (this.post.tagTone === 'wiki') {
      return '#EAF7F0';
    }
    if (this.post.tagTone === 'topic') {
      return '#EEF2FF';
    }
    return '#F5F5F7';
  }

  private tagColor(): string {
    if (this.post.tagTone === 'hot') {
      return '#FF5A5A';
    }
    if (this.post.tagTone === 'wiki') {
      return '#2F9B63';
    }
    if (this.post.tagTone === 'topic') {
      return '#5B6CFF';
    }
    return '#888888';
  }

  /** 资源宽/高；列表单图用，竖图给更矮的宽高比 */
  private mediaAspectRatio(key: string): number {
    if (key === 'scrape_messi1' || key === 'scrape_jiahao1' || key === 'scrape_wzry1' ||
      key === 'scrape_gf1') {
      return 0.46;
    }
    if (key === 'scrape_cf4') {
      return 0.51;
    }
    if (key === 'scrape_doubao1' || key === 'scrape_cf2' || key === 'scrape_cf3') {
      return 0.77;
    }
    if (key === 'scrape_cf1' || key === 'scrape_honor1') {
      return 0.95;
    }
    if (key === 'scrape_cxmt1' || key === 'scrape_greenhell1' || key === 'scrape_muse1' ||
      key === 'scrape_tom1' || key === 'scrape_fields1' || key === 'scrape_fields2' ||
      key === 'scrape_honor2') {
      return 1.78;
    }
    return 1.33;
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
  MediaImageBuilder(img: PostImage) {
    if (img.mediaKey === 'chain') {
      Image($r('app.media.chain'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'mita') {
      Image($r('app.media.mita'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'nba') {
      Image($r('app.media.nba'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'fighter') {
      Image($r('app.media.fighter'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'Palworld') {
      Image($r('app.media.Palworld'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'party') {
      Image($r('app.media.party'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'monster') {
      Image($r('app.media.monster'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'OverCooked') {
      Image($r('app.media.OverCooked'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_fields1') {
      Image($r('app.media.scrape_fields1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_fields2') {
      Image($r('app.media.scrape_fields2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_honor1') {
      Image($r('app.media.scrape_honor1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_honor2') {
      Image($r('app.media.scrape_honor2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_tom1') {
      Image($r('app.media.scrape_tom1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_gf1') {
      Image($r('app.media.scrape_gf1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_greenhell1') {
      Image($r('app.media.scrape_greenhell1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_jiahao1') {
      Image($r('app.media.scrape_jiahao1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_muse1') {
      Image($r('app.media.scrape_muse1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_doubao1') {
      Image($r('app.media.scrape_doubao1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_messi1') {
      Image($r('app.media.scrape_messi1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_cxmt1') {
      Image($r('app.media.scrape_cxmt1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_wzry1') {
      Image($r('app.media.scrape_wzry1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_cf1') {
      Image($r('app.media.scrape_cf1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_cf2') {
      Image($r('app.media.scrape_cf2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_cf3') {
      Image($r('app.media.scrape_cf3'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (img.mediaKey === 'scrape_cf4') {
      Image($r('app.media.scrape_cf4'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(img.placeholderColor)
    }
  }

  @Builder
  ImageTileBuilder(img: PostImage, tileWidth: Length, tileHeight: number, showCount: boolean) {
    Stack({ alignContent: Alignment.BottomEnd }) {
      this.MediaImageBuilder(img)

      if (showCount && this.post.imageCount > this.post.images.length) {
        Text(`共${this.post.imageCount}张`)
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
  RightImageBodyBuilder() {
    Row() {
      Column() {
        Text(this.post.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)
        Text(this.post.summary)
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

      if (this.post.images.length > 0) {
        this.ImageTileBuilder(this.post.images[0], 108, 108, false)
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  GridImagesBuilder() {
    if (this.post.images.length === 1) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        this.MediaImageBuilder(this.post.images[0])
        if (this.post.imageCount > 1) {
          Text(`共${this.post.imageCount}张`)
            .fontSize(10)
            .fontColor(Color.White)
            .backgroundColor('rgba(0,0,0,0.55)')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .borderRadius(4)
            .margin({ right: 6, bottom: 6 })
        }
      }
      .width('100%')
      .aspectRatio(this.mediaAspectRatio(this.post.images[0].mediaKey))
      .clip(true)
      .borderRadius(8)
      .backgroundColor(this.post.images[0].placeholderColor)
    } else if (this.post.images.length === 2) {
      Row({ space: 6 }) {
        Stack({ alignContent: Alignment.BottomEnd }) {
          this.MediaImageBuilder(this.post.images[0])
        }
        .layoutWeight(1)
        .height(110)
        .clip(true)
        .borderRadius(8)

        Stack({ alignContent: Alignment.BottomEnd }) {
          this.MediaImageBuilder(this.post.images[1])
          if (this.post.imageCount > 2) {
            Text(`共${this.post.imageCount}张`)
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
    } else if (this.post.images.length >= 3) {
      Row({ space: 6 }) {
        Stack() {
          this.MediaImageBuilder(this.post.images[0])
        }
        .layoutWeight(1.25)
        .height(150)
        .clip(true)
        .borderRadius(8)

        Column({ space: 6 }) {
          Stack() {
            this.MediaImageBuilder(this.post.images[1])
          }
          .width('100%')
          .height(72)
          .clip(true)
          .borderRadius(8)

          Stack({ alignContent: Alignment.BottomEnd }) {
            this.MediaImageBuilder(this.post.images[2])
            if (this.post.imageCount > 3) {
              Text(`共${this.post.imageCount}张`)
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
  FooterBuilder() {
    Row() {
      if (this.variant === 'follow') {
        Row() {
          if (this.post.gameTag !== '') {
            Text(this.post.gameTag)
              .fontSize(11)
              .fontColor('#666666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({ maxWidth: 140 })
          } else if (this.post.tagText !== '') {
            Text(`# ${this.post.tagText}`)
              .fontSize(11)
              .fontColor(this.tagColor())
              .backgroundColor(this.tagBg())
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
          }
          if (this.post.timeText !== '') {
            Text(this.post.timeText)
              .fontSize(11)
              .fontColor('#B0B0B0')
              .margin({ left: 8 })
          }
        }
        .layoutWeight(1)
      } else {
        Row() {
          if (this.post.tagText !== '') {
            Text(this.post.tagText)
              .fontSize(11)
              .fontColor(this.tagColor())
              .backgroundColor(this.tagBg())
              .padding({ left: 6, right: 6, top: 3, bottom: 3 })
              .borderRadius(4)
          }
        }
        .layoutWeight(1)
      }

      Row() {
        Text('💬')
          .fontSize(13)
          .fontColor('#B0B0B0')
        Text(`${this.displayCommentCount()}`)
          .fontSize(12)
          .fontColor('#B0B0B0')
          .margin({ left: 3, right: 14 })
        Text('👍')
          .fontSize(13)
          .fontColor('#B0B0B0')
        Text(`${this.displayLikeCount()}`)
          .fontSize(12)
          .fontColor('#B0B0B0')
          .margin({ left: 3 })
      }
    }
    .width('100%')
    .margin({ top: 10 })
  }

  build() {
    Column() {
      Row() {
        this.AvatarBuilder(34, this.post.authorAvatarColor, this.post.authorAvatarText)

        Row() {
          Text(this.post.authorName)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })

          if (this.post.isOfficial) {
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

          if (this.post.levelLabel !== '') {
            Text(this.post.levelLabel)
              .fontSize(10)
              .fontColor('#C47B00')
              .backgroundColor('#FFF3D6')
              .padding({ left: 5, right: 5, top: 1, bottom: 1 })
              .borderRadius(4)
              .margin({ left: 6 })
          }

          if (this.post.isFollowing && this.variant === 'recommend') {
            Text('你的关注')
              .fontSize(10)
              .fontColor('#888888')
              .backgroundColor('#F0F0F0')
              .padding({ left: 6, right: 6, top: 1, bottom: 1 })
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

      if (this.post.imageLayout === 'right') {
        this.RightImageBodyBuilder()
      } else {
        Text(this.post.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(22)
          .width('100%')

        if (this.post.summary !== '') {
          Text(this.post.summary)
            .fontSize(13)
            .fontColor('#8A8A8A')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 6 })
            .lineHeight(18)
            .width('100%')
        }

        if (this.post.images.length > 0) {
          Column() {
            this.GridImagesBuilder()
          }
          .width('100%')
          .margin({ top: 10 })
        }
      }

      this.FooterBuilder()
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      router.pushUrl({
        url: HomeRoutes.POST_DETAIL,
        params: { id: this.post.id },
      });
    })
  }
}
