import { BIMMessage, BIMMessagePriority } from "@imcloud/imsdk";
import { OnRecorderListener } from "../../widget/input/recoder/RecorderViewModel";
import { EmojiInfo } from "../../widget/input/viewModel/EmojiHelper";
import { OnPriorityListener, OnSendTextListener } from "../../widget/input/viewModel/VEInputViewModel";
import { VEBaseTool } from "../../widget/input/viewModel/VEToolsViewModel";
import { BIMMsgListDataSource } from "./BIMMsgListDataSource";

export abstract class AbstractMsgListViewModel implements OnSendTextListener, OnRecorderListener,OnPriorityListener {
  cid: string = ""
  listScroller: Scroller = new Scroller();
  tools: VEBaseTool[] = []
  data: BIMMsgListDataSource = new BIMMsgListDataSource();

  constructor(cid: string) {
    this.cid = cid
    this.initToolBtn(this.tools)
  }

  onPriorityChanged(priority: BIMMessagePriority): void {
  }

  abstract isShowInputPriority():boolean
  abstract initToolBtn(tools:VEBaseTool[]):void

  abstract onSendText(text: string, bimMsg: BIMMessage | undefined, mentionIds: string[]): void

  abstract onSendEditText(text: string, oldMsg: BIMMessage, mentionIds: string[]): void

  abstract onRecordAudioComplete(path: string): void

  abstract onRecordAudioCancel(): void

  abstract addListener(): void

  abstract loadMore()

  abstract markConversationRead(): void

  abstract startReadRefresh(): void

  abstract stopReadRefresh(): void

  abstract removeListener(): void

  abstract onReSendMessage(msg: BIMMessage): void

  abstract onReadListClick(msg: BIMMessage): void

  abstract onLikeEmojiClick(msg: BIMMessage, emoji: EmojiInfo): void
}