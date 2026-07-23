@Component
export struct Hot {
  build() {
    Column() {
      Text('热点')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
      
      // 这里可以添加热点内容
      Blank()
      Text('热点内容区域')
        .fontSize(16)
        .fontColor('#666666')
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }
}