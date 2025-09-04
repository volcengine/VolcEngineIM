import { IMPage, IMRouter } from "@imcloud/imapp_router"
import { BIMLiveActionBar } from "../../../widget/BIMLiveActionBar"
import { BIMLiveConversationListView } from "../owner/BIMLiveConversationListView"
import { VELiveConvListViewModel } from "../owner/viewmodel/VELiveConvListViewModel"

@Component
export struct VEAllLiveGroupListPage {
  @State viewModel: VELiveConvListViewModel = new VELiveConvListViewModel(VELiveConvListViewModel.TYPE_ALL)

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
        BIMLiveActionBar({ title: "全部直播群" })
        Divider().width('100%').height(2)
        TextInput({ placeholder: "输入直播群 ID 或者群名" })
          .width('100%')
          .height(60)
          .onChange((value) => {
            this.viewModel.search(value)
          })
        Divider().width('100%').height(2)
        BIMLiveConversationListView({
          viewModel: this.viewModel,
          itemClickListener: (conv) => {
            let arg = new Map<string, string>()
            arg.set("cid", conv.getConversationId())
            IMRouter.push(IMPage.LIVE_JOIN_CONV_INFO_PAGE, arg)
          }, itemLongClickListener: (conv) => {
            //没有长按
          }
        })
      }
    }.hideTitleBar(true)
  }
}


@Builder
function veLiveAllPageBuilder() {
  VEAllLiveGroupListPage()
}

IMRouter.registerBuilder(IMPage.LIVE_ALL_CONV_PAGE, wrapBuilder(veLiveAllPageBuilder))