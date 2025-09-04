import { KeyboardAvoidMode, promptAction, window } from '@kit.ArkUI'
import { VEEmojiPanel } from './VEEmojiPanel'
import { BIMUIUtils } from '../../../utils/BIMUIUtils'
import { VEToolsPanel } from './VEToolsPanel'
import { OnRecorderListener, RecorderViewModel } from './recoder/RecorderViewModel'
import { OnPriorityListener, OnSendTextListener, VEInputViewModel } from './viewModel/VEInputViewModel'
import { InputClickMsg, StateMachine } from './viewModel/StateMachine'
import BIMUILog from '../../../log/BIMUILog'
import { VEInputOutConfig } from './VEInputOutConfiger'
import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { BIMConversation, BIMMessage, BIMMessagePriority } from '@imcloud/imsdk'

@Component
export struct VEInPutView {
  private tag = "VEInPutView"
  inputOutConfig: VEInputOutConfig = new VEInputOutConfig()
  isShowPriority: boolean = false
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  @State viewModel: VEInputViewModel = new VEInputViewModel(this.controller)
  @State recorderViewModel: RecorderViewModel = new RecorderViewModel()
  stateMachine: StateMachine = new StateMachine(this.viewModel)
  scrollHeight: number = 0
  @State keyHeight: number = BIMUIUtils.KEYBOARD_HEIGHT
  @Consume sendTextListener: OnSendTextListener
  @Consume sendAudioListener: OnRecorderListener
  @Consume priorityListener: OnPriorityListener
  private inputTopBarHeight: number = 50
  private inputPaddingBottom: number = BIMUIUtils.NAVIGATION_HEIGHT
  conversationId: string = ""

  aboutToAppear(): void {
    this.listenKeyBoard()
    this.viewModel.conversationId = this.conversationId
    this.viewModel.onSendListener = this.sendTextListener
    this.viewModel.onPriorityListener = this.priorityListener
    this.viewModel.isShowPriority = this.isShowPriority
    this.recorderViewModel.recorderListener = this.sendAudioListener
    this.inputOutConfig.outListener = {
      onOutTouch: (event: TouchEvent): void => {
        if (event.type == TouchType.Down) { //out touch
          this.stateMachine.sendMsg(InputClickMsg.MSG_EMPTY_CLICK)
        }
      },
      onRefMsg: (msg: BIMMessage): void => {
        this.viewModel.topHint = this.viewModel.genRefHint(msg)
        this.viewModel.isShowTopHint = true
      },
      onEditMsg: (msg: BIMMessage): void => {
        this.viewModel.topHint = this.viewModel.genEditHint(msg)
        this.viewModel.isShowTopHint = true
      }
    }
    this.viewModel.initDraft()
  }

  aboutToDisappear(): void {
    this.viewModel.saveDraft()
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text(this.viewModel.topHint)
          .fontSize(12)
          .fontColor(Color.White)
          .width(BIMUIUtils.SCREEN_WIDTH - 24).margin({ left: 16 })
        Image($r('app.media.icon_im_close'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .margin({ right: 16 })
          .onClick(() => {
            this.viewModel.topHint = ""
            this.viewModel.isShowTopHint = false
            this.viewModel.clearTopHint()
          })
      }
      .backgroundColor('#FF55585A')
      .borderRadius(6)
      .padding(8)
      .margin({ top: 16, left: 8, right: 8 })
      .visibility(this.viewModel.isShowTopHint ? Visibility.Visible : Visibility.None)

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Image($r('app.media.icon_im_input_type_voice'))
          .objectFit(ImageFit.Contain)
          .width(24)
          .height(24)
          .onClick(() => {
            this.stateMachine.sendMsg(InputClickMsg.MSG_VOICE_CLICK)
          })

        RichEditor(this.options)
          .visibility(this.viewModel.isShowEdit)
          .focusable(true)
          .onDidChange((rangeBefore: TextRange, rangeAfter: TextRange)=>{
            this.viewModel.updateSendBtn()
          })
          .onIMEInputComplete((value: RichEditorTextSpanResult) => {
            console.debug("qinxue onIMEInputComplete")
            this.viewModel.updateSendBtn()
            if (this.viewModel.getText().endsWith('@')) {
              let arg = new Map<string, string>()
              arg.set('cid', this.conversationId)
              IMRouter.push(IMPage.IM_UI_AT_MEMBER, arg, (popInfo) => {
                let atUids = popInfo.result as string[]
                if (atUids && atUids.length > 0) {
                  if (atUids.length == 1 && atUids[0] == "all") {
                    this.viewModel.addMentionAll()
                  } else {
                    this.viewModel.addMentionId(atUids[0])
                  }
                }
              })
            }
          })
          .aboutToDelete((value: RichEditorDeleteValue) => {
            this.viewModel.updateSendBtn()
            return true
          })
          .onReady(() => {
            this.controller.setTypingStyle({
              fontColor: this.viewModel.inputTextColor,
              fontSize: this.viewModel.inputTextSize
            })
          })
          .backgroundColor('#e8e8e8')
          .borderRadius(4)
          .width(240)


        Text(this.recorderViewModel.recorderTip)
          .fontSize(20)
          .fontSize(15)
          .textAlign(TextAlign.Center)
          .height(40)
          .backgroundColor('#f8f8f8')
          .border({ radius: 3 })
          .visibility(this.viewModel.isShowAudio)
          .width(240)
          .onTouch((event: TouchEvent) => {
            this.recorderViewModel.onEvent(event)
          })
        Text(this.viewModel.priorityTitle)
          .fontColor(Color.White)
          .backgroundColor(Color.Blue)
          .maxLines(1)
          .width(48)
          .textAlign(TextAlign.Center)
          .visibility(this.viewModel.isShowPriority ? Visibility.Visible : Visibility.None)
          .margin({ left: 8, right: 8 })
          .onClick(() => {
              this.showPriorityDialog()
          })

        Image($r('app.media.icon_im_input_type_emoji'))
          .objectFit(ImageFit.Contain)
          .width(24)
          .height(24)
          .onClick(() => {
            this.stateMachine.sendMsg(InputClickMsg.MSG_EMOJI_CLICK)
          })

        Image($r('app.media.icon_im_input_type_more'))
          .objectFit(ImageFit.Contain)
          .visibility(this.viewModel.isShowMore)
          .onClick(() => {
            this.stateMachine.sendMsg(InputClickMsg.MSG_OPTION_CLICK)
          })
          .width(50)
          .height(24)
          .padding({ left: 13, right: 13 })

        Text("发送")
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#5692ff')
          .border({ radius: 6 })
          .visibility(this.viewModel.isShowSend)
          .height(30)
          .width(50)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.viewModel.onSendClick()
            this.viewModel.isShowTopHint = false
          })
      }.width('100%')
      .height(this.inputTopBarHeight)

      Column() {
        VEEmojiPanel({ emojiListener: this.viewModel })
          .visibility(this.viewModel.isShowEmojiPanel)
        VEToolsPanel()
          .visibility(this.viewModel.isShowToolPanel)
      }.width('100%')
      .height(this.keyHeight)
      .visibility(this.viewModel.isShowPanel)
    }
    .margin({ bottom: this.inputPaddingBottom })
    .expandSafeArea([SafeAreaType.KEYBOARD])
  }

  private listenKeyBoard() {
    window.getLastWindow(getContext(this)).then((currentWindow) => {
      currentWindow.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
      let property = currentWindow.getWindowProperties();
      let avoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD);
      this.scrollHeight = px2vp(property.windowRect.height - avoidArea.bottomRect.height);
      currentWindow.on('avoidAreaChange', data => {
        if (data.type == window.AvoidAreaType.TYPE_KEYBOARD) {
          let kh = px2vp(data.area.bottomRect.height);
          BIMUILog.debug(this.tag, `kh:${kh}`)
          if (kh > 0) {
            this.keyHeight = kh
            BIMUILog.debug(this.tag, `this.keyHeight:${this.keyHeight}`)
            BIMUIUtils.KEYBOARD_HEIGHT = this.keyHeight
            this.stateMachine.sendMsg(InputClickMsg.MSG_KEY_BOARD_SHOW)
          } else {
            this.stateMachine.sendMsg(InputClickMsg.MSG_KEY_BOARD_HIDE)
          }
          return;
        }
      })
    })
  }
  private showPriorityDialog(){
    promptAction.showActionMenu({
      title: '设置优先级',
      buttons: [
        {
          text: '高',
          color: '#000000'
        },
        {
          text: '普通',
          color: '#000000'
        },
        {
          text: '低',
          color: '#000000'
        },
      ]
    }).then(data => {
      let priority = BIMMessagePriority.NORMAL
      switch (data.index) {
        case 0:
          priority = BIMMessagePriority.HIGH
          break
        case 1:
          priority = BIMMessagePriority.NORMAL
          break
        case 2:
          priority = BIMMessagePriority.LOW
          break
      }
      this.viewModel.updatePriority(priority)
      })
  }
}