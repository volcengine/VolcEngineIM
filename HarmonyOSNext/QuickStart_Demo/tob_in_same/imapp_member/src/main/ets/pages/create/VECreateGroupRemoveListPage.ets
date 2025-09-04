import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VEMemberActionBar } from '../../components/VEMemberActionBar'
import { VECreateGroupRemoveViewModel } from './VECreateGroupRemoveViewModel'
import { VEUserWrapper } from './VEUserWrapper'

@Component
export struct VECreateGroupRemoveListPage {
  uidList: string[] = []
  viewModel: VECreateGroupRemoveViewModel = new VECreateGroupRemoveViewModel()

  aboutToAppear(): void {
    this.uidList.forEach((uid) => {
      this.viewModel.pushData(uid)
    })
  }

  build() {
    NavDestination() {
      Column() {
        VEMemberActionBar({
          title: "移除群成员", rightTitle: "确定", rightClick: () => {
            IMRouter.pop(this.viewModel.onConfirmClick())
          }
        })
        List() {
          LazyForEach(this.viewModel.data, (item: VEUserWrapper, index: number) => {
            ListItem() {
              UserItemView({ wrapper: item, viewModel: this.viewModel })
            }
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .width('100%')
        .layoutWeight(1)
      }
    }.hideTitleBar(true)
  }
}

@Component
struct UserItemView {
  viewModel: VECreateGroupRemoveViewModel = new VECreateGroupRemoveViewModel()
  @ObjectLink wrapper: VEUserWrapper

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        Image(this.wrapper.user.portraitUrl)
          .objectFit(ImageFit.ScaleDown)
          .width(36)
          .height(36)
        Text(this.wrapper.user.nickName)
          .fontSize(25)
          .fontColor("#222222")
          .width('40%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
          .margin({ left: 8 })
      }

      Image(this.wrapper.isSelect ? $r('app.media.icon_im_radio_checked') : $r('app.media.icon_im_radio_unchecked'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    }.padding({
      left: 16, right: 16
    })
    .height(60).onClick(() => {
      this.wrapper.isSelect = !this.wrapper.isSelect
    })
  }
}


@Builder
function createGroupRemovePageBuilder(value: object) {
  VECreateGroupRemoveListPage({ uidList: value as string[] })
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_CREATE_GROUP_REMOVE, wrapBuilder(createGroupRemovePageBuilder))