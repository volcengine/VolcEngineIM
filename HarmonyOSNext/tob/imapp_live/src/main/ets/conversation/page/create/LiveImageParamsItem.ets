@Component
export struct LiveImageParamsItem {
  title: string = ""
  @Link url: string

  build() {
    Column() {
      RelativeContainer() {
        Text(this.title).fontColor('#222222').fontSize(16)
          .alignRules({
            center: { 'anchor': '__container__', 'align': VerticalAlign.Center },
            left: { 'anchor': '__container__', 'align': HorizontalAlign.Start },
          })
        Image($r('app.media.icon_im_goto'))
          .width(16)
          .height(16)
          .objectFit(ImageFit.Contain)
          .id("arrow")
          .alignRules({
            center: { 'anchor': '__container__', 'align': VerticalAlign.Center },
            right: { 'anchor': '__container__', 'align': HorizontalAlign.End },
          })
        Image(this.url)
          .backgroundColor(Color.Gray)
          .width(16)
          .height(16)
          .alignRules({
            center: { 'anchor': '__container__', 'align': VerticalAlign.Center },
            right: { 'anchor': 'arrow', 'align': HorizontalAlign.Start },
          }).margin({right:4})
      }.margin({
        left: 16,
        right: 16
      }).height(60)

      Blank().backgroundColor('#f8f8f8').height(4).width('100%') //分割
    }
  }
}