import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMUIClient } from '../../api/BIMUIClient'
import { MemberWrapper } from './MemberWrapper'
import { AtMemberViewModel } from './AtMemberViewModel'

@Component
export struct AtMemberPage {
  arg: Map<string, string> = new Map()
  @State viewModel: AtMemberViewModel = new AtMemberViewModel()
  static readonly MEMBER_ALL = "all"
  aboutToAppear(){
    this.viewModel.init(this.arg.get("cid")??"")
  }
  build() {
    NavDestination() {
      Column() {
        ActionBar({
          title: "成员列表"
        })
        List() {
          ListItem() {
            MemberAllItemView().onClick(() => {
              IMRouter.pop([AtMemberPage.MEMBER_ALL])
            })
          }.visibility(this.viewModel?.isShowAtAll ? Visibility.Visible : Visibility.None)
          LazyForEach(this.viewModel?.data, (item: MemberWrapper, index: number) => {
            ListItem() {
              MemberItemView({ wrapper: item }).onClick(() => {
                IMRouter.pop([item.member.getUserID()])
              })
            }
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .width('100%')
      }
    }.hideTitleBar(true)
  }
}

@Component
struct MemberItemView {
  @ObjectLink wrapper: MemberWrapper

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        Image(this.wrapper.head)
          .objectFit(ImageFit.ScaleDown)
          .width(36)
          .height(36)
        Text(this.wrapper.name)
          .fontSize(25)
          .fontColor("#222222")
          .width('40%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
          .margin({ left: 8 })
      }
    }.padding({
      left: 16, right: 16
    })
    .height(60)
  }
}
@Component
struct MemberAllItemView{
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        Image($r('app.media.icon_recommend_user_default'))
          .objectFit(ImageFit.ScaleDown)
          .width(36)
          .height(36)
        Text("所有人")
          .fontSize(25)
          .fontColor("#222222")
          .width('40%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
          .margin({ left: 8 })
      }
    }.padding({
      left: 16, right: 16
    })
    .height(60)
  }
}


@Component
struct ActionBar {
  title: string = ""

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Image($r('app.media.icon_im_back_black'))
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
        .visibility(Visibility.Hidden)
    }.height(48)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .width('100%')
  }
}


@Builder
function veCreateGroupPageBuilder(arg: object) {
  AtMemberPage({ arg: arg as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_UI_AT_MEMBER, wrapBuilder(veCreateGroupPageBuilder))