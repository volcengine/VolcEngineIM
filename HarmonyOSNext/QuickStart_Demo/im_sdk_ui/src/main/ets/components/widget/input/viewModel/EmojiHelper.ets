import { HashMap, util } from '@kit.ArkTS'
import MeasureText from '@ohos.measure';
import BIMUILog from '../../../../log/BIMUILog';

export class EmojiHelper {
  static instance = new EmojiHelper()
  readonly reg = new RegExp("\\[[a-zA-Z0-9\u4e00-\u9fa5]+\\]", "g");
  private readonly tag = "EmojiHelper"
  static getInstance(): EmojiHelper {
    return EmojiHelper.instance;
  }

  emojiTextMap = new HashMap<string, string>()
  textEmojiMap = new HashMap<string, string>()
  emojiInfoList: EmojiInfo[] = []

  public init(context: Context) {
    context.resourceManager.getRawFileContent("emoji/emoji.txt", (error, value) => {
      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      let rawFileString = textDecoder.decodeWithStream(value, { stream: false });
      this.emojiInfoList = JSON.parse(rawFileString)
      this.emojiInfoList.forEach((info, index) => {
        info.res = `resource:///imsdk_emoji_${info.code}.png`
        this.emojiTextMap.set(info.res, info.value)
        this.textEmojiMap.set(info.value, info.res)
      })
    })
  }

  public getEmojiText(res: string): string {
    return this.emojiTextMap.get(res)
  }

  public getEmojiRes(text: string): string {
    return this.textEmojiMap.get(text)
  }

  public getEmojiList(): EmojiInfo[] {
    return this.emojiInfoList
  }

  public measureTextWidth(text: string, textSize: number = 20): number {
    BIMUILog.debug(this.tag, `measureTextWidth text:${text}`)
    if (!text) {
      return textSize
    }
    let matches: IterableIterator<RegExpMatchArray> = text.matchAll(this.reg)
    let startIndex = 0
    let widthRich = 0
    for (let match of matches) {
      if (match.index != null || match.index != undefined) {
        if (match.index > startIndex) {
          let textSpan = text.substring(startIndex, match.index)
          widthRich += this.measureText(textSpan, textSize)
        }
        let res = this.getEmojiRes(match.toString())
        widthRich += textSize
        startIndex = match.index + match.toString().length
      }
    }
    if (startIndex < text.length) {
      let tail = text.substring(startIndex)

      widthRich += this.measureText(tail, textSize)
    }
    return widthRich
  }


  public setTextWithEmoji(controller: RichEditorController, text: string, tColor: string, textSize: number = 20): number {
    BIMUILog.debug(this.tag, `setTextWithEmoji text:${text}`)
    if (!text) {
      return textSize
    }
    let matches: IterableIterator<RegExpMatchArray> = text.matchAll(this.reg)
    let startIndex = 0
    let widthRich = 0
    for (let match of matches) {
      if (match.index != null || match.index != undefined) {
        if (match.index > startIndex) {
          let textSpan = text.substring(startIndex, match.index)
          controller.addTextSpan(textSpan, {
            style: {
              fontSize: textSize,
              fontColor: tColor
            }
          })
          widthRich += this.measureText(textSpan,textSize)
        }
        let res = this.getEmojiRes(match.toString())
        controller.addImageSpan(res, {
          imageStyle:
          {
            size: [textSize, textSize],
            objectFit: ImageFit.ScaleDown
          }
        })
        widthRich += textSize
        startIndex = match.index + match.toString().length
      }
    }
    if (startIndex < text.length) {
      let tail = text.substring(startIndex)
      controller.addTextSpan(tail, {
        style: {
          fontSize: textSize,
          fontColor: tColor
        }
      })
      widthRich += this.measureText(tail, textSize)
    }
    return widthRich
  }

  private measureText(text: string,textSize:number) {
    return px2vp(MeasureText.measureText({ textContent: text, fontSize: textSize }))
  }
}


export class EmojiInfo {
  value = ""
  code = 0
  res:ResourceStr = ""
}