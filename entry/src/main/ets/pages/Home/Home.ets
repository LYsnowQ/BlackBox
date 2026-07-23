@Component
export struct Home {
  build() {
    Column() {
      Text('首页')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
      
      // 这里可以添加首页内容
      Blank()
      Text('首页内容区域')
        .fontSize(16)
        .fontColor('#666666')
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }
}