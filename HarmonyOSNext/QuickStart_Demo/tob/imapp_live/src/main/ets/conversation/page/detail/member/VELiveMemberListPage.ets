import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VELiveUserItemView } from '../components/VELiveUserItemView'
import { VELiveMemberActionBar } from '../VELiveMemberActionBar'
import { VELiveUserWrapper } from '../VELiveUserWrapper'
import { VELiveMemberListPageViewModel } from './VELiveMemberListPageViewModel'


@Component
export struct VELiveMemberListPage {
  arg: Map<string, string|boolean|object> = new Map<string, string|boolean|object>()
  title: string = ''
  isEdit: boolean = true
  userList: VELiveUserWrapper[] = []
  viewModel: VELiveMemberListPageViewModel = new VELiveMemberListPageViewModel()

  aboutToAppear(): void {
    this.title = this.arg.get('title') as string
    this.isEdit = this.arg.get('isEdit') as boolean
    this.userList = this.arg.get('userList') as VELiveUserWrapper[]

    this.userList.forEach((user) => {
      this.viewModel.pushData(user)
    })
  }

  build() {
    NavDestination() {
      Column() {
        VELiveMemberActionBar({
          title: this.title, rightTitle: this.isEdit ? "确定" : '', rightClick: () => {
            // let arg = new Map<string, object>()
            // arg.set("selectedList", this.viewModel.getSelectedList())
            IMRouter.pop( this.viewModel.onConfirmClick() ?? [])
          }
        })
        List() {
          LazyForEach(this.viewModel.data, (item: VELiveUserWrapper, index: number) => {
            ListItem() {
              VELiveUserItemView({wrapper: item})
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
  VELiveMemberListPage({ arg: value as Map<string, string|boolean|object> })
}

IMRouter.registerBuilder(IMPage.LIVE_MEMBER_LIST, wrapBuilder(createMemberListPageBuilder))
