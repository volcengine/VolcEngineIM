import { BIMMessageWrapper, HeadInfo, MsgCommonInfo } from './data/model/BIMMessageWrapper'
import { BIMMsgListViewModel } from './data/BIMMsgListViewModel'
import { BIMUIClient } from '../../api/BIMUIClient'
import { BIMUIUser } from '../../api/BIMUIUser'
import { VEInPutView } from '../widget/input/VEInPutView'
import { VEBaseTool } from '../widget/input/viewModel/VEToolsViewModel'
import { OnPriorityListener, OnSendTextListener } from '../widget/input/viewModel/VEInputViewModel'
import { OnRecorderListener } from '../widget/input/recoder/RecorderViewModel'
import { VEInputOutConfig } from '../widget/input/VEInputOutConfiger'
import BIMUILog from '../../log/BIMUILog'
import { BIMUIUtils } from '../../utils/BIMUIUtils'
import { BIMConversation, BIMConversationListListener, BIMMessage, BIMMessageStatus } from '@imcloud/imsdk'
import { BIMMessageOptionPopupWindow } from '../widget/input/msgpop/BIMMessageOptionPopupWindow'
import { OptionViewModel } from '../widget/input/msgpop/opt/OptionViewModel'
import { stringify } from 'json-bigint'
import { EmojiHelper, EmojiInfo } from '../widget/input/viewModel/EmojiHelper'
import { promptAction } from '@kit.ArkUI'
import { AbstractMsgListViewModel } from './data/AbstractMsgListViewModel'

@Component
export struct BIMMessageListView {
  private tag = "BIMMessageListView"
  cid: string = ""
  @State conv: BIMConversation | undefined = undefined
  @Link rootViewModel: AbstractMsgListViewModel
  private inputOutConfig: VEInputOutConfig = new VEInputOutConfig()
  @Provide tools: VEBaseTool[] = [] //工具栏按钮
  @Provide sendTextListener: OnSendTextListener | undefined = undefined //发消息回调
  @Provide sendAudioListener: OnRecorderListener | undefined = undefined
  @Provide priorityListener: OnPriorityListener | undefined = undefined
  @State isDissolve: boolean = false
  @State isMember: boolean = true
  autoFirstLoadDat:boolean = true
  onItemClickListener: (bimMsg: BIMMessage) => void = () => {
  }

  aboutToAppear(): void {
    BIMUILog.debug(this.tag,"aboutToDisappear msglistView")
    this.tools = this.rootViewModel.tools
    this.sendTextListener = this.rootViewModel as OnSendTextListener
    this.sendAudioListener = this.rootViewModel as OnRecorderListener
    this.priorityListener  = this.rootViewModel as OnPriorityListener
    this.rootViewModel.addListener()
    this.rootViewModel.markConversationRead()
    this.rootViewModel.startReadRefresh()
    this.setupConversation()
    if (this.autoFirstLoadDat) {
      this.rootViewModel.loadMore() //首次加载数据
    }
    // this.rootViewModel.addConvListener()
    this.addConversationListener()
  }

  aboutToDisappear(): void {
    this.rootViewModel.removeListener()
    this.rootViewModel.stopReadRefresh()
    // this.rootViewModel.removeConvListener()
    this.removeConversationListener()
  }

  private convListener: BIMConversationListListener = {
    onConversationChanged: (conversationList: BIMConversation[]): void => {
      for (let conv of conversationList) {
        if (conv.getConversationId() == this.cid) {
          this.conv = conv
          this.isDissolve = conv.isDissolved()
          this.isMember = conv.isMember()
          return
        }
      }
    },
    onNewConversation: (conversationList: BIMConversation[]): void => {

    },
    onConversationDelete: (conversationList: BIMConversation[]): void => {

    },
    onTotalUnreadMessageCountChanged: (unreadCount: number): void => {

    }
  }

  addConversationListener(): void {

    BIMUIClient.getInstance().addConversationListener(this.convListener)
  }

  removeConversationListener(): void {

    BIMUIClient.getInstance().removeConversationListener(this.convListener)
  }

  async setupConversation(): Promise<void> {
    let r = await BIMUIClient.getInstance().getConversation(this.cid)
    this.conv = r.data
    this.isDissolve = this.conv?.isDissolved() ?? false
    this.isMember = this.conv?.isMember() ?? true
  }

  build() {
    RelativeContainer() {
      Stack() {
        VEInPutView({ conversationId: this.cid, inputOutConfig: this.inputOutConfig, isShowPriority: this.rootViewModel.isShowInputPriority() })
          .visibility(!this.isDissolve && this.isMember ? Visibility.Visible : Visibility.None)
        Text(this.isDissolve ? '群聊已解散' : '已不在该群')
          .height(76)
          .backgroundColor('#F5F5F5')
          .fontColor("#A9A9A9")
          .fontSize(14)
          .textAlign(TextAlign.Center)
          .padding({ bottom: 10 })
          .visibility(this.isDissolve || !this.isMember ? Visibility.Visible : Visibility.None)
          .width('100%')
    }.alignRules({
      left: { anchor: "__container__", align: HorizontalAlign.Start },
      right: { anchor: "__container__", align: HorizontalAlign.End },
      bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
    }).width('100%')
    .id("inputView")

      WaterFlow({ scroller: this.rootViewModel.listScroller }) {
        LazyForEach(this.rootViewModel.data, (item: BIMMessageWrapper, index: number) => {
          FlowItem() {
            BIMMsgItemView({
              wrapper: item,
              common: item.commonInfo,
              onItemClickListener: this.onItemClickListener,
              veInputOutConfig: this.inputOutConfig,
              isDissolve: this.isDissolve,
              onSendFailed: (msg: BIMMessage) => {
                this.rootViewModel.onReSendMessage(msg)
              },
              readListClick: (msg:BIMMessage) => {
                this.rootViewModel.onReadListClick(msg)
              },
              likeClick:(msg: BIMMessage, emoji: EmojiInfo)=>{
                this.rootViewModel.onLikeEmojiClick(msg, emoji)
              }
            })
              .enabled(this.conv?.isMember())
          }
        }, (w: BIMMessageWrapper, i) => {
          return i + '__' + stringify(w)
        })
      }
      .layoutDirection(FlexDirection.ColumnReverse)
      .clip(true)
      .onScrollIndex((first: number, last: number) => {
        BIMUILog.debug(this.tag, `onScrollIndex start:${first} end:${last} end:${this.rootViewModel.listScroller.isAtEnd()} total-1:${this.rootViewModel.data.totalCount() - 1}`)
        if (last == this.rootViewModel.data.totalCount() - 1) {
          this.rootViewModel.loadMore()
        }
      })
      .scrollBar(BarState.Off)
      .width('100%')
      .onTouch((event) => {
        this.inputOutConfig.outListener?.onOutTouch(event)
      })
      .alignRules({
        left: { anchor: "__container__", align: HorizontalAlign.Start },
        right: { anchor: "__container__", align: HorizontalAlign.End },
        bottom: { anchor: "inputView", align: VerticalAlign.Top },
        top: { anchor: "__container__", align: VerticalAlign.Top },
        bias: { vertical: 0 }
      })
    }
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .clip(true)
  }
}

@Component
struct BIMMsgItemView {
  private sendStatusWidth = 40
  @Provide contentWidth: number = BIMUIUtils.SCREEN_WIDTH - 112
  @Provide itemMsgWidth: number = this.contentWidth - this.sendStatusWidth //减去两个头像 减去“已读”宽度
  onSendFailed: (bimMsg: BIMMessage) => void = (bimMsg: BIMMessage) => {
  }
  readListClick: (bimMsg: BIMMessage) => void = (bimMsg: BIMMessage) => {
  }
  likeClick:(msg: BIMMessage, emoji: EmojiInfo) => void = (bimMsg: BIMMessage) => {
  }
  @Link isDissolve: boolean //是否解散
  wrapper: BIMMessageWrapper = new BIMMessageWrapper()
  onItemClickListener: (bimMsg: BIMMessage) => void = () => {
  }
  @ObjectLink common: MsgCommonInfo
  msgItemPosition: Position = { x: 0, y: 0 }
  popOptHeight: number = 80
  veInputOutConfig: VEInputOutConfig | undefined

  build() {
    Column() {
      //顶部时间戳
      Text(this.wrapper.timeStr)
        .textAlign(TextAlign.Center)
        .fontSize(12)
        .fontColor('#4c222222')
        .padding(8)
        .maxLines(1)
        .visibility(this.wrapper.isShowTime ? Visibility.Visible : Visibility.Hidden)
      //中部消息内容
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        //左头像
        UserHeader({ headInfo:this.wrapper.headInfo }).visibility(!this.common.isRecall && !this.wrapper.forceHiddenHead && !this.wrapper.isSelf ? Visibility.Visible : Visibility.Hidden)
        //消息内容
        Column() {
          if (this.wrapper) {
            Column() {
              Column() {
                Text(`引用: ${this.common.refText}`)
                  .fontSize(12)
                  .fontColor(Color.White)
                  .padding(4)
                  .backgroundColor('#FF55585A')
                  .borderRadius(6)
                  .visibility(this.common.isShowRef ? Visibility.Visible : Visibility.None)
                  .margin({ bottom: 4 })
                  .alignSelf(this.wrapper.isSelf ? ItemAlign.End : ItemAlign.Start)
                Row() {
                  Image($r('app.media.icon_send_msg_failed'))//消息失败
                    .width(24)
                    .height(24)
                    .objectFit(ImageFit.Contain)
                    .visibility(this.common.sendStatus == BIMMessageStatus.BIM_MESSAGE_STATUS_FAILED ? Visibility.Visible : Visibility.None)
                    .alignSelf(ItemAlign.Center)
                    .onClick(() => {
                      let failedMsg = this.wrapper.msg
                      if (failedMsg) {
                        this.onSendFailed(failedMsg)
                      }
                    })
                    .margin({ right: 2 })
                  Text(this.common.isReadStr)//已读未读
                    .fontSize(12)
                    .fontColor('#4c222222')
                    .alignSelf(ItemAlign.End)
                    .margin({ right: 2 })
                    .onClick(() => {
                      if(this.wrapper.msg){
                        this.readListClick(this.wrapper.msg)
                      }
                    })
                    .textAlign(TextAlign.End)
                    .width(this.sendStatusWidth)
                    .visibility(this.common.isShowRead ? Visibility.Visible : Visibility.None)

                  BIMUIClient.getInstance().msgUIManager.getMsgUIBuilder(this.wrapper.elementType ?? "default_UI").builder(this.wrapper)
                }

                LikePanel({ msgWrapper: this.wrapper })//点赞
                  .margin({ top: 2 })
                  .visibility(this.wrapper.isShowLike ? Visibility.Visible : Visibility.None)
              }.visibility(this.common.isRecall ? Visibility.None : Visibility.Visible)
              .alignItems(this.wrapper.isSelf ? HorizontalAlign.End : HorizontalAlign.Start)

              Text(this.common.recallStr)
                .fontSize(12)
                .fontColor('#4c222222')
                .width('100%')
                .textAlign(TextAlign.Center)
                .visibility(this.common.isRecall ? Visibility.Visible : Visibility.None)
                .height(56) //和头像一样高
            }.onClick(() => {
              if (this.wrapper.msg) {
                this.onItemClickListener(this.wrapper.msg)
              }
            })
            .gesture(LongPressGesture()
              .onAction(() => {
                if (this.isDissolve) {
                  promptAction.showToast({ message: "群聊已解散" })
                  return
                }
                let showDx = (this.msgItemPosition.x ?? 0) as number
                let showDy = (this.msgItemPosition.y ?? 0) as number - BIMUIUtils.STATUS_HEIGHT - this.popOptHeight
                if (this.wrapper.msg) {
                  let optViewModel = new OptionViewModel(this.getUIContext(), (msg) => {
                    this.veInputOutConfig?.outListener?.onRefMsg(msg)
                  }, (msg) => {
                    this.veInputOutConfig?.outListener?.onEditMsg(msg)
                  }, this.wrapper.msg)
                  if (!optViewModel.isEnablePopWindow()) {
                    return
                  }
                  let optionController: CustomDialogController = new CustomDialogController({
                    builder: BIMMessageOptionPopupWindow({
                      viewModel: optViewModel, likeClickListener: (msg, emoji) => {
                        BIMUILog.debug("MsgOption", `like: ${msg.getUuid()} value: ${emoji.value}`)
                        this.likeClick(msg, emoji)
                      }
                    }),
                    cornerRadius: 0,
                    autoCancel: true,
                    alignment: DialogAlignment.Top,
                    offset: {
                      dx: 0, //居中就可以
                      dy: showDy
                    },
                  })
                  optViewModel.optionController = optionController
                  optionController.open()
                }
              }))
            .onAreaChange((o, n) => {
              this.msgItemPosition = n.globalPosition
            })
          }
        }.alignItems(this.wrapper.isSelf ? HorizontalAlign.End : HorizontalAlign.Start)
        .width(this.contentWidth)

        //右头像
        UserHeader({ headInfo:this.wrapper.headInfo })
          .visibility(!this.common.isRecall && !this.wrapper.forceHiddenHead && this.wrapper.isSelf ? Visibility.Visible : Visibility.Hidden)
      }
    }
  }
}

@Component
struct UserHeader {
  @ObjectLink headInfo:HeadInfo

  build() {
    Column() {
      Image(this.headInfo.headPortraitUrl)
        .objectFit(ImageFit.ScaleDown)
        .width(36)
        .height(36)
      Text(this.headInfo.headName)
        .fontSize(8)
        .fontColor('#999999')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.CENTER)
        .width(25)
        .margin({ top: 4 })
        .textAlign(TextAlign.Center)
    }
    .alignItems(HorizontalAlign.Center)
    .width(56)
    .height(56)
  }
}

@Component
struct LikePanel {
  @Consume itemMsgWidth: number
  msgWrapper: BIMMessageWrapper = new BIMMessageWrapper()
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  widthRich: number = 20

  aboutToAppear(): void {
    let measuredWidth = EmojiHelper.instance.measureTextWidth(this.msgWrapper.likeText, 15) + 32
    if (measuredWidth >= this.itemMsgWidth) {
      this.widthRich = this.itemMsgWidth
    } else {
      this.widthRich = measuredWidth
    }
  }

  build() {
    RichEditor(this.options)
      .borderRadius(4)
      .padding(4)
      .width(this.widthRich)
      .onTouchIntercept(() => {
        return HitTestMode.None //不相应触
      })
      .backgroundColor('#f1f1f1')
      .onReady(() => {
        EmojiHelper.instance.setTextWithEmoji(this.controller, this.msgWrapper.likeText, '#999999', 15)
      })
  }
}


