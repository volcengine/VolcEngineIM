import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMUIClient } from '@imcloud/im_sdk_ui'
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog'
import { VELiveCreateGroupPage } from './conversation/page/create/VELiveCreateGroupPage'
import { BIMLiveConversationListView } from './conversation/page/owner/BIMLiveConversationListView'
import { VELiveConvListViewModel } from './conversation/page/owner/viewmodel/VELiveConvListViewModel'


@Component
export struct VELiveGroupFragment {
  private _tag = "VELiveGroupFragment"
  conversationId: string = ""
  @State viewModel: VELiveConvListViewModel = new VELiveConvListViewModel(VELiveConvListViewModel.TYPE_OWNER)
  @Prop @Watch('onFragmentSelected') currentIndex: number = 0;
  @Prop @Watch('onPageShowCountChanged') onPageShowCount: number = 0;

  aboutToAppear(): void {
    console.log("VELiveGroupFragment aboutToAppear");
  }
  onFragmentSelected():void{
    BIMUILog.info(this._tag, `onFragmentSelected currentIndex: ${this.currentIndex}`)
    if(this.currentIndex == 1){
      this.viewModel.refresh()
    }
  }

  onPageShowCountChanged():void {
    if(this.currentIndex == 1){
      this.viewModel.refresh()
    }
  }

  createDialogController: CustomDialogController = new CustomDialogController({
    builder: CreateCreateDialog({
      onCreateListener: () => {
        this.viewModel.refresh()
      }
    }),
    alignment: DialogAlignment.TopEnd,
    offset: { dx: -16, dy: 24 },
    width: '40%',
    cornerRadius: 6
  })

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      this.buildActionBar()
      Divider().width('100%').height(2)
      BIMLiveConversationListView({
        viewModel: this.viewModel,
        itemClickListener: (conv) => {
          let arg = new Map<string, string>()
          arg.set("cid", conv.getConversationId())
          this.conversationId = conv.getConversationId()
          IMRouter.push(IMPage.LIVE_JOIN_CONV_INFO_PAGE, arg)
        }, itemLongClickListener: (conv) => {
          //没有长按
        }
      })
    }
  }

  @Builder
  buildActionBar() {
    RelativeContainer() {
      Text('直播群')
        .alignRules({
          top: { 'anchor': '__container__', 'align': VerticalAlign.Top },
          left: { 'anchor': '__container__', 'align': HorizontalAlign.Start },
          bottom: { 'anchor': '__container__', 'align': VerticalAlign.Bottom }
        })
        .margin({
          left: 16
        }).fontSize(25)


      Image($r('app.media.icon_im_add'))
        .width(24)
        .height(24)
        .margin({ right: 16 })
        .alignRules({
          top: { 'anchor': '__container__', 'align': VerticalAlign.Top },
          right: { 'anchor': '__container__', 'align': HorizontalAlign.End },
          bottom: { 'anchor': '__container__', 'align': VerticalAlign.Bottom }
        })
        .onClick(() => {
          this.createDialogController.open()
        })
        .id("create")
    }.height(48)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .width('100%')
  }
}

@CustomDialog
struct CreateCreateDialog {
  controller: CustomDialogController
  onCreateListener: () => void = () => {
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_im_create_conversation_group'))
          .objectFit(ImageFit.Contain)
          .width(20)
          .height(20)
        Text("查看全部")
          .fontSize(20)
          .fontColor('#222222')
          .margin({ left: 8 })
      }.alignItems(VerticalAlign.Center)
      .height(60)
      .onClick(() => {
        IMRouter.push(IMPage.LIVE_ALL_CONV_PAGE)
        this.controller.close()
      })

      Divider()
      Row() {
        Image($r('app.media.icon_im_add'))
          .objectFit(ImageFit.Contain)
          .width(20)
          .height(20)
        Text("创建直播群")
          .fontSize(20)
          .margin({ left: 8 })
          .fontColor('#222222')
      }.alignItems(VerticalAlign.Center)
      .height(60)
      .onClick(() => {
        let arg = new Map<string, string | number>()
        arg.set("title", '创建直播群')
        IMRouter.push(IMPage.LIVE_CREATE_CONV_PAGE, arg)
        this.controller.close()
      })
    }.backgroundColor(Color.White)
  }
}