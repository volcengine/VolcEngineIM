import { EmojiInfo } from '../../viewModel/EmojiHelper'

export class MsgEmojiWrap {
  static readonly TYPE_NORMAL = 0
  static readonly TYPE_MORE = 1
  info: EmojiInfo | undefined
  type: number

  constructor(info: EmojiInfo | undefined, type: number) {
    this.info = info
    this.type = type
  }
}