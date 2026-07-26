import { promptAction, router } from '@kit.ArkUI';
import { FeedComment, FeedDetail } from '../model/types/FeedModel';
import { getFeedDetailSync } from '../api/FeedApi';

/**
 * 个人动态详情（Profile 自包含）
 * 入参：router params { id: string }
 * 由 entry 壳 pages/Profile/FeedDetail 挂载
 */
@Component
export struct FeedDetailPage {
  @State detail: FeedDetail | undefined = undefined;
  @State liked: boolean = false;
  @State likeCount: number = 0;
  @State comments: FeedComment[] = [];
  @State commentCount: number = 0;
  @State draft: string = '';
  @State following: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    this.detail = getFeedDetailSync(id);
    if (this.detail !== undefined) {
      this.likeCount = this.detail.likeCount;
      this.commentCount = this.detail.commentCount;
      this.comments = this.detail.commentList.slice();
    }
  }

  private toggleLike(): void {
    if (this.liked) {
      this.liked = false;
      this.likeCount = this.likeCount - 1;
    } else {
      this.liked = true;
      this.likeCount = this.likeCount + 1;
    }
  }

  private submitComment(): void {
    const text = this.draft.trim();
    if (text.length === 0) {
      promptAction.showToast({ message: '先写点什么吧', duration: 1200 });
      return;
    }
    const item: FeedComment = {
      id: `local-${Date.now()}`,
      authorName: '我',
      authorAvatarChar: '我',
      authorAvatarColor: '#1A1A1A',
      timeText: '刚刚 · 本地',
      content: text,
      likeCount: 0,
    };
    const next: FeedComment[] = [item];
    for (let i = 0; i < this.comments.length; i++) {
      next.push(this.comments[i]);
    }
    this.comments = next;
    this.commentCount = this.commentCount + 1;
    this.draft = '';
    promptAction.showToast({ message: '评论已发布（mock）', duration: 1200 });
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
  TopBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(28)
        .fontColor('#1A1A1A')
        .width(36)
        .onClick(() => router.back())

      Text('动态详情')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Text('⇧')
        .fontSize(18)
        .fontColor('#1A1A1A')
        .width(36)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
    .backgroundColor(Color.White)
  }

  @Builder
  CoverBuilder(d: FeedDetail) {
    if (d.hasCover) {
      Column() {
        Text(d.tag)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .borderRadius(4)
          .backgroundColor('rgba(0,0,0,0.35)')
          .margin({ left: 14, bottom: 14 })
      }
      .width('100%')
      .height(160)
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Start)
      .linearGradient({
        angle: 135,
        colors: [
          [d.coverColors[0], 0],
          [d.coverColors[1], 1],
        ],
      })
      .clip(true)
      .borderRadius(12)
      .margin({ top: 8 })
    }
  }

  @Builder
  BodyBuilder(d: FeedDetail) {
    Column() {
      Row() {
        Text(d.tag)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor('#2BC48A')
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .borderRadius(4)
          .backgroundColor('rgba(43,196,138,0.10)')

        Text(d.meta)
          .fontSize(11)
          .fontColor('#B0B0B0')
          .margin({ left: 10 })
      }
      .width('100%')
      .margin({ top: 4 })

      Text(d.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .lineHeight(28)
        .width('100%')
        .margin({ top: 12 })

      Row() {
        this.AvatarBuilder(40, '#1A1A1A', d.authorAvatarChar)

        Column() {
          Row() {
            Text(d.authorName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            Text(d.authorLevel)
              .fontSize(10)
              .fontColor('#C47B00')
              .backgroundColor('#FFF3D6')
              .padding({ left: 5, right: 5, top: 1, bottom: 1 })
              .borderRadius(4)
              .margin({ left: 6 })
          }
          Text(`${d.publishTime} · ${d.region}`)
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 10 })
        .layoutWeight(1)

        Text(this.following ? '已关注' : '+ 关注')
          .fontSize(13)
          .fontColor(this.following ? '#666666' : Color.White)
          .backgroundColor(this.following ? '#F0F0F0' : '#1A1A1A')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(16)
          .onClick(() => {
            this.following = !this.following;
          })
      }
      .width('100%')
      .margin({ top: 16 })

      this.CoverBuilder(d)

      Text(d.fullContent)
        .fontSize(15)
        .fontColor('#333333')
        .lineHeight(24)
        .width('100%')
        .margin({ top: 16 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  CommentItemBuilder(c: FeedComment) {
    Row() {
      this.AvatarBuilder(36, c.authorAvatarColor, c.authorAvatarChar)

      Column() {
        Row() {
          Text(c.authorName)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
          Blank()
          Text(`${c.likeCount}`)
            .fontSize(11)
            .fontColor('#B0B0B0')
        }
        .width('100%')

        Text(c.content)
          .fontSize(14)
          .fontColor('#333333')
          .lineHeight(22)
          .width('100%')
          .margin({ top: 6 })

        Text(c.timeText)
          .fontSize(11)
          .fontColor('#B0B0B0')
          .margin({ top: 6 })
      }
      .layoutWeight(1)
      .margin({ left: 10 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  CommentsBuilder() {
    Column() {
      Text(`评论 ${this.commentCount}`)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1A1A1A')
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 4 })

      if (this.comments.length === 0) {
        Text('还没有评论，来抢沙发')
          .fontSize(13)
          .fontColor('#B0B0B0')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 24, bottom: 24 })
      } else {
        Column() {
          ForEach(this.comments, (c: FeedComment) => {
            Column() {
              this.CommentItemBuilder(c)
              Divider().color('#F0F0F0').strokeWidth(0.5)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
          }, (c: FeedComment) => c.id)
        }
        .width('100%')
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
    .margin({ top: 8 })
  }

  @Builder
  BottomBarBuilder() {
    Row() {
      TextInput({ placeholder: '说点什么…', text: this.draft })
        .layoutWeight(1)
        .height(36)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .placeholderColor('#B0B0B0')
        .backgroundColor('#F0F0F2')
        .borderRadius(18)
        .padding({ left: 14, right: 14 })
        .onChange((v: string) => {
          this.draft = v;
        })

      Text(this.liked ? '已赞' : '赞')
        .fontSize(13)
        .fontColor(this.liked ? '#2BC48A' : '#666666')
        .margin({ left: 12 })
        .onClick(() => this.toggleLike())

      Text(`${this.likeCount}`)
        .fontSize(12)
        .fontColor('#B0B0B0')
        .margin({ left: 4, right: 8 })

      Text('发送')
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .padding({ left: 14, right: 14, top: 8, bottom: 8 })
        .borderRadius(16)
        .backgroundColor('#2BC48A')
        .onClick(() => this.submitComment())
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .border({ width: { top: 0.5 }, color: '#F0F0F0' })
  }

  @Builder
  EmptyBuilder() {
    Column({ space: 8 }) {
      Text('动态不存在')
        .fontSize(15)
        .fontColor('#999999')
      Text('返回重试')
        .fontSize(13)
        .fontColor('#2BC48A')
        .onClick(() => router.back())
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Column() {
      this.TopBarBuilder()

      if (this.detail === undefined) {
        this.EmptyBuilder()
      } else {
        Scroll() {
          Column() {
            this.BodyBuilder(this.detail)
            this.CommentsBuilder()
            Text('已经到底了')
              .fontSize(12)
              .fontColor('#B0B0B0')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 12, bottom: 28 })
          }
          .width('100%')
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor('#F7F7F8')

        this.BottomBarBuilder()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}
