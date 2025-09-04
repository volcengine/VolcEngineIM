import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VEMemberActionBar } from '../../../components/VEMemberActionBar'
import { VEUserWrapper } from '../../create/VEUserWrapper'
import { VEUserItemView } from '../../../components/Setting/VEUserItemView'
import { BIMMember } from '@imcloud/imsdk'
import { VEMemberListPageViewModel } from './VEMemberListPageViewModel'
import { BIMUIClient } from '@imcloud/im_sdk_ui'

@Component
export struct VEMemberListPage {
  arg: Map<string, string|boolean|object> = new Map<string, string|boolean|object>()
  title: string = ''
  isEdit: boolean = true
  userList: VEUserWrapper[] = []
  viewModel: VEMemberListPageViewModel = new VEMemberListPageViewModel()

  aboutToAppear(): void {
    this.title = this.arg.get('title') as string
    this.isEdit = this.arg.get('isEdit') as boolean
    this.userList = this.arg.get('userList') as VEUserWrapper[]

    this.userList.forEach((user) => {
      this.viewModel.pushData(user)
    })
  }

  build() {
    NavDestination() {
      Column() {
        VEMemberActionBar({
          title: this.title, rightTitle: this.isEdit ? "确定" : '', rightClick: () => {
            // let arg = new Map<string, object>()
            // arg.set("selectedList", this.viewModel.getSelectedList())
            IMRouter.pop( this.viewModel.onConfirmClick() ?? [])
          }
        })
        List() {
          LazyForEach(this.viewModel.data, (item: VEUserWrapper, index: number) => {
            ListItem() {
              VEUserItemView({wrapper: item})
            }
          })
        }
        .listDirection(Axis.Vertical)
        // .scrollBar(BarState.Off)
        .width('100%')
        .layoutWeight(1)


      }

    }.hideTitleBar(true)
  }
}

@Builder
function createMemberListPageBuilder(value: object) {
  VEMemberListPage({ arg: value as Map<string, string|boolean|object> })
}

IMRouter.registerBuilder(IMPage.IM_UI_MEMBER_LIST, wrapBuilder(createMemberListPageBuilder))
