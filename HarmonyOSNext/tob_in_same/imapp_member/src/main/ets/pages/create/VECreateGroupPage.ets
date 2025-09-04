import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VECreateGroupViewModel } from './VECreateGroupViewModel'
import { VEMemberActionBar } from '../../components/VEMemberActionBar'
import { VEUserHorizonListView } from '../../components/hor/VEUserHorizonListView'

@Component
struct VECreateGroupPage {
  arg: Map<string, string | number> = new Map<string, string | number>()
  @State viewModel: VECreateGroupViewModel = new VECreateGroupViewModel()

  aboutToAppear(): void {
    this.viewModel = new VECreateGroupViewModel(this.arg.get('cid') as string, this.arg.get('userAddShowType') as number)
  }

  build() {
    NavDestination() {
      NavDestination() {
        Column() {
          VEMemberActionBar({
            title: this.arg.get('title') as string, rightTitle: "确定", rightClick: () => {
              let allIds = this.viewModel.onConfirm()
              IMRouter.pop(allIds)
            }
          })
          Stack() {
            TextInput({ text: this.viewModel.editUid, placeholder: "请输入用户ID添加群成员" })
              .maxLines(1)
              .fontSize(18)
              .maxLength(20)
              .placeholderFont()
              .backgroundColor("#e8e8e8")
              .borderRadius(6)
              .type(InputType.Number)
              .margin({ left: 16, right: 16 })
              .onChange((value) => {
                this.viewModel.editUid = value
              })
            Text("添加")
              .fontSize(18)
              .fontColor('#ff33b5e5')
              .margin({ right: 20 })
              .maxLines(1)
              .onClick(() => {
                this.viewModel.tryAddClick()
              })
          }.alignContent(Alignment.End)

          VEUserHorizonListView({
            data: this.viewModel.data, rightText: this.viewModel.allIdList.length + '人'
          })
            .onClick(() => {
              IMRouter.push(IMPage.IM_MEMBER_CREATE_GROUP_REMOVE, this.viewModel.allIdList, (popInfo) => {
                let removeUidList = popInfo.result as string[]
                this.viewModel.onRemove(removeUidList)
              })
            })
            .margin({ left: 16, right: 16, top: 16 })
            .visibility(this.viewModel.allIdList.length > 0 ? Visibility.Visible : Visibility.None)
        }
      }.hideTitleBar(true)
    }.hideTitleBar(true)
  }
}


@Builder
function veCreateGroupPageBuilder(value: object) {
  VECreateGroupPage({ arg: value as Map<string, string | number> })
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_CREATE_GROUP, wrapBuilder(veCreateGroupPageBuilder))