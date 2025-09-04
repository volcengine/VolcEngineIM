import { BasicDataSource } from '../../../../source/BasicDataSource';
import { MsgEmojiWrap } from './MsgEmojiWrap';

export class MsgOptEmojiDataSource extends BasicDataSource<MsgEmojiWrap> {
  setData(emojiInfos: MsgEmojiWrap[]) {
    this.data = emojiInfos
    this.notifyDataReload()
  }
}