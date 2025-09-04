import { VEInputViewModel } from './VEInputViewModel';
import { inputMethod } from '@kit.IMEKit';

export enum InputClickMsg {
  MSG_VOICE_CLICK = 0,
  MSG_EMOJI_CLICK = 1,
  MSG_OPTION_CLICK = 2,
  MSG_KEY_BOARD_SHOW = 3,
  MSG_KEY_BOARD_HIDE = 4,
  MSG_KEY_BOARD_IS_SHOW = 5,
  MSG_EMPTY_CLICK = 6,
}

export class StateMachine {
  private _viewMode: VEInputViewModel
  statNormal: StateNormal
  stateVoice: StateVoice
  stateEmoji: StateEmoji
  stateOption: StateOptional
  _curState: State

  constructor(viewModel: VEInputViewModel) {
    this._viewMode = viewModel;
    this._curState = new StateNormal(this._viewMode, this)
    this.statNormal = new StateNormal(this._viewMode, this)
    this.stateVoice = new StateVoice(this._viewMode, this)
    this.stateEmoji = new StateEmoji(this._viewMode, this)
    this.stateOption = new StateOptional(this._viewMode, this)
  }

  sendMsg(msg: InputClickMsg) {
    this._curState.processMsg(msg)
    if (msg == InputClickMsg.MSG_KEY_BOARD_SHOW) {
      this._viewMode.isShowKeyBoard = true
    } else if (msg == InputClickMsg.MSG_KEY_BOARD_HIDE) {
      this._viewMode.isShowKeyBoard = false
    }
  }
}

abstract class State {
  protected viewModel: VEInputViewModel
  protected stateMachine: StateMachine

  constructor(ViewMode: VEInputViewModel, stateMachine: StateMachine) {
    this.viewModel = ViewMode
    this.stateMachine = stateMachine
  }

  abstract init(msg: InputClickMsg): void;

  abstract processMsg(msg: InputClickMsg): boolean;

  trans(msg: InputClickMsg) {
    this.init(msg)
    this.stateMachine._curState = this;
  }
}

export class StateNormal extends State {
  init(msg: InputClickMsg): void {
    this.viewModel.isShowEdit = Visibility.Visible
    this.viewModel.isShowAudio = Visibility.None
    this.viewModel.updateSendBtn()
    this.viewModel.isShowEmojiPanel = Visibility.None
    this.viewModel.isShowToolPanel = Visibility.None
    if (msg == InputClickMsg.MSG_KEY_BOARD_IS_SHOW) {
      this.viewModel.isShowPanel = Visibility.Visible
    } else {
      this.viewModel.isShowPanel = Visibility.None
    }
  }

  processMsg(msg: InputClickMsg): boolean {
    switch (msg) {
      case InputClickMsg.MSG_VOICE_CLICK:
        this.stateMachine.stateVoice.trans(msg)
        break;
      case InputClickMsg.MSG_EMOJI_CLICK:
        this.stateMachine.stateEmoji.trans(msg)
        break;
      case InputClickMsg.MSG_OPTION_CLICK:
        this.stateMachine.stateOption.trans(msg)
        break
      case InputClickMsg.MSG_KEY_BOARD_SHOW:
        this.viewModel.isShowPanel = Visibility.Visible
        break
      case InputClickMsg.MSG_KEY_BOARD_HIDE:
        this.viewModel.isShowPanel = Visibility.None
        break
      case InputClickMsg.MSG_EMPTY_CLICK:
        inputMethod.getController().stopInputSession();
        this.stateMachine.statNormal.trans(msg)
        break
    }
    return true;
  }
}

class StateVoice extends State {
  init(msg: InputClickMsg): void {
    this.viewModel.isShowEdit = Visibility.None
    this.viewModel.isShowAudio = Visibility.Visible
    this.viewModel.isShowEmojiPanel = Visibility.None
    this.viewModel.isShowToolPanel = Visibility.None
    this.viewModel.isShowPanel = Visibility.None
    inputMethod.getController().stopInputSession();

  }

  processMsg(msg: InputClickMsg): boolean {
    switch (msg) {
      case InputClickMsg.MSG_VOICE_CLICK:
        this.stateMachine.statNormal.trans(msg)
        break
      case InputClickMsg.MSG_EMOJI_CLICK:
        this.stateMachine.stateEmoji.trans(msg)
        break
      case InputClickMsg.MSG_OPTION_CLICK:
        this.stateMachine.stateOption.trans(msg)
        break
    }
    return true
  }
}

class StateEmoji extends State {
  init(msg: InputClickMsg): void {
    this.viewModel.isShowEdit = Visibility.Visible
    this.viewModel.isShowAudio = Visibility.None
    this.viewModel.isShowEmojiPanel = Visibility.Visible
    this.viewModel.isShowToolPanel = Visibility.None
    this.viewModel.isShowPanel = Visibility.Visible
    inputMethod.getController().stopInputSession();
  }

  processMsg(msg: InputClickMsg): boolean {
    switch (msg) {
      case InputClickMsg.MSG_VOICE_CLICK:
        this.stateMachine.stateVoice.trans(msg)
        break
      case InputClickMsg.MSG_EMOJI_CLICK:
        this.stateMachine.statNormal.trans(msg)
        inputMethod.getController().stopInputSession();
        break
      case InputClickMsg.MSG_OPTION_CLICK:
        this.stateMachine.stateOption.trans(msg)
        break
      case InputClickMsg.MSG_KEY_BOARD_SHOW:
        this.stateMachine.statNormal.trans(InputClickMsg.MSG_KEY_BOARD_IS_SHOW)
        break
      case InputClickMsg.MSG_EMPTY_CLICK:
        this.stateMachine.statNormal.trans(msg)
        break
    }
    return true
  }
}

class StateOptional extends State {
  init(msg: InputClickMsg): void {
    this.viewModel.isShowEdit = Visibility.Visible
    this.viewModel.isShowAudio = Visibility.None
    this.viewModel.isShowEmojiPanel = Visibility.None
    this.viewModel.isShowToolPanel = Visibility.Visible
    this.viewModel.isShowPanel = Visibility.Visible
    inputMethod.getController().stopInputSession();
  }

  processMsg(msg: InputClickMsg): boolean {
    switch (msg) {
      case InputClickMsg.MSG_VOICE_CLICK:
        this.stateMachine.stateVoice.trans(msg)
        break
      case InputClickMsg.MSG_EMOJI_CLICK:
        this.stateMachine.stateEmoji.trans(msg)
        break
      case InputClickMsg.MSG_OPTION_CLICK:
        this.stateMachine.statNormal.trans(msg)
        break
      case InputClickMsg.MSG_EMPTY_CLICK:
        this.stateMachine.statNormal.trans(msg)
        break
      case InputClickMsg.MSG_KEY_BOARD_SHOW:
        this.stateMachine.statNormal.trans(InputClickMsg.MSG_KEY_BOARD_IS_SHOW)
        break
    }
    return true
  }
}



