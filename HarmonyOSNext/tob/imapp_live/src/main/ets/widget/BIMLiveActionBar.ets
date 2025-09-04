import { IMRouter } from "@imcloud/imapp_router"
import { BIMUIClient } from "@imcloud/im_sdk_ui"

@Component
export struct BIMLiveActionBar {
  @Prop title: string = ""
  showConfirm: boolean = false
  confirmLister = () => {
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Image($r('app.media.icon_im_back_black_live'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({ right: 16 })
        .margin({ left: 16 })
        .onClick(() => {
          IMRouter.pop()
        })
      Text(this.title)
        .margin({
          left: 16
        }).fontSize(25)
        .fontColor('#222222')
      Text("确定")
        .margin({
          left: 16
        })
        .fontSize(25)
        .margin({ right: 16 })
        .fontColor('#ff33b5e5')
        .visibility(this.showConfirm ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          this.confirmLister()
        })
      // Image($r('app.media.icon_im_more'))
      //   .width(40)
      //   .height(40)
      //   .objectFit(ImageFit.Contain)
      //   .margin({ right: 10 })
      //   .padding(10)
      //   .visibility(!this.showConfirm ? Visibility.Visible : Visibility.Hidden)
      //   .onClick(() => {
      //   })

    }.height(48)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .width('100%')
  }
}