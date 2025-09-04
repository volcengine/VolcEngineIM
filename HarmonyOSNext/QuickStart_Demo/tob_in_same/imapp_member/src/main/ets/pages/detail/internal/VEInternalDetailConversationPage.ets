import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VEIMDividerTmp } from '../../../components/Setting/VEIMDividerTmp'
import { MainItem } from '../../../components/Setting/VEIMMainItem'
import { VEMemberActionBar } from '../../../components/VEMemberActionBar'
import { BIMActionType, BIMConversation, BIMConversationType, BIMErrorCode, BIMMemberRole } from '@imcloud/imsdk'
import { ToggleItem } from '../../../components/Setting/VEIMToggleItem'
import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { promptAction } from '@kit.ArkUI'
import { VEInternalDetailConversationViewModel } from './VEInternalDetailConversationViewModel'


@Component
export struct VEInternalDetailConversationPage {
  arg: Map<string, string | number> = new Map<string, string | number>()
  @State cid: string = ''
  @State conversation: BIMConversation | undefined = undefined
  @State isSilent: boolean = false
  @State role: BIMMemberRole = BIMMemberRole.BIM_MEMBER_ROLE_UNKNOWN
  @State viewModel: VEInternalDetailConversationViewModel  = new VEInternalDetailConversationViewModel('')

  egDivider: VEIMDividerTmp = new VEIMDividerTmp(1, 10, 10, '#ffe9f0f0')


  async aboutToAppear(): Promise<void> {
    let cid = this.arg.get('cid') as  string
    if (cid) {
      let r = await BIMUIClient.getInstance().getConversation(cid)
      this.conversation = r.data
      this.isSilent = this.conversation?.isSilent() ?? false
      this.role = this.conversation?.getCurrentMember()?.getRole() ?? BIMMemberRole.BIM_MEMBER_ROLE_UNKNOWN
      this.cid = cid

      this.viewModel = new VEInternalDetailConversationViewModel(cid)
    }
  }

  build() {
    NavDestination() {
      Column({space: 20}) {
        VEMemberActionBar({
          title: '内部功能',
        })
        List({space:30}) {
          ListItem() {
            MainItem({title: 'Pin的消息', detail: ''})
              .onClick(()=> {
                this.arg.set('title', 'Pin的消息')
                this.arg.set('actionType', BIMActionType.BIM_ACTION_PIN)
                IMRouter.push(IMPage.IM_MEMBER_MARK_MESSAGE, this.arg)
              })
          }

          ListItem() {
            MainItem({title: '置顶的消息', detail: ''})
              .onClick(()=> {
                this.arg.set('title', '置顶的消息')
                this.arg.set('actionType', BIMActionType.BIM_ACTION_CONV_TOP_MSG)
                IMRouter.push(IMPage.IM_MEMBER_MARK_MESSAGE, this.arg)
              })
          }

          ListItem() {
            MainItem({title: '收藏的消息', detail: ''})
              .onClick(()=> {
                this.arg.set('title', '收藏的消息')
                this.arg.set('actionType', BIMActionType.BIM_ACTION_FAVORITE)
                IMRouter.push(IMPage.IM_MEMBER_MARK_MESSAGE, this.arg)
              })
          }

          if ((this.role == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || this.role == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) && this.conversation?.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
            ListItem() {
              ToggleItem({title: '设置会话禁言', isSwitchOn: this.isSilent, switchOnClick: async ()=>{
                this.isSilent = !this.isSilent
                let result = await BIMUIClient.getInstance().setConversationSilent(this.cid, this.isSilent, false)
                if (result.code != BIMErrorCode.BIM_OK) {
                  promptAction.showToast({message: '设置会话禁言失败:' + result.code })
                  this.isSilent = !this.isSilent
                }
              }})
            }

            ListItem() {
              MainItem({title: '设置成员禁言', detail: ''})
                .onClick(async ()=> {
                  this.viewModel.jumpToMemberSilentPage()
                })
            }
          }
        }
        .divider(this.egDivider)
      }
    }.hideTitleBar(true)
  }
}



@Builder
function internalDetailPageBuilder(value: object) {
  VEInternalDetailConversationPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_INTERNAL_DETAIL_CONVERSATION, wrapBuilder(internalDetailPageBuilder))

