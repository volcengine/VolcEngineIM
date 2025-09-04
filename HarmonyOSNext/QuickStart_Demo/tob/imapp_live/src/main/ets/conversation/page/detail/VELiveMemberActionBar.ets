import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { IMRouter } from '@imcloud/imapp_router'

@Component
export struct VELiveMemberActionBar {
  @Prop title: string = "title"
  @Prop rightTitle: string | undefined
  rightClick: () => void = () => {
  }

  build() {
    RelativeContainer() {
      Image($r('app.media.icon_im_back_black'))
        .width(40)
        .height(40)
        .padding(10)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          IMRouter.pop()
        })
        // .margin({ left: 16 })
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        })

      Text(this.title)
        .fontSize(20)
        .fontColor('#222222')
        .alignRules({
          middle: { anchor: "__container__", align: HorizontalAlign.Center },
          center: { anchor: "__container__", align: VerticalAlign.Center },
        })
      Text(this.rightTitle)
        .fontSize(18)
        .margin({ right: 16 })
        .fontColor('#ff33b5e5')
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .onClick(() => {
          this.rightClick()
        })
    }
    .height(48)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .width('100%')
  }
}