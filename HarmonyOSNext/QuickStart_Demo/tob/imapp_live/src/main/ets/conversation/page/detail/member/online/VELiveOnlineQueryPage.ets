import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { BIMLiveActionBar } from '../../../../../widget/BIMLiveActionBar';
import { VELiveEditOnlineMemberDataSource } from './VELiveEditOnlineMemberDataSource';
import { promptAction } from '@kit.ArkUI';
import { OnlineQueryParams } from './VELiveOnlineQueryResultPage';

@Component
export struct VELiveOnlineQueryPage {
  @State inputUidStr: string = ""
  @State dataSource: VELiveEditOnlineMemberDataSource = new VELiveEditOnlineMemberDataSource();
  map: Map<string, string> = new Map()

  build() {
    NavDestination() {
      Column() {
        BIMLiveActionBar({
          title: "查询用户状态", showConfirm: true, confirmLister: () => {
            let list = this.dataSource.getAllDataList()
            if (list.length > 0) {
              let p = new OnlineQueryParams()
              p.cid = this.map["cid"]
              p.uidList = list
              IMRouter.push(IMPage.LIVE_MEMBER_ONLINE_QUERY_RESULT, p)
            } else {
              IMRouter.pop()
            }
          }
        })
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          TextInput({ text: $$this.inputUidStr, placeholder: "请输入用户ID[数字类型]" })
            .placeholderFont({
              size: 20
            })
            .fontSize(20)
            .maxLines(1)
            .backgroundColor(Color.Transparent)
            .width('80%')
            .type(InputType.Number)
          Text("添加")
            .fontSize(20)
            .maxLines(1)
            .fontColor(Color.Blue)
            .visibility(this.inputUidStr.length == 0 ? Visibility.Hidden : Visibility.Visible)
            .onClick(() => {
              if (this.dataSource.findIndex(this.inputUidStr) < 0) {
                this.dataSource.appendData(this.inputUidStr)
                this.inputUidStr = "";
              } else {
                promptAction.showToast({ message: "重复输入" })
              }

            })
        }.backgroundColor('#e8e8e8')
        .borderRadius(4)
        .margin({ left: 16, right: 16 })

        WaterFlow() {
          LazyForEach(
            this.dataSource,
            (item: string, index) => {
            FlowItem() {
              Column(){
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                  Text(item).fontSize(15)
                  Image($r('app.media.icon_im_close')).width(24).height(24).onClick(() => {
                    this.dataSource.deleteData(item);
                  })
                }.height(60).width('100%')
                Divider().color(Color.Gray)
              }
            }
          },
            (item: string) => item // 兼容鸿蒙5.0.0
          )
        }.margin({ left: 16, right: 16 })
      }
    }.hideTitleBar(true)
  }
}

@Builder
function veLiveOnlinePageBuilder(o: object) {
  VELiveOnlineQueryPage({ map: o as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.LIVE_MEMBER_ONLINE_QUERY, wrapBuilder(veLiveOnlinePageBuilder))