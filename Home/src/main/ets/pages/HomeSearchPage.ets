import { router } from '@kit.ArkUI';
import { FeedPost, followPosts, recommendPosts } from '../model/HomeModel';
import { PostCard } from './PostCard';

/**
 * 首页搜索：本地过滤推荐/关注 mock 帖
 * 由 entry 壳 pages/Home/Search 挂载
 */
@Component
export struct HomeSearchPage {
  @State keyword: string = '';
  @State submitted: string = '';

  private matchPost(post: FeedPost, kw: string): boolean {
    if (kw.length === 0) {
      return false;
    }
    const hay =
      `${post.title} ${post.summary} ${post.authorName} ${post.tagText} ${post.gameTag}`.toLowerCase();
    return hay.indexOf(kw) >= 0;
  }

  private results(): FeedPost[] {
    const kw = this.submitted.trim().toLowerCase();
    if (kw.length === 0) {
      return [];
    }
    const out: FeedPost[] = [];
    const seen: string[] = [];
    for (let i = 0; i < recommendPosts.length; i++) {
      const p = recommendPosts[i];
      if (this.matchPost(p, kw) && seen.indexOf(p.id) < 0) {
        out.push(p);
        seen.push(p.id);
      }
    }
    for (let i = 0; i < followPosts.length; i++) {
      const p = followPosts[i];
      if (this.matchPost(p, kw) && seen.indexOf(p.id) < 0) {
        out.push(p);
        seen.push(p.id);
      }
    }
    return out;
  }

  private doSearch(): void {
    this.submitted = this.keyword.trim();
  }

  @Builder
  SearchBarBuilder() {
    Row() {
      Text('‹')
        .fontSize(26)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#1A1A1A')
        .width(36)
        .height(40)
        .textAlign(TextAlign.Center)
        .onClick(() => router.back())

      TextInput({ text: this.keyword, placeholder: '搜索帖子、作者、话题' })
        .layoutWeight(1)
        .height(36)
        .fontSize(14)
        .backgroundColor('#F3F4F6')
        .borderRadius(18)
        .padding({ left: 14, right: 14 })
        .onChange((value: string) => {
          this.keyword = value;
        })
        .onSubmit(() => this.doSearch())

      Text('搜索')
        .fontSize(14)
        .fontColor('#1A1A1A')
        .fontWeight(FontWeight.Medium)
        .padding({ left: 12, right: 4 })
        .onClick(() => this.doSearch())
    }
    .width('100%')
    .height(48)
    .padding({ left: 8, right: 12 })
  }

  build() {
    Column() {
      this.SearchBarBuilder()

      Divider().color('#F0F0F0').strokeWidth(0.5)

      if (this.submitted.length === 0) {
        Column() {
          Text('输入关键词搜索推荐与关注中的帖子')
            .fontSize(13)
            .fontColor('#B0B0B0')
            .margin({ top: 48 })
        }
        .width('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      } else if (this.results().length === 0) {
        Column() {
          Text(`未找到与「${this.submitted}」相关的帖子`)
            .fontSize(13)
            .fontColor('#B0B0B0')
            .margin({ top: 48 })
        }
        .width('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      } else {
        List() {
          ListItem() {
            Text(`${this.results().length} 条结果`)
              .fontSize(12)
              .fontColor('#B0B0B0')
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 4 })
          }

          ForEach(this.results(), (post: FeedPost) => {
            ListItem() {
              Column() {
                Divider().color('#F0F0F0').strokeWidth(0.5)
                PostCard({ post: post, variant: 'recommend' })
              }
            }
          }, (post: FeedPost) => `search|${this.submitted}|${post.id}`)
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
