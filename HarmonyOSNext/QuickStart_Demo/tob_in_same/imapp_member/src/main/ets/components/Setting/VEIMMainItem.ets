@Component
export struct MainItem {
  title: string = '';
  @Prop detail: string = '';
  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(17)
        Blank()
        Text(this.detail).fontSize(14)
          .fontColor(Color.Gray)
          .margin({right:10})
          .maxLines(1)
          .ellipsisMode(EllipsisMode.END)
        Image($r('app.media.icon_im_goto'))
          .width(12)
          .height(12)
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .padding(10)
    }
  }
}