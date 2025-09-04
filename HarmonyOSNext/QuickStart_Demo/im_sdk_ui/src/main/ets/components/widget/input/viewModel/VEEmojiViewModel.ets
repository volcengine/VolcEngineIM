import { HashMap } from '@kit.ArkTS';
import { EmojiHelper, EmojiInfo } from './EmojiHelper';

export class VEEmojiViewModel {
  private tag = "VEEmojiViewModel"
  private PAGE_SIZE = 20
  pageMap: HashMap<number, EmojiWrapper[]> = new HashMap()

  loadEmoji(block: (pageList: number[]) => void) {
    let pageList: EmojiWrapper[] = []
    let pageIndexList: number[] = []
    let pageCount = 0
    EmojiHelper.getInstance().getEmojiList().forEach((info, index) => {
      if (index % this.PAGE_SIZE == 0 && index != 0) {
        pageIndexList.push(pageCount)
        pageList.push(new EmojiWrapper($r(`app.media.icon_msg_emoji_delete`), EmojiWrapper.TYPE_DELETE))
        this.pageMap.set(pageCount++, pageList)
        pageList = []
      }
      pageList.push(new EmojiWrapper($r(`app.media.imsdk_emoji_${info.code}`), EmojiWrapper.TYPE_NORMAL, info))
    })
    if (pageList.length != 0) {
      for (let i = pageList.length; i < this.PAGE_SIZE; i++) {
        pageList.push(new EmojiWrapper("", EmojiWrapper.TYPE_EMPTY))
      }
      pageList.push(new EmojiWrapper($r(`app.media.icon_msg_emoji_delete`), EmojiWrapper.TYPE_DELETE))
      this.pageMap.set(pageCount, pageList)
      pageIndexList.push(pageCount)
    }
    block(pageIndexList)
  }
}

export class EmojiWrapper {
  static TYPE_NORMAL = 0
  static TYPE_DELETE = 1
  static TYPE_EMPTY = 2
  emojiInfo: EmojiInfo | undefined = undefined
  resId: ResourceStr
  type: number = 0

  constructor(resId: ResourceStr, type: number, emojiInfo?: EmojiInfo | undefined,) {
    this.emojiInfo = emojiInfo
    this.resId = resId
    this.type = type
  }
}