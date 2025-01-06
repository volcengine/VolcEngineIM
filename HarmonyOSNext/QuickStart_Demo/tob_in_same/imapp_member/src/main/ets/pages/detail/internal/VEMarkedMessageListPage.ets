import { IMPage, IMRouter } from '@imcloud/imapp_router'

import { VEMemberActionBar } from '../../../components/VEMemberActionBar'
import { BIMActionType, BIMMessage, Message } from '@imcloud/imsdk'
import { VEMarkedMessageListPageViewModel } from './VEMarkedMessageListViewModel'
import { VEIMDividerTmp } from '../../../components/Setting/VEIMDividerTmp'
import { intl } from '@kit.LocalizationKit';
import { it } from '@ohos/hypium'

@Component
export struct VEMarkedMessageListPage {
  arg: Map<string, string|number> = new Map<string, string|number>()
  cid: string = ''
  actionType: BIMActionType = BIMActionType.BIM_ACTION_UNKNOWN
  egDivider: VEIMDividerTmp = new VEIMDividerTmp(1, 10, 10, '#ffe9f0f0')
  @State viewModel: VEMarkedMessageListPageViewModel = new VEMarkedMessageListPageViewModel(this.cid, this.actionType)
  dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat("zh-CN", { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h24' })

  aboutToAppear(): void {
    let cid = this.arg.get('cid') as string
    let actionType: BIMActionType = this.arg.get('actionType') as BIMActionType
    this.actionType = actionType
    if (!cid) {
      return
    }
    this.cid = cid
    this.viewModel = new VEMarkedMessageListPageViewModel(this.cid, actionType)
    this.viewModel.loadMore()
  }

  build() {
    NavDestination() {
      Column({space: 20}) {
        VEMemberActionBar({
          title: this.arg.get('title') as string,
        })

        if (this.actionType == BIMActionType.BIM_ACTION_PIN) {
          Flex({ direction: FlexDirection.Row }) {
            ForEach(this.viewModel.segmentList, (index: number) => {
              Text(index.toString()).width('33%').height(50)
                .backgroundColor(this.viewModel.selectedTag == index ? 0xF5DEB3: Color.White)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.viewModel.changeSeletedTag(index)
                })
            }, (item: string) => item)
          }
          .height(60)
        }

        List({space:30}) {
          LazyForEach(this.viewModel.data, (item: BIMMessage, index: number) => {
            ListItem() {
              Column() {
                Text(item.getSendUid().toString())
                Text(this.dateFormat.format(new Date(item.getCreatedTime())))
                Text(item.getContentData())
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
            }.bindMenu([
              {
                value: '取消标记',
                action: () => {
                  this.viewModel.cancleMark(item)
                }
              }
            ])
          })
        }
        .layoutWeight(1)
        .onScrollIndex((first: number, last: number) => {
          if (last == this.viewModel.data.totalCount() - 1) {
            this.viewModel.loadMore()
          }
        })
        .divider(this.egDivider)
      }
    }.hideTitleBar(true)
  }
}



@Builder
function markedPageBuilder(value: object) {
  VEMarkedMessageListPage({ arg: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_MEMBER_MARK_MESSAGE, wrapBuilder(markedPageBuilder))

