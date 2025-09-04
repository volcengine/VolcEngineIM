import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { BIMLiveMemberOnlineInfo } from '@imcloud/imsdk/src/main/ets/live/api/model/BIMLiveMemberOnlineInfo';
import { BIMLiveActionBar } from '../../../../../widget/BIMLiveActionBar';
import { VEOnlineMemberViewModel } from './VEOnlineMemberViewModel';
import { intl } from '@kit.LocalizationKit';

@Component
export struct VELiveOnlineQueryResultPage {
  @State viewModel: VEOnlineMemberViewModel = new VEOnlineMemberViewModel();
  params: OnlineQueryParams = new OnlineQueryParams();
  private  dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat("zh-CN", { dateStyle: 'short', timeStyle: 'short', hourCycle: 'h24' });
  aboutToAppear(): void {
    this.viewModel.loadData(this.params.cid, this.params.uidList)
  }

  build() {
    NavDestination() {
      Column() {
        BIMLiveActionBar({
          title: "用户状态查询结果", showConfirm: false, confirmLister: () => {
            IMRouter.pop()
          }
        })

        WaterFlow() {
          LazyForEach(this.viewModel.data, (item: BIMLiveMemberOnlineInfo, index) => {
            FlowItem() {
              Column() {
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Text(item.getUserID()).fontSize(20)
                  Text(item.isInGroup() ? " 在群" : " 不在群").fontSize(20).fontColor(item.isInGroup() ? Color.Black : Color.Gray)
                }.height(40)

                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Text(this.dateFormat.format(new Date(item.getJoinTime())) + " 进群").fontSize(15).fontColor('#222222').visibility(item.isInGroup() ? Visibility.Visible : Visibility.Hidden)
                  Text(item.getLastPingTime() + " 退群").fontSize(15).fontColor('#222222').visibility(Visibility.Hidden)
                }.height(20)

                Divider().color(Color.Gray)
              }
            }
          })
        }.margin({ left: 16, right: 16 })
      }
    }.hideTitleBar(true)
  }
}


@Builder
function veLiveOnlineResultPageBuilder(o: object) {
  VELiveOnlineQueryResultPage({ params: o as OnlineQueryParams })
}

IMRouter.registerBuilder(IMPage.LIVE_MEMBER_ONLINE_QUERY_RESULT, wrapBuilder(veLiveOnlineResultPageBuilder))

export class OnlineQueryParams {
  cid: string = "";
  uidList: string[] = [];
}