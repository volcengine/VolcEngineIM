@Component
export struct LiveTextParamsItem {
  title: string = ""
  @Link detail: string

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
        Text(this.detail).fontColor('#999999').fontSize(14)
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .width('30%')
          .textAlign(TextAlign.End)
          .alignRules({
            center: { 'anchor': '__container__', 'align': VerticalAlign.Center },
            right: { 'anchor': 'arrow', 'align': HorizontalAlign.Start },
          }).margin({right:4})
      }.height(60).margin({
        left: 16,
        right: 16
      })

      Blank().backgroundColor('#f8f8f8')
        .height(4)
        .width('100%') //分割
    }.width("100%")
    .height(64)

  }
}