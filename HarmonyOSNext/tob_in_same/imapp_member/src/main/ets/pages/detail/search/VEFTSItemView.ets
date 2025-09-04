import { BIMMessage, BIMTextElement } from "@imcloud/imsdk"
import { VESearchWrapper } from "./VESearchWrapper"

//item
@Component
export struct VEFTSItemView {
  wrapper: VESearchWrapper | undefined

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Stack() {
          Image(this.wrapper?.user.portraitUrl)
            .backgroundColor(Color.Gray)
            .width(44)
            .height(44)
            .objectFit(ImageFit.Contain)
            .alignRules({
              left: { anchor: "__container__", align: HorizontalAlign.Start },
              top: { anchor: "__container__", align: VerticalAlign.Top },
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            })
        }.height('100%')
        .margin({ left: 16 })

        Flex({ justifyContent: FlexAlign.Center, direction: FlexDirection.Column }) {
          Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text(this.wrapper?.user.nickName)
              .fontSize(18)
              .fontColor('#222222')
              .id("title")
              .width(150)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({bottom:5})
            Text(this.wrapper?.time)
              .fontColor('#4c222222')
              .fontSize(12)
              .margin({ right: 16 })
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          Text((this.wrapper?.message.getElement() as BIMTextElement).text)
            .fontSize(14)
            .fontColor('#999999')
            .id("last_msg")
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

        }
        .margin({ left: 16 })
        .width('100%')
        .clip(true)
      }
      .width('100%')
      .height('100%')

      Divider().width('100%')
    }.width('100%')
    .height(70)
  }
}