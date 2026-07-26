import { promptAction, router } from '@kit.ArkUI';
import { FeedComment, FeedDetail, FeedImage } from '../model/types/FeedModel';
import { getFeedDetailSync } from '../api/FeedApi';
import { getProfileCoverSync } from '../api/MediaApi';

/**
 * 个人动态详情（Profile 自包含）
 * 版式对照 Home PostDetailPage：顶栏正文/评论、作者行、圈子标签、头图、分段正文、底栏赞藏充评
 * 资源仅走 Profile MediaApi，不 import home
 */
@Component
export struct FeedDetailPage {
  @State detail: FeedDetail | undefined = undefined;
  /** 0 正文，1 评论区 */
  @State headerMode: number = 0;
  @State liked: boolean = false;
  @State starred: boolean = false;
  @State awarded: boolean = false;
  @State likeCount: number = 0;
  @State starCount: number = 0;
  @State awardCount: number = 0;
  @State comments: FeedComment[] = [];
  @State commentCount: number = 0;
  @State draft: string = '';
  @State showComposer: boolean = false;
  @State following: boolean = false;
  private listScroller: Scroller = new Scroller();

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    this.detail = getFeedDetailSync(id);
    if (this.detail !== undefined) {
      this.likeCount = this.detail.likeCount;
      this.commentCount = this.detail.commentCount;
      this.starCount = this.detail.starCount !== undefined ? this.detail.starCount : 0;
      this.awardCount = this.detail.awardCount !== undefined ? this.detail.awardCount : 0;
      this.comments = this.detail.commentList.slice();
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

  private avatarColor(d: FeedDetail): string {
    return d.authorAvatarColor !== undefined ? d.authorAvatarColor : '#1A1A1A';
  }

  private paragraphs(d: FeedDetail): string[] {
    if (d.bodyParagraphs !== undefined && d.bodyParagraphs.length > 0) {
      return d.bodyParagraphs;
    }
    if (d.fullContent.length > 0) {
      return [d.fullContent];
    }
    return [d.summary];
  }

  private circlesOf(d: FeedDetail): string[] {
    return d.circles !== undefined ? d.circles : [];
  }

  private topicsOf(d: FeedDetail): string[] {
    return d.topicTags !== undefined ? d.topicTags : [];
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
    const item: FeedComment = {
      id: `local-${Date.now()}`,
      authorName: '我',
      authorAvatarChar: '我',
      authorAvatarColor: '#1A1A1A',
      timeText: '刚刚',
      region: '本地',
      content: text,
      likeCount: 0,
      levelLabel: 'Lv.1',
      isAuthor: true,
    };
    const next: FeedComment[] = [item];
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
    if (key !== '') {
      Image(getProfileCoverSync(key))
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
  TopBarBuilder(d: FeedDetail) {
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

        this.AvatarBuilder(28, this.avatarColor(d), d.authorAvatarChar)

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
  HeroBuilder(d: FeedDetail) {
    if (d.hasCover || (d.coverMediaKey !== undefined && d.coverMediaKey !== '')) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        if (d.coverMediaKey !== undefined && d.coverMediaKey !== '') {
          this.MediaByKey(d.coverMediaKey, d.coverColors[0])
        } else {
          Column()
            .width('100%')
            .height('100%')
            .linearGradient({
              angle: 135,
              colors: [
                [d.coverColors[0], 0],
                [d.coverColors[1], 1],
              ],
            })
        }
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
    }
  }

  @Builder
  BodyContentBuilder(d: FeedDetail) {
    Column() {
      Text(d.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .lineHeight(28)
        .width('100%')

      Row() {
        this.AvatarBuilder(40, this.avatarColor(d), d.authorAvatarChar)

        Column() {
          Row() {
            Text(d.authorName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            if (d.isOfficial === true) {
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
            if (d.authorLevel !== '') {
              Text(d.authorLevel)
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
        ForEach(this.circlesOf(d), (c: string) => {
          Text(c)
            .fontSize(12)
            .fontColor('#333333')
            .backgroundColor('#F3F4F6')
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(6)
            .margin({ right: 8, top: 10 })
        }, (c: string) => c)

        if (d.tag !== '') {
          Text(d.tag)
            .fontSize(12)
            .fontColor(d.tagTone === 'hot' ? '#FF5A5A' : '#333333')
            .backgroundColor(d.tagTone === 'hot' ? '#FFF0F0' : '#F3F4F6')
            .padding({ left: 10, right: 10, top: 5, bottom: 5 })
            .borderRadius(6)
            .margin({ right: 8, top: 10 })
        }
      }
      .width('100%')

      this.HeroBuilder(d)

      ForEach(this.paragraphs(d), (p: string) => {
        Text(p)
          .fontSize(15)
          .fontColor('#1A1A1A')
          .lineHeight(26)
          .margin({ top: 14 })
          .width('100%')
      }, (p: string) => p)

      if (d.relatedSearch !== undefined && d.relatedSearch !== '') {
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

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.topicsOf(d), (t: string) => {
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
  CommentItemBuilder(c: FeedComment) {
    Column() {
      Row() {
        this.AvatarBuilder(36, c.authorAvatarColor, c.authorAvatarChar)

        Column() {
          Row() {
            Text(c.authorName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
            if (c.isAuthor === true) {
              Text('作者')
                .fontSize(10)
                .fontColor(Color.White)
                .backgroundColor('#555555')
                .padding({ left: 4, right: 4, top: 1, bottom: 1 })
                .borderRadius(3)
                .margin({ left: 4 })
            }
            if (c.levelLabel !== undefined && c.levelLabel !== '') {
              Text(c.levelLabel)
                .fontSize(10)
                .fontColor('#C47B00')
                .backgroundColor('#FFF3D6')
                .padding({ left: 5, right: 5, top: 1, bottom: 1 })
                .borderRadius(4)
                .margin({ left: 6 })
            }
            Blank()
            Text(`👍 ${c.likeCount}`)
              .fontSize(12)
              .fontColor('#B0B0B0')
          }
          .width('100%')

          Text(
            c.region !== undefined && c.region !== ''
              ? `${c.timeText}·${c.region}`
              : c.timeText
          )
            .fontSize(11)
            .fontColor('#B0B0B0')
            .margin({ top: 2 })

          Text(c.content)
            .fontSize(15)
            .fontColor('#1A1A1A')
            .lineHeight(22)
            .margin({ top: 8 })
            .width('100%')
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
            this.CommentItemBuilder(c)
          }, (c: FeedComment) => c.id)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }

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
      if (this.detail !== undefined) {
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
          Text('动态不存在')
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
