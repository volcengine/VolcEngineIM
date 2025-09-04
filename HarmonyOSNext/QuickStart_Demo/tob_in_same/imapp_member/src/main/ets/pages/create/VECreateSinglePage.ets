import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { string2Long } from '@imcloud/imsdk'
import { VEMemberActionBar } from '../../components/VEMemberActionBar'
import { VECreateSingleViewModel } from './VECreateSingleViewModel'
import { promptAction } from '@kit.ArkUI'
import Long from 'long';

@Component
struct VECreateSinglePage {
  @State viewModel: VECreateSingleViewModel = new VECreateSingleViewModel()

  build() {
    NavDestination() {
      Column() {
        VEMemberActionBar({
          title: "发起单聊", rightTitle: "确定", rightClick: () => {
            let toUid:string = this.viewModel.onConfirm()
            if (!this.isUidValid(toUid)) {
              promptAction.showToast({ message: "请输入数字" })
              return
            }
            let map = new Map<string, string>()
            map.set("uid", toUid)
            IMRouter.pop(map)
          }
        })
        TextInput({ text: this.viewModel.uid, placeholder: "请输入用户ID" })
          .maxLines(1)
          .fontSize(19)
          .maxLength(20)
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
  private isUidValid(uid: string): boolean {
    try {
      let uidBig = BigInt(uid)
      if (uidBig > BigInt(Long.MAX_VALUE.toString()) || uidBig <= 0) {
        return false
      }
    } catch (e) {
      return false
    }
    return true
  }
}

@Builder
function createSinglePageBuilder() {
  VECreateSinglePage()
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_CREATE_SINGLE, wrapBuilder(createSinglePageBuilder))