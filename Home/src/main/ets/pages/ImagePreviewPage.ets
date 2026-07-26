import { router } from '@kit.ArkUI';
import { PostImage, followPosts, getPostDetailById, recommendPosts } from '../model/HomeModel';

/**
 * 配图全屏预览：左右滑切换，点空白/关闭返回
 * params: { postId: string, index?: number }
 */
@Component
export struct ImagePreviewPage {
  @State mediaKeys: string[] = [];
  @State colors: string[] = [];
  @State currentIndex: number = 0;

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    const postId = params ? (params['postId'] as string) : '';
    const idxRaw = params ? params['index'] : 0;
    let idx = 0;
    if (typeof idxRaw === 'number') {
      idx = idxRaw as number;
    } else if (typeof idxRaw === 'string') {
      idx = parseInt(idxRaw as string, 10);
      if (isNaN(idx)) {
        idx = 0;
      }
    }
    const imgs = this.resolveImages(postId);
    const keys: string[] = [];
    const colors: string[] = [];
    for (let i = 0; i < imgs.length; i++) {
      keys.push(imgs[i].mediaKey);
      colors.push(imgs[i].placeholderColor);
    }
    // 详情仅有 hero 时兜底
    if (keys.length === 0 && postId.length > 0) {
      const d = getPostDetailById(postId);
      if (d && d.heroMediaKey.length > 0) {
        keys.push(d.heroMediaKey);
        colors.push(d.heroColor.length > 0 ? d.heroColor : '#222222');
      }
    }
    this.mediaKeys = keys;
    this.colors = colors;
    if (idx < 0) {
      idx = 0;
    }
    if (keys.length > 0 && idx >= keys.length) {
      idx = keys.length - 1;
    }
    this.currentIndex = idx;
  }

  private resolveImages(postId: string): PostImage[] {
    for (let i = 0; i < recommendPosts.length; i++) {
      if (recommendPosts[i].id === postId) {
        return recommendPosts[i].images;
      }
    }
    for (let i = 0; i < followPosts.length; i++) {
      if (followPosts[i].id === postId) {
        return followPosts[i].images;
      }
    }
    return [];
  }

  @Builder
  MediaByKey(key: string, color: string) {
    if (key === 'chain') {
      Image($r('app.media.chain')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'mita') {
      Image($r('app.media.mita')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'nba') {
      Image($r('app.media.nba')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'fighter') {
      Image($r('app.media.fighter')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'Palworld') {
      Image($r('app.media.Palworld')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'party') {
      Image($r('app.media.party')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'monster') {
      Image($r('app.media.monster')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'OverCooked') {
      Image($r('app.media.OverCooked')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_fields1') {
      Image($r('app.media.scrape_fields1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_fields2') {
      Image($r('app.media.scrape_fields2')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_honor1') {
      Image($r('app.media.scrape_honor1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_honor2') {
      Image($r('app.media.scrape_honor2')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_tom1') {
      Image($r('app.media.scrape_tom1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_gf1') {
      Image($r('app.media.scrape_gf1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_greenhell1') {
      Image($r('app.media.scrape_greenhell1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_jiahao1') {
      Image($r('app.media.scrape_jiahao1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_muse1') {
      Image($r('app.media.scrape_muse1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_doubao1') {
      Image($r('app.media.scrape_doubao1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_messi1') {
      Image($r('app.media.scrape_messi1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cxmt1') {
      Image($r('app.media.scrape_cxmt1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_wzry1') {
      Image($r('app.media.scrape_wzry1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf1') {
      Image($r('app.media.scrape_cf1')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf2') {
      Image($r('app.media.scrape_cf2')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf3') {
      Image($r('app.media.scrape_cf3')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else if (key === 'scrape_cf4') {
      Image($r('app.media.scrape_cf4')).width('100%').height('100%').objectFit(ImageFit.Contain)
    } else {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(color.length > 0 ? color : '#333333')
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')

      if (this.mediaKeys.length === 0) {
        Text('暂无图片')
          .fontSize(14)
          .fontColor('#AAAAAA')
      } else {
        Swiper() {
          ForEach(this.mediaKeys, (key: string, i: number) => {
            Stack() {
              this.MediaByKey(key, i < this.colors.length ? this.colors[i] : '#222222')
            }
            .width('100%')
            .height('100%')
          }, (key: string, i: number) => `pv|${i}|${key}`)
        }
        .index(this.currentIndex)
        .loop(false)
        .indicator(
          Indicator.dot()
            .color('#666666')
            .selectedColor('#FFFFFF')
        )
        .onChange((i: number) => {
          this.currentIndex = i;
        })
        .width('100%')
        .height('100%')
      }

      Row() {
        Text('关闭')
          .fontSize(14)
          .fontColor(Color.White)
          .padding({ left: 14, right: 14, top: 8, bottom: 8 })
          .backgroundColor('rgba(255,255,255,0.18)')
          .borderRadius(16)
          .onClick(() => router.back())
      }
      .width('100%')
      .padding({ top: 48, right: 16 })
      .justifyContent(FlexAlign.End)

      if (this.mediaKeys.length > 0) {
        Text(`${this.currentIndex + 1} / ${this.mediaKeys.length}`)
          .fontSize(13)
          .fontColor('#CCCCCC')
          .margin({ bottom: 36 })
      }
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
  }
}
