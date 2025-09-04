import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser'
import { VEUserHorizonSource } from './VEUserHorizonSource'
import { Core } from '@ohos/hypium'

@Component
export struct VEUserHorizonListView {
  @State data: VEUserHorizonSource = new VEUserHorizonSource()
  @Prop rightText: string = ''
  @Prop canAdd: boolean = false
  @Prop canRemove: boolean = false
  onGoListClick: () => void = () => {
  }
  onAddClick: () => void = () => {
  }
  onRemoveClick: () => void = () => {
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center, direction: FlexDirection.Row }) {
      Row() {
        List() {
          LazyForEach(this.data, (item: BIMUIUser, index: number) => {
            ListItem() {
              UserHorItemView({ info: item })
            }
          },(item:BIMUIUser)=>{return item.uid})

          ListItem() {
            Row({space: 8}) {
              if (this.canAdd) {
                Image($r('app.media.icon_im_add_user'))
                  .width(36)
                  .height(36)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.onAddClick()
                  })
              }

              if (this.canRemove) {
                Image($r('app.media.icon_im_delete_user'))
                  .width(36)
                  .height(36)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.onRemoveClick()
                  })
              }
            }
            .margin({left: 8})
          }
        }
        // .width('70%')
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)
        .height(60)

      }

      Row() {
        Text(this.rightText)
          .fontSize(16)
          .fontColor(Color.Gray)
        Image($r('app.media.icon_im_goto'))
          .width(14)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 8 })
      }.justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.onGoListClick()
      })
    }
  }
}


@Component
struct UserHorItemView {
  info: BIMUIUser = new BIMUIUser()

  build() {
    Column() {
      Image(this.info.portraitUrl)
        .width(36)
        .height(36)
        .objectFit(ImageFit.Contain)
      Text(this.info.nickName)
        .fontSize(8)
        .fontColor('#999999')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.END)
        .margin({ top: 8 })
        .width(30)
        .textAlign(TextAlign.Center)
    }.justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height(40)
    .width(40)
  }
}