import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMMessage, BIMTextElement } from '@imcloud/imsdk'
import { it } from '@ohos/hypium'
import { VEMemberActionBar } from '../../../components/VEMemberActionBar'
import { VEFTSItemView } from './VEFTSItemView'
import { VEFTSListPageViewModel } from './VEFTSListPageViewModel'
import { VESearchWrapper } from './VESearchWrapper'


@Component
export  struct VEFTSListPage {
  arg: Map<string, string> = new Map<string, string>()
  @State viewModel: VEFTSListPageViewModel = new VEFTSListPageViewModel(this.arg.get('cid'))
  @State content: string = ''

  aboutToAppear(): void {
    this.viewModel = new VEFTSListPageViewModel(this.arg.get('cid'))

  }

  build() {
    NavDestination() {
      Column() {
        VEMemberActionBar({
          title: '会话中搜索', rightTitle: ''
        })
        Column() {
          Search({placeholder: '搜索', value: $$this.content})
            .margin(10)
            .defaultFocus(true)
            .onChange((value: string) => {
              console.info(value);
              this.viewModel.searchText(value)
              let count = this.viewModel.data.totalCount()
              console.info('xxx' + count)
            })


          if (this.viewModel.dataCount) {
            Text('消息记录')
              .fontColor(Color.Gray)
              .padding(15)
              // .backgroundColor('#eeeeee')
              .width('100%')


            List() {
              LazyForEach(this.viewModel.data, (item: VESearchWrapper, index: number) => {
                ListItem() {
                  // Text((item.content as BIMTextElement).text)
                  VEFTSItemView({wrapper: item})
                }

              })
            }
            // .listDirection(Axis.Vertical)
            .width('100%')
            .layoutWeight(1)
          } else {
            Text('无结果')
              .fontColor(Color.Gray)
              .margin({top: 200})
              .visibility(this.content.length ? Visibility.Visible : Visibility.Hidden)
          }

        }
        .height('100%')
        .onClick(()=>{
          this.getUIContext().getFocusController().clearFocus()
        })
      }
    }
    .hideTitleBar(true)
  }
}

@Builder
function createFTSListPageBuilder(value: object) {
  VEFTSListPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_SEARCH_TEXT, wrapBuilder(createFTSListPageBuilder))