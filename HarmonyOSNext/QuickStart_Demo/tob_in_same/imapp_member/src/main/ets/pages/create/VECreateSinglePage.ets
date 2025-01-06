import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VEMemberActionBar } from '../../components/VEMemberActionBar'
import { VECreateSingleViewModel } from './VECreateSingleViewModel'

@Component
struct VECreateSinglePage {
  @State viewModel: VECreateSingleViewModel = new VECreateSingleViewModel()

  build() {
    NavDestination() {
      Column() {
        VEMemberActionBar({
          title: "发起单聊", rightTitle: "确定", rightClick: () => {
            let toUid = this.viewModel.onConfirm()
            let map = new Map<string, string>()
            map.set("uid", toUid)
            IMRouter.pop(map)
          }
        })
        TextInput({ text: this.viewModel.uid, placeholder: "请输入用户ID" })
          .maxLines(1)
          .fontSize(20)
          .placeholderFont()
          .backgroundColor("#e8e8e8")
          .borderRadius(6)
          .type(InputType.Number)
          .margin({ left: 16, right: 16 })
          .onChange((value) => {
            this.viewModel.uid = value
          })
      }
    }.hideTitleBar(true)
  }
}

@Builder
function createSinglePageBuilder() {
  VECreateSinglePage()
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_CREATE_SINGLE, wrapBuilder(createSinglePageBuilder))