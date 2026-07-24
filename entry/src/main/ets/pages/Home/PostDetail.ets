import { promptAction, router } from '@kit.ArkUI';
import {
  CommentReply,
  PostComment,
  PostDetail as PostDetailModel,
  getPostDetailById,
} from '../../model/HomeModel';

@Entry
@Component
struct PostDetail {
  @State detail: PostDetailModel | undefined = undefined;
  /** 0 正文区可见为主，1 已滚入评论区（顶栏样式） */
  @State headerMode: number = 0;
  @State expandedCommentIds: string[] = [];
  @State following: boolean = false;
  @State liked: boolean = false;
  @State starred: boolean = false;
  @State awarded: boolean = false;
  @State likeCount: number = 0;
  @State starCount: number = 0;
  @State awardCount: number = 0;
  @State commentCount: number = 0;
  @State comments: PostComment[] = [];
  @State draft: string = '';
  @State showComposer: boolean = false;
  private listScroller: Scroller = new Scroller();
  private jumpToComment: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    const tab = params ? (params['tab'] as string) : '';
    this.detail = getPostDetailById(id);
    if (this.detail) {
      this.following = this.detail.isFollowing;
      this.likeCount = this.detail.likeCount;
      this.starCount = this.detail.starCount;
      this.awardCount = this.detail.awardCount;
      this.commentCount = this.detail.commentCount;
      this.comments = this.detail.comments.slice();
    }
    if (tab === 'comment') {
      this.jumpToComment = true;
    }
  }

  onPageShow(): void {
    if (this.jumpToComment) {
      this.jumpToComment = false;
      this.scrollToComments();
    }
  }

  private scrollToBody(): void {
    this.listScroller.scrollToIndex(0);
    this.headerMode = 0;
  }

  private scrollToComments(): void {
    this.listScroller.scrollToIndex(1);
    this.headerMode = 1;
  }

  private isExpanded(id: string): boolean {
    return this.expandedCommentIds.indexOf(id) >= 0;
  }

  private toggleExpand(id: string): void {
    const idx = this.expandedCommentIds.indexOf(id);
    const next: string[] = [];
    for (let i = 0; i < this.expandedCommentIds.length; i++) {
      if (i !== idx) {
        next.push(this.expandedCommentIds[i]);
      }
    }
    if (idx < 0) {
      next.push(id);
    }
    this.expandedCommentIds = next;
  }

  private visibleReplies(comment: PostComment): CommentReply[] {
    if (this.isExpanded(comment.id)) {
      return comment.replies;
    }
    const preview: CommentReply[] = [];
    const limit = Math.min(2, comment.replies.length);
    for (let i = 0; i < limit; i++) {
      preview.push(comment.replies[i]);
    }
    return preview;
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

  private toggleStar(): void {
    if (this.starred) {
      this.starred = false;
      this.starCount = this.starCount - 1;
    } else {
      this.starred = true;
      this.starCount = this.starCount + 1;
    }
  }

  private toggleAward(): void {
    if (this.awarded) {
      this.awarded = false;
      this.awardCount = this.awardCount - 1;
    } else {
      this.awarded = true;
      this.awardCount = this.awardCount + 1;
      promptAction.showToast({ message: '充电成功（mock）', duration: 1500 });
    }
  }

  private submitComment(): void {
    const text = this.draft.trim();
    if (text.length === 0) {
      promptAction.showToast({ message: '先写点什么吧', duration: 1200 });
      return;
    }
    if (!this.detail) {
      return;
    }
    const item: PostComment = {
      id: `local-${Date.now()}`,
      authorName: '我',
      authorAvatarColor: '#1A1A1A',
      authorAvatarText: '我',
      levelLabel: 'Lv.1',
      isAuthor: false,
      isOfficial: false,
      isPinned: false,
      timeText: '刚刚',
      region: '本地',
      content: text,
      imageKey: '',
      imageColor: '',
      likeCount: 0,
      replyTotal: 0,
      replies: [],
    };
    const next: PostComment[] = [item];
    for (let i = 0; i < this.comments.length; i++) {
      next.push(this.comments[i]);
    }
    this.comments = next;
    this.commentCount = this.commentCount + 1;
    this.draft = '';
    this.showComposer = false;
    this.scrollToComments();
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
  MediaByKey(key: string, color: string) {
    if (key === 'chain') {
      Image($r('app.media.chain'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'mita') {
      Image($r('app.media.mita'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'nba') {
      Image($r('app.media.nba'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'fighter') {
      Image($r('app.media.fighter'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'Palworld') {
      Image($r('app.media.Palworld'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'party') {
      Image($r('app.media.party'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'monster') {
      Image($r('app.media.monster'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else if (key === 'OverCooked') {
      Image($r('app.media.OverCooked'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
    } else {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(color.length > 0 ? color : '#E8E8EC')
    }
  }

  @Builder
  TopBarBuilder(d: PostDetailModel) {
    if (this.headerMode === 0) {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor('#1A1A1A')
          .width(36)
          .onClick(() => router.back())

        Row() {
          Column() {
            Text('正文')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
            Row()
              .width(28)
              .height(3)
              .borderRadius(2)
              .backgroundColor('#1A1A1A')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Center)
          .onClick(() => this.scrollToBody())

          Text('评论')
            .fontSize(16)
            .fontColor('#B0B0B0')
            .margin({ left: 28 })
            .onClick(() => this.scrollToComments())
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)

        Text('⇧')
          .fontSize(18)
          .fontColor('#1A1A1A')
          .width(36)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .height(48)
      .padding({ left: 8, right: 12 })
    } else {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor('#1A1A1A')
          .width(36)
          .onClick(() => router.back())

        this.AvatarBuilder(28, d.authorAvatarColor, d.authorAvatarText)

        Text(d.authorName)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
          .margin({ left: 8 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxWidth: 120 })

        Text(this.following ? '已关注' : '+ 关注')
          .fontSize(12)
          .fontColor(this.following ? '#666666' : Color.White)
          .backgroundColor(this.following ? '#F0F0F0' : '#1A1A1A')
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .borderRadius(14)
          .margin({ left: 8 })
          .onClick(() => {
            this.following = !this.following;
          })

        Blank()

        Text('⇧')
          .fontSize(18)
          .fontColor('#1A1A1A')
      }
      .width('100%')
      .height(48)
      .padding({ left: 8, right: 12 })
    }
  }

  @Builder
  BodyContentBuilder(d: PostDetailModel) {
    Column() {
      Text(d.fullTitle)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .lineHeight(28)
        .width('100%')

      Row() {
        this.AvatarBuilder(40, d.authorAvatarColor, d.authorAvatarText)

        Column() {
          Row() {
            Text(d.authorName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            if (d.isOfficial) {
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
            if (d.levelLabel !== '') {
              Text(d.levelLabel)
                .fontSize(10)
                .fontColor('#C47B00')
                .backgroundColor('#FFF3D6')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(4)
                .margin({ left: 6 })
            }
          }
          Text(`${d.publishTime}·${d.region}`)
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

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(d.circles, (c: string) => {
          Text(c)
            .fontSize(12)
            .fontColor('#333333')
            .backgroundColor('#F3F4F6')
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(6)
            .margin({ right: 8, top: 10 })
        }, (c: string) => c)

        if (d.hotTag !== '') {
          Text(d.hotTag)
            .fontSize(12)
            .fontColor('#FF5A5A')
            .backgroundColor('#FFF0F0')
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(6)
            .margin({ right: 8, top: 10 })
        }
      }
      .width('100%')

      Stack({ alignContent: Alignment.BottomEnd }) {
        this.MediaByKey(d.heroMediaKey, d.heroColor)
        Text('小黑盒')
          .fontSize(11)
          .fontColor('rgba(255,255,255,0.85)')
          .margin({ right: 10, bottom: 10 })
      }
      .width('100%')
      .height(200)
      .borderRadius(10)
      .clip(true)
      .margin({ top: 14 })

      if (d.caption !== '') {
        Text(d.caption)
          .fontSize(15)
          .fontColor('#1A1A1A')
          .lineHeight(24)
          .margin({ top: 14 })
          .width('100%')
      }

      if (d.relatedLink !== '') {
        Text(`📄 ${d.relatedLink}`)
          .fontSize(14)
          .fontColor('#3B6FE0')
          .lineHeight(22)
          .margin({ top: 12 })
          .width('100%')
      }

      ForEach(d.bodyParagraphs, (p: string) => {
        Text(p)
          .fontSize(15)
          .fontColor('#1A1A1A')
          .lineHeight(26)
          .margin({ top: 14 })
          .width('100%')
      }, (p: string) => p)

      if (d.authorNote !== '') {
        Column() {
          Row() {
            Text(d.authorName)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            Text('作者')
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor('#555555')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ left: 6 })
          }
          Text(d.authorNote)
            .fontSize(14)
            .fontColor('#333333')
            .lineHeight(22)
            .margin({ top: 8 })
            .width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(12)
        .backgroundColor('#F7F8FA')
        .borderRadius(10)
        .margin({ top: 18 })
      }

      if (d.relatedSearch !== '') {
        Row() {
          Text(`🔍 相关搜索·${d.relatedSearch}`)
            .fontSize(13)
            .fontColor('#555555')
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('去搜索 >')
            .fontSize(12)
            .fontColor('#B0B0B0')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F5F7FA')
        .borderRadius(10)
        .margin({ top: 14 })
      }

      if (d.collectionName !== '') {
        Row() {
          Text(`📁 ${d.collectionName}`)
            .fontSize(13)
            .fontColor('#555555')
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${d.collectionProgress} >`)
            .fontSize(12)
            .fontColor('#B0B0B0')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F5F7FA')
        .borderRadius(10)
        .margin({ top: 10 })
      }

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(d.topicTags, (t: string) => {
          Text(`# ${t}`)
            .fontSize(12)
            .fontColor('#3B6FE0')
            .backgroundColor('#EEF3FF')
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .borderRadius(6)
            .margin({ right: 8, top: 10 })
        }, (t: string) => t)
      }
      .width('100%')
      .margin({ top: 6, bottom: 8 })

      Text('原创')
        .fontSize(12)
        .fontColor('#B0B0B0')
        .width('100%')
        .margin({ bottom: 8 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  ReplyLineBuilder(reply: CommentReply) {
    Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
      Text(reply.authorName)
        .fontSize(13)
        .fontColor('#3B6FE0')
      if (reply.isAuthor) {
        Text('作者')
          .fontSize(10)
          .fontColor(Color.White)
          .backgroundColor('#555555')
          .padding({ left: 4, right: 4, top: 1, bottom: 1 })
          .borderRadius(3)
          .margin({ left: 4 })
      }
      if (reply.replyToName !== '') {
        Text(` 回复 ${reply.replyToName}`)
          .fontSize(13)
          .fontColor('#888888')
      }
      Text(`: ${reply.content}`)
        .fontSize(13)
        .fontColor('#333333')
      Text(` ${reply.timeText}·${reply.region}`)
        .fontSize(11)
        .fontColor('#B0B0B0')
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  @Builder
  CommentItemBuilder(comment: PostComment) {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.TopStart }) {
          this.AvatarBuilder(36, comment.authorAvatarColor, comment.authorAvatarText)
          if (comment.isPinned) {
            Text('置顶')
              .fontSize(9)
              .fontColor(Color.White)
              .backgroundColor('#1A1A1A')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius({ topLeft: 8, bottomRight: 6 })
          }
        }

        Column() {
          Row() {
            Text(comment.authorName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            if (comment.isAuthor) {
              Text('作者')
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('#555555')
                .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                .borderRadius(3)
                .margin({ left: 4 })
            }
            if (comment.isOfficial) {
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
            if (comment.levelLabel !== '') {
              Text(comment.levelLabel)
                .fontSize(10)
                .fontColor('#C47B00')
                .backgroundColor('#FFF3D6')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(4)
                .margin({ left: 6 })
            }
            Blank()
            Text(`👍 ${comment.likeCount}`)
              .fontSize(12)
              .fontColor('#B0B0B0')
          }
          .width('100%')

          Text(`${comment.timeText}·${comment.region}`)
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ top: 2 })

          Text(comment.content)
            .fontSize(15)
            .fontColor('#1A1A1A')
            .lineHeight(22)
            .margin({ top: 8 })
            .width('100%')

          if (comment.imageKey !== '') {
            Stack() {
              this.MediaByKey(comment.imageKey, comment.imageColor)
            }
            .width(120)
            .height(90)
            .borderRadius(8)
            .clip(true)
            .margin({ top: 8 })
          }

          if (comment.replies.length > 0) {
            Column() {
              ForEach(this.visibleReplies(comment), (r: CommentReply) => {
                this.ReplyLineBuilder(r)
              }, (r: CommentReply) => r.id)

              if (comment.replyTotal > 2 || comment.replies.length > 2) {
                Row() {
                  if (this.isExpanded(comment.id)) {
                    Text('查看更多回复 ▾')
                      .fontSize(13)
                      .fontColor('#888888')
                      .layoutWeight(1)
                    Text('收起')
                      .fontSize(13)
                      .fontColor('#888888')
                      .onClick(() => this.toggleExpand(comment.id))
                  } else {
                    Text(`全部 ${comment.replyTotal} 条回复 ▾`)
                      .fontSize(13)
                      .fontColor('#888888')
                      .width('100%')
                      .textAlign(TextAlign.Center)
                      .onClick(() => this.toggleExpand(comment.id))
                  }
                }
                .width('100%')
                .margin({ top: 2 })
              }
            }
            .width('100%')
            .padding(10)
            .backgroundColor('#F5F6F8')
            .borderRadius(8)
            .margin({ top: 10 })
            .alignItems(HorizontalAlign.Start)
          }
        }
        .layoutWeight(1)
        .margin({ left: 10 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      Divider()
        .color('#F0F0F0')
        .strokeWidth(0.5)
        .margin({ top: 14, bottom: 14 })
    }
    .width('100%')
  }

  @Builder
  CommentSectionBuilder() {
    Column() {
      Divider()
        .color('#F0F0F0')
        .strokeWidth(8)
        .margin({ bottom: 12 })

      Row() {
        Text(`评论 ${this.commentCount}`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
        Blank()
        Text('热门')
          .fontSize(13)
          .fontColor('#888888')
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 12 })

      Column() {
        ForEach(this.comments, (c: PostComment) => {
          this.CommentItemBuilder(c)
        }, (c: PostComment) => c.id)
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      Text('已经到底了')
        .fontSize(12)
        .fontColor('#C0C0C0')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 4, bottom: 24 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  BottomBarBuilder() {
    Column() {
      if (this.showComposer) {
        Row() {
          TextInput({ text: this.draft, placeholder: '来说点什么吧!' })
            .layoutWeight(1)
            .height(36)
            .fontSize(14)
            .backgroundColor('#F3F4F6')
            .borderRadius(18)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.draft = value;
            })
          Text('发送')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#1A1A1A')
            .padding({ left: 14, right: 14, top: 8, bottom: 8 })
            .borderRadius(16)
            .margin({ left: 8 })
            .onClick(() => this.submitComment())
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 8 })
      }

      Row() {
        Text(this.showComposer ? '收起输入' : '来说点什么吧!')
          .fontSize(13)
          .fontColor('#B0B0B0')
          .layoutWeight(1)
          .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          .backgroundColor('#F3F4F6')
          .borderRadius(20)
          .onClick(() => {
            this.showComposer = !this.showComposer;
          })

        Column() {
          Text('👍')
            .fontSize(18)
            .fontColor(this.liked ? '#FF5A5A' : '#1A1A1A')
          Text(`${this.likeCount}`)
            .fontSize(10)
            .fontColor(this.liked ? '#FF5A5A' : '#666666')
            .fontWeight(this.liked ? FontWeight.Medium : FontWeight.Normal)
            .margin({ top: 2 })
        }
        .width(44)
        .margin({ left: 6 })
        .onClick(() => this.toggleLike())

        Column() {
          Text(this.starred ? '★' : '☆')
            .fontSize(18)
            .fontColor(this.starred ? '#F5A623' : '#1A1A1A')
          Text(`${this.starCount}`)
            .fontSize(10)
            .fontColor(this.starred ? '#F5A623' : '#666666')
            .margin({ top: 2 })
        }
        .width(44)
        .onClick(() => this.toggleStar())

        Column() {
          Text('⚡')
            .fontSize(18)
            .fontColor(this.awarded ? '#FF7A00' : '#1A1A1A')
          Text(`${this.awardCount}`)
            .fontSize(10)
            .fontColor(this.awarded ? '#FF7A00' : '#666666')
            .margin({ top: 2 })
        }
        .width(44)
        .onClick(() => this.toggleAward())

        Column() {
          Text('💬')
            .fontSize(18)
          Text(`${this.commentCount}`)
            .fontSize(10)
            .fontColor('#666666')
            .margin({ top: 2 })
        }
        .width(44)
        .onClick(() => {
          this.showComposer = true;
          this.scrollToComments();
        })
      }
      .width('100%')
      .padding({ left: 12, right: 8, top: 8, bottom: 8 })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: '#F0F0F0' })
  }

  build() {
    Column() {
      if (this.detail) {
        this.TopBarBuilder(this.detail)

        List({ scroller: this.listScroller }) {
          ListItem() {
            this.BodyContentBuilder(this.detail)
          }

          ListItem() {
            this.CommentSectionBuilder()
          }
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .onScrollIndex((start: number) => {
          this.headerMode = start >= 1 ? 1 : 0;
        })

        this.BottomBarBuilder()
      } else {
        Row() {
          Text('‹')
            .fontSize(28)
            .fontColor('#1A1A1A')
            .onClick(() => router.back())
          Text('帖子不存在')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ left: 12 })
        }
        .width('100%')
        .padding(16)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
