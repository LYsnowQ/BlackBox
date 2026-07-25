import { GameItem } from '../model/GameLibrary/GameLibraryModel';

@Component
export struct GameCard {
  @Prop game: GameItem;
  onCardClick?: () => void;

  build() {
    Row() {
      // 封面缩略图
      Stack({ alignContent: Alignment.TopStart }) {
        if (this.game.coverImg) {
          Image(this.game.coverImg)
            .width(100)
            .height(60)
            .borderRadius(6)
            .objectFit(ImageFit.Cover)
        } else {
          Rect()
            .width(100)
            .height(60)
            .borderRadius(6)
            .fill(this.game.gradientColors[0] || '#E0E0E0')
        }

        if (this.game.discountPercent) {
          Text(`-${this.game.discountPercent}%`)
            .fontSize(10)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('#E53935')
            .padding({ left: 4, right: 4, top: 2, bottom: 2 })
            .borderRadius({ topLeft: 6, bottomRight: 6 })
        }
      }
      .width(100)
      .height(60)

      // 右侧信息
      Column() {
        Text(this.game.title)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 标签列表
        Row() {
          ForEach(this.game.tags.slice(0, 3), (tag: string) => {
            Text(tag)
              .fontSize(10)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(4)
              .margin({ right: 4 })
          })
        }
        .margin({ top: 4 })

        // 价格信息
        Row() {
          if (this.game.couponLabel) {
            Text(this.game.couponLabel)
              .fontSize(10)
              .fontColor('#FF6B00')
              .border({ width: 1, color: '#FF6B00' })
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 6 })
          }

          if (this.game.lowestLabel) {
            Text(this.game.lowestLabel)
              .fontSize(10)
              .fontColor('#E53935')
              .backgroundColor('#FFEBEE')
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .borderRadius(3)
              .margin({ right: 6 })
          }

          Blank()

          if (this.game.originalPrice && this.game.originalPrice > this.game.price) {
            Text(`¥${this.game.originalPrice}`)
              .fontSize(11)
              .fontColor('#B0B0B0')
              .decoration({ type: TextDecorationType.LineThrough })
              .margin({ right: 4 })
          }

          Text(`¥${this.game.price}`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
        }
        .width('100%')
        .margin({ top: 6 })
      }
      .layoutWeight(1)
      .margin({ left: 10 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .onClick(() => {
      if (this.onCardClick) {
        this.onCardClick();
      }
    })
  }
}
