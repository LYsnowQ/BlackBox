@Component
export struct Me {
  build() {
    Column() {
      Text('我')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
      
      // 这里可以添加个人中心内容
      Blank()
      Text('个人中心内容区域')
        .fontSize(16)
        .fontColor('#666666')
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor('#FFFFFF')
  }
}