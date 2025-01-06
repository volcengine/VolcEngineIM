import { BIMConversationListView } from '@imcloud/im_sdk_ui/Index'
import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMUIClient } from '@imcloud/im_sdk_ui/Index';
import { BIMErrorCode } from '@imcloud/imsdk';
import { promptAction } from '@kit.ArkUI';

@Component
export struct VEConvListFragment {
  conversationId: string = ""
  createDialogController: CustomDialogController = new CustomDialogController({
    builder: CreateCreateDialog(),
    alignment: DialogAlignment.TopEnd,
    offset: { dx: -16, dy: 24 },
    width: '40%',
    cornerRadius: 6
  })
  operateConvController: CustomDialogController = new CustomDialogController({
    builder: CreateConvOperationDialog({ conversationId: this.conversationId }),
    alignment: DialogAlignment.Center,
    width: '80%',
    cornerRadius: 6
  })

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      this.buildActionBar()
      Divider().width('100%').height(2)
      BIMConversationListView({
        itemClickListener: (conv) => {
          let arg = new Map<string, string>()
          arg.set("cid", conv.getConversationId())
          this.conversationId = conv.getConversationId()
          IMRouter.push(IMPage.IM_UI_MESSAGE_LIST, arg)
        }, itemLongClickListener: (conv) => {
          this.conversationId = conv.getConversationId()
          this.operateConvController.open()
        }
      })
    }
  }

  @Builder
  buildActionBar() {
    RelativeContainer() {
      Text($r('app.string.ve_im_in_conv_title'))
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

      Image($r('app.media.unread_clear'))
        .width(24)
        .height(24)
        .margin({ right: 16 })
        .alignRules({
          top: { 'anchor': '__container__', 'align': VerticalAlign.Top },
          right: { 'anchor': 'create', 'align': HorizontalAlign.Start },
          bottom: { 'anchor': '__container__', 'align': VerticalAlign.Bottom }
        })
        .onClick(() => {
          this.markAllConv()
        })
        .id("clear")
    }.height(48)
    .margin({ top: BIMUIClient.getInstance().getStatusHeight() })
    .width('100%')
  }

  private async markAllConv() {
    let result = await BIMUIClient.getInstance().markAllConversationRead()
    if (result.code == BIMErrorCode.BIM_OK) {
      promptAction.showToast({ message: "清空未读成功" })
    } else {
      promptAction.showToast({ message: "清空未读失败" })
    }
  }
}

@CustomDialog
struct CreateCreateDialog {
  controller: CustomDialogController

  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_im_create_conversation_single'))
          .objectFit(ImageFit.Contain)
          .width(20)
          .height(20)
        Text("发起单聊")
          .fontSize(20)
          .fontColor('#222222')
          .margin({ left: 8 })
      }.alignItems(VerticalAlign.Center)
      .height(60)
      .onClick(() => {
        IMRouter.push(IMPage.IM_MEMBER_CREATE_SINGLE, undefined, (popInfo) => {
          let toUid = (popInfo.result as Map<string, string>).get('uid')
          this.createSingle(toUid)
        })
        this.controller.close()
      })

      Divider()
      Row() {
        Image($r('app.media.icon_im_create_conversation_group'))
          .objectFit(ImageFit.Contain)
          .width(20)
          .height(20)
        Text("发起群聊")
          .fontSize(20)
          .margin({ left: 8 })
          .fontColor('#222222')
      }.alignItems(VerticalAlign.Center)
      .height(60)
    }.backgroundColor(Color.White)
    .onClick(() => {
      let arg = new Map<string, string|number>()
      arg.set("title", '发起群聊')
      arg.set('userAddShowType', 0)
      IMRouter.push(IMPage.IM_MEMBER_CREATE_GROUP, arg, (popInfo) => {
        let idList = popInfo.result as string[]
        this.createGroup(idList)
      })
      this.controller.close()
    })
  }

  //创建单聊
  private async createSingle(uid?: string) {
    if (uid) {
      let r = await BIMUIClient.getInstance().createSingleConversation(uid)
      if (r.code == BIMErrorCode.BIM_OK) {
        promptAction.showToast({ message: `创建单聊成功:${r.data?.getConversationId()}` })
      } else {
        promptAction.showToast({ message: `创建单聊失败 code:${r.code}` })
      }
    } else {
      promptAction.showToast({ message: `创建单聊失败参数错误` })

    }
  }

  private async createGroup(uidList: string[]) {
    if (uidList && uidList.length > 0) {
      let r = await BIMUIClient.getInstance().createGroupConversation(uidList)
      if (r.code == BIMErrorCode.BIM_OK) {
        promptAction.showToast({ message: `创建群聊成功:${r.data?.getConversationId()}` })
      } else {
        promptAction.showToast({ message: `创建群聊失败 code:${r.code}` })
      }
    } else {
      promptAction.showToast({ message: `创建群聊失败参数错误` })
    }
  }
}


@CustomDialog
struct CreateConvOperationDialog {
  controller: CustomDialogController
  conversationId: string = ""

  build() {
    Column() {
      Row() {
        Text("删除")
          .fontSize(20)
          .fontColor('#222222')
          .margin({ left: 16 })
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height(60)
      .onClick(() => {
        this.deleteConversation()
        this.controller.close()
      })
    }.width('100%')
  }

  private async deleteConversation() {
    let result = await BIMUIClient.getInstance().deleteConversation(this.conversationId)
    if (result.code == BIMErrorCode.BIM_OK) {
      promptAction.showToast({ message: `删除成功 code:${result.code}` })
    } else {
      promptAction.showToast({ message: `删除失败 code:${result.code}` })
    }
  }
}