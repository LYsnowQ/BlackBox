import { promptAction, router } from '@kit.ArkUI';
import { HomeInteractStore, LocalReplyBundle, PostInteractState } from '../model/HomeInteractStore';
import {
  CommentReply,
  PostComment,
  PostDetail as PostDetailModel,
  PostImage,
  followPosts,
  getPostDetailById,
  recommendPosts,
} from '../model/HomeModel';
import { HomeRoutes } from '../router/HomeRoutes';

/**
 * 帖子详情内容（由 entry 路由壳 pages/Home/PostDetail 挂载）
 */
@Component
export struct PostDetailPage {
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
  /** 回复目标：空串表示发一级评论 */
  @State replyToCommentId: string = '';
  @State replyToName: string = '';
  /** 本帖内已点赞的评论 id */
  @State likedCommentIds: string[] = [];
  private listScroller: Scroller = new Scroller();
  private jumpToComment: boolean = false;
  private postId: string = '';

  /** 资源宽/高；未知时用较中性的 4:3 */
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

  private feedImages(id: string): PostImage[] {
    for (let i = 0; i < recommendPosts.length; i++) {
      if (recommendPosts[i].id === id) {
        return recommendPosts[i].images;
      }
    }
    for (let i = 0; i < followPosts.length; i++) {
      if (followPosts[i].id === id) {
        return followPosts[i].images;
      }
    }
    return [];
  }

  private detailMediaKeys(d: PostDetailModel): string[] {
    const imgs = this.feedImages(d.id);
    const keys: string[] = [];
    for (let i = 0; i < imgs.length; i++) {
      if (imgs[i].mediaKey.length > 0) {
        keys.push(imgs[i].mediaKey);
      }
    }
    if (keys.length > 0) {
      return keys;
    }
    if (d.heroMediaKey.length > 0) {
      return [d.heroMediaKey];
    }
    return [];
  }

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const id = params ? (params['id'] as string) : '';
    const tab = params ? (params['tab'] as string) : '';
    this.postId = id;
    this.detail = getPostDetailById(id);
    if (this.detail) {
      this.applyBase(this.detail);
    }
    if (tab === 'comment') {
      this.jumpToComment = true;
    }
    const ctx = getContext(this) as Context;
    HomeInteractStore.ensureLoaded(ctx).then(() => {
      this.applyPersisted();
    });
  }

  private applyBase(d: PostDetailModel): void {
    this.following = d.isFollowing;
    this.liked = false;
    this.starred = false;
    this.awarded = false;
    this.likeCount = d.likeCount;
    this.starCount = d.starCount;
    this.awardCount = d.awardCount;
    this.commentCount = d.commentCount;
    this.comments = d.comments.slice();
  }

  private applyPersisted(): void {
    if (!this.detail || this.postId.length === 0) {
      return;
    }
    const saved = HomeInteractStore.get(this.postId);
    if (!saved) {
      return;
    }
    this.following = saved.following;
    this.liked = saved.liked;
    this.starred = saved.starred;
    this.awarded = saved.awarded;
    this.likeCount = saved.likeCount;
    this.starCount = saved.starCount;
    this.awardCount = saved.awardCount;
    this.commentCount = saved.commentCount;
    this.likedCommentIds = saved.likedCommentIds ? saved.likedCommentIds.slice() : [];
    const base: PostComment[] = [];
    for (let i = 0; i < this.detail.comments.length; i++) {
      const c = this.detail.comments[i];
      let extraRs: CommentReply[] = [];
      for (let b = 0; b < saved.extraReplies.length; b++) {
        if (saved.extraReplies[b].parentId === c.id) {
          extraRs = saved.extraReplies[b].replies;
          break;
        }
      }
      if (extraRs.length === 0) {
        base.push(c);
      } else {
        const replies: CommentReply[] = [];
        for (let r = 0; r < extraRs.length; r++) {
          replies.push(extraRs[r]);
        }
        for (let r = 0; r < c.replies.length; r++) {
          replies.push(c.replies[r]);
        }
        base.push(this.cloneComment(c, c.likeCount, replies, c.replyTotal + extraRs.length));
      }
    }
    const merged: PostComment[] = [];
    for (let i = 0; i < saved.extraComments.length; i++) {
      merged.push(saved.extraComments[i]);
    }
    for (let i = 0; i < base.length; i++) {
      merged.push(base[i]);
    }
    this.comments = merged;
  }

  private cloneComment(
    c: PostComment,
    likeCount: number,
    replies: CommentReply[],
    replyTotal: number
  ): PostComment {
    return {
      id: c.id,
      authorName: c.authorName,
      authorAvatarColor: c.authorAvatarColor,
      authorAvatarText: c.authorAvatarText,
      levelLabel: c.levelLabel,
      isAuthor: c.isAuthor,
      isOfficial: c.isOfficial,
      isPinned: c.isPinned,
      timeText: c.timeText,
      region: c.region,
      content: c.content,
      imageKey: c.imageKey,
      imageColor: c.imageColor,
      likeCount: likeCount,
      replyTotal: replyTotal,
      replies: replies,
    };
  }

  private isCommentLiked(id: string): boolean {
    return this.likedCommentIds.indexOf(id) >= 0;
  }

  /** 展示赞数 = mock/本地基数 + 当前用户是否点过；依赖 likedCommentIds 触发重绘 */
  private displayCommentLikeCount(comment: PostComment): number {
    const base = comment.likeCount;
    return this.isCommentLiked(comment.id) ? base + 1 : base;
  }

  private openUserProfile(
    name: string,
    avatarColor: string,
    avatarText: string,
    levelLabel: string = '',
    authorId: string = ''
  ): void {
    router.pushUrl({
      url: HomeRoutes.USER_PROFILE,
      params: {
        name: name,
        avatarColor: avatarColor,
        avatarText: avatarText,
        levelLabel: levelLabel,
        authorId: authorId,
      },
    });
  }

  private toggleCommentLike(commentId: string): void {
    const liked = this.isCommentLiked(commentId);
    const nextLiked: string[] = [];
    for (let i = 0; i < this.likedCommentIds.length; i++) {
      if (this.likedCommentIds[i] !== commentId) {
        nextLiked.push(this.likedCommentIds[i]);
      }
    }
    if (!liked) {
      nextLiked.push(commentId);
    }
    // 只改 @State 点赞集合；赞数由 displayCommentLikeCount 推导，避免 ForEach 同 key 不刷新数字
    this.likedCommentIds = nextLiked;
    this.persist();
  }

  private persist(): void {
    if (!this.detail || this.postId.length === 0) {
      return;
    }
    const extra: PostComment[] = [];
    const replyBundles: LocalReplyBundle[] = [];
    for (let i = 0; i < this.comments.length; i++) {
      const c = this.comments[i];
      if (c.id.indexOf('local-') === 0) {
        extra.push(c);
      } else {
        const localRs: CommentReply[] = [];
        for (let r = 0; r < c.replies.length; r++) {
          if (c.replies[r].id.indexOf('local-') === 0) {
            localRs.push(c.replies[r]);
          }
        }
        if (localRs.length > 0) {
          replyBundles.push({ parentId: c.id, replies: localRs });
        }
      }
    }
    const state: PostInteractState = {
      liked: this.liked,
      starred: this.starred,
      awarded: this.awarded,
      following: this.following,
      likeCount: this.likeCount,
      starCount: this.starCount,
      awardCount: this.awardCount,
      commentCount: this.commentCount,
      extraComments: extra,
      extraReplies: replyBundles,
      likedCommentIds: this.likedCommentIds.slice(),
    };
    HomeInteractStore.save(getContext(this) as Context, this.postId, state);
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
    this.persist();
  }

  private toggleStar(): void {
    if (this.starred) {
      this.starred = false;
      this.starCount = this.starCount - 1;
    } else {
      this.starred = true;
      this.starCount = this.starCount + 1;
    }
    this.persist();
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
    this.persist();
  }

  private toggleFollowing(): void {
    this.following = !this.following;
    this.persist();
  }

  private openComposer(commentId: string = '', name: string = ''): void {
    this.replyToCommentId = commentId;
    this.replyToName = name;
    this.showComposer = true;
    if (commentId.length > 0) {
      this.scrollToComments();
    }
  }

  private closeComposer(): void {
    this.showComposer = false;
    this.replyToCommentId = '';
    this.replyToName = '';
    this.draft = '';
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

    // 回复某条评论 → 挂到该楼层 replies
    if (this.replyToCommentId.length > 0) {
      const parentId = this.replyToCommentId;
      const reply: CommentReply = {
        id: `local-r-${Date.now()}`,
        authorName: '我',
        isAuthor: false,
        content: text,
        timeText: '刚刚',
        region: '本地',
        replyToName: this.replyToName,
      };
      const next: PostComment[] = [];
      for (let i = 0; i < this.comments.length; i++) {
        const c = this.comments[i];
        if (c.id === parentId) {
          const replies: CommentReply[] = [reply];
          for (let j = 0; j < c.replies.length; j++) {
            replies.push(c.replies[j]);
          }
          next.push(this.cloneComment(c, c.likeCount, replies, c.replyTotal + 1));
        } else {
          next.push(c);
        }
      }
      this.comments = next;
      this.commentCount = this.commentCount + 1;
      // 展开该楼，避免只预览前 2 条时看不到新回复；并依赖 ForEach key 含 replies.length 强制重绘
      if (this.expandedCommentIds.indexOf(parentId) < 0) {
        const exp: string[] = [];
        for (let i = 0; i < this.expandedCommentIds.length; i++) {
          exp.push(this.expandedCommentIds[i]);
        }
        exp.push(parentId);
        this.expandedCommentIds = exp;
      }
      this.closeComposer();
      this.scrollToComments();
      this.persist();
      promptAction.showToast({ message: '回复已发布（mock）', duration: 1200 });
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
    this.closeComposer();
    this.scrollToComments();
    this.persist();
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
        .objectFit(ImageFit.Contain)
    } else if (key === 'mita') {
      Image($r('app.media.mita'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'nba') {
      Image($r('app.media.nba'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'fighter') {
      Image($r('app.media.fighter'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'Palworld') {
      Image($r('app.media.Palworld'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'party') {
      Image($r('app.media.party'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'monster') {
      Image($r('app.media.monster'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'OverCooked') {
      Image($r('app.media.OverCooked'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_fields1') {
      Image($r('app.media.scrape_fields1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_fields2') {
      Image($r('app.media.scrape_fields2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_honor1') {
      Image($r('app.media.scrape_honor1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_honor2') {
      Image($r('app.media.scrape_honor2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_tom1') {
      Image($r('app.media.scrape_tom1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_gf1') {
      Image($r('app.media.scrape_gf1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_greenhell1') {
      Image($r('app.media.scrape_greenhell1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_jiahao1') {
      Image($r('app.media.scrape_jiahao1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_muse1') {
      Image($r('app.media.scrape_muse1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_doubao1') {
      Image($r('app.media.scrape_doubao1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_messi1') {
      Image($r('app.media.scrape_messi1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cxmt1') {
      Image($r('app.media.scrape_cxmt1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_wzry1') {
      Image($r('app.media.scrape_wzry1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf1') {
      Image($r('app.media.scrape_cf1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf2') {
      Image($r('app.media.scrape_cf2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf3') {
      Image($r('app.media.scrape_cf3'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf4') {
      Image($r('app.media.scrape_cf4'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
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

        Row() {
          this.AvatarBuilder(28, d.authorAvatarColor, d.authorAvatarText)
          Text(d.authorName)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
            .margin({ left: 8 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .constraintSize({ maxWidth: 120 })
        }
        .onClick(() => this.openUserProfile(
          d.authorName, d.authorAvatarColor, d.authorAvatarText, d.levelLabel))

        Text(this.following ? '已关注' : '+ 关注')
          .fontSize(12)
          .fontColor(this.following ? '#666666' : Color.White)
          .backgroundColor(this.following ? '#F0F0F0' : '#1A1A1A')
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .borderRadius(14)
          .margin({ left: 8 })
          .onClick(() => this.toggleFollowing())

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
        }
        .layoutWeight(1)
        .onClick(() => this.openUserProfile(
          d.authorName, d.authorAvatarColor, d.authorAvatarText, d.levelLabel))

        Text(this.following ? '已关注' : '+ 关注')
          .fontSize(13)
          .fontColor(this.following ? '#666666' : Color.White)
          .backgroundColor(this.following ? '#F0F0F0' : '#1A1A1A')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .borderRadius(16)
          .onClick(() => this.toggleFollowing())
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

      Column({ space: 8 }) {
        ForEach(this.detailMediaKeys(d), (key: string) => {
          Stack({ alignContent: Alignment.BottomEnd }) {
            this.MediaByKey(key, d.heroColor)
            Text('小黑盒')
              .fontSize(11)
              .fontColor('rgba(255,255,255,0.85)')
              .margin({ right: 10, bottom: 10 })
          }
          .width('100%')
          .aspectRatio(this.mediaAspectRatio(key))
          .borderRadius(10)
          .clip(true)
          .backgroundColor(d.heroColor.length > 0 ? d.heroColor : '#F3F4F6')
        }, (key: string) => key)
      }
      .width('100%')
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
        .onClick(() => this.openUserProfile(
          comment.authorName, comment.authorAvatarColor, comment.authorAvatarText, comment.levelLabel))

        Column() {
          Row() {
            Text(comment.authorName)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
              .onClick(() => this.openUserProfile(
                comment.authorName, comment.authorAvatarColor, comment.authorAvatarText, comment.levelLabel))
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
            Text(`👍 ${this.displayCommentLikeCount(comment)}`)
              .fontSize(12)
              .fontColor(this.isCommentLiked(comment.id) ? '#FF5A5A' : '#B0B0B0')
              .fontWeight(this.isCommentLiked(comment.id) ? FontWeight.Medium : FontWeight.Normal)
              .onClick(() => this.toggleCommentLike(comment.id))
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

          Text('回复')
            .fontSize(12)
            .fontColor('#888888')
            .margin({ top: 8 })
            .onClick(() => this.openComposer(comment.id, comment.authorName))

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
        }, (c: PostComment) => `${c.id}|r${c.replies.length}|t${c.replyTotal}`)
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
        if (this.replyToName.length > 0) {
          Row() {
            Text(`回复 @${this.replyToName}`)
              .fontSize(12)
              .fontColor('#888888')
              .layoutWeight(1)
            Text('取消')
              .fontSize(12)
              .fontColor('#3B6FE0')
              .onClick(() => {
                this.replyToCommentId = '';
                this.replyToName = '';
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 0 })
        }
        Row() {
          TextInput({
            text: this.draft,
            placeholder: this.replyToName.length > 0 ? `回复 ${this.replyToName}` : '来说点什么吧!',
          })
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
            if (this.showComposer) {
              this.closeComposer();
            } else {
              this.openComposer();
            }
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
          this.openComposer();
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
