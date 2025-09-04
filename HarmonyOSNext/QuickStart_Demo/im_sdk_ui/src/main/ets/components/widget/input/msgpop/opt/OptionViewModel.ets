import { BIMMessage } from '@imcloud/imsdk'
import { OptionInfo } from './model/OptionInfo'
import { MsgOptDataSource } from './MsgOptDataSource'
import { MsgOptEmojiDataSource } from '../emoji/MsgOptEmojiDataSource'
import { CopyOption } from './model/CopyOption'
import { DeleteOption } from './model/DeleteOption'
import { RefOption } from './model/RefOption'
import { PinOption } from './model/PInOption'
import { TopOption } from './model/TopOption'
import { EmojiHelper, EmojiInfo } from '../../viewModel/EmojiHelper'
import { MsgEmojiWrap } from '../emoji/MsgEmojiWrap'
import { BIMUIClient } from '../../../../../api/BIMUIClient'
import { OptionConfig } from './OptionConfig'
import { RecallOption } from './model/RecallOption'
import { EditOption } from './model/EditOption'
import { FavOption } from './model/FavOption'
import { PriorityOption } from './model/PriorityOption'

export class OptionViewModel {
  msg: BIMMessage | undefined
  options: OptionInfo[] = []
  optionDataSource: MsgOptDataSource = new MsgOptDataSource()
  emojiDataSource: MsgOptEmojiDataSource = new MsgOptEmojiDataSource()
  isExpandEmoji: boolean = false
  isEnableOption: boolean = true
  isEnableEmoji: boolean = true
  configByMsg: OptionConfig
  optionController: CustomDialogController|undefined

  constructor(uiContext: UIContext, refListener?: (msg: BIMMessage) => void, editListener?: (msg: BIMMessage) => void, msg?: BIMMessage) {
    this.msg = msg
    this.configByMsg = BIMUIClient.getInstance().msgOptManager.getOptionConfigByMsg(msg)
    this.initOption(uiContext, this.configByMsg, this.msg,refListener, editListener)
    this.initEmoji(this.configByMsg)
  }

  public isEnablePopWindow() {
    return  this.configByMsg.isEnablePoP && (this.isEnableOption || this.isEnableEmoji)
  }


  private initOption(uiContext: UIContext, optionConfig: OptionConfig, msg: BIMMessage | undefined, refListener?: (msg: BIMMessage) => void, editListener?: (msg: BIMMessage) => void) {
    this.isEnableOption = optionConfig.isEnableOption
    if (optionConfig.isEnableOption) {
      if (optionConfig.isEnableCopy) {
        this.options.push(new CopyOption(this.configByMsg,uiContext,msg))
      }
      if (optionConfig.isEnableDelete) {
        this.options.push(new DeleteOption(this.configByMsg,uiContext,msg))
      }
      if (optionConfig.isEnableRecall) {
        this.options.push(new RecallOption(this.configByMsg,uiContext,msg))
      }
      if (optionConfig.isEnableRef) {
        let refOption = new RefOption(this.configByMsg,uiContext, msg,refListener)
        this.options.push(refOption)
      }
      if (optionConfig.isEnableEdit) {
        let refOption = new EditOption(this.configByMsg, uiContext, msg, editListener)
        this.options.push(refOption)
      }
      if(optionConfig.isEnablePriority){
        this.options.push(new PriorityOption(this.configByMsg, uiContext,msg))
      }
      if (!BIMUIClient.isTob()) {
        if (optionConfig.isEnablePin) {
          this.options.push(new PinOption(this.configByMsg, uiContext,msg))
        }
        if (optionConfig.isEnableFav) {
          this.options.push(new FavOption(this.configByMsg, uiContext,msg))
        }
        if (optionConfig.isEnableTop) {
          this.options.push(new TopOption(this.configByMsg, uiContext,msg))
        }
      }
      this.optionDataSource.setData(this.options)
    }
  }

  private initEmoji(optionConfig: OptionConfig) {
    this.isEnableEmoji = optionConfig.isEnableLike
    if (this.isEnableEmoji) {
      let emojiList = EmojiHelper.getInstance().getEmojiList();
      let wrapList: MsgEmojiWrap[] = []
      for (let index = 0; index < 5; index++) {
        wrapList.push(new MsgEmojiWrap(emojiList[index], MsgEmojiWrap.TYPE_NORMAL));
      }
      let moreEmoji = new EmojiInfo()
      moreEmoji.res = $r('app.media.icon_msg_option_menu_open_emoji')
      wrapList.push(new MsgEmojiWrap(moreEmoji, MsgEmojiWrap.TYPE_MORE))
      this.emojiDataSource.setData(wrapList)
    }
  }
}