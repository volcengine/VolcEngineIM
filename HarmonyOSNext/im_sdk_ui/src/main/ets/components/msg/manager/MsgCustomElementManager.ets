import { BIMCustomElement } from '@imcloud/imsdk'
import { BaseCustomElement } from '../custom/BaseCustomElement'
import { ShareElement } from '../custom/ShareElement'
import { GroupNotifyElement } from '../custom/GroupNotifyElement'
import BIMUILog from '../../../log/BIMUILog'

export class MsgCustomElementManager {
  private TAG = "MsgCustomElementManager"
  elementBuilderMap = new Map<string, elementBuilder>()

  constructor() {
    this.registerMessageElement("1", ShareElement.createElement)
    this.registerMessageElement("2", GroupNotifyElement.createElement)
  }

  public registerMessageElement(type: string, builder: elementBuilder) {
    this.elementBuilderMap.set(type, builder)
  }

  public getMessageElementBuilder(type: string): elementBuilder | undefined {
    return this.elementBuilderMap.get(type) ?? undefined
  }

  public getCustomElement(customElement: BIMCustomElement): BaseCustomElement {
    let json = customElement.data;
    let baseElement = new BaseCustomElement()
    try {
      baseElement = JSON.parse(json) as BaseCustomElement
    } catch (e) {
      BIMUILog.debug(this.TAG,`e:${e}`)
    }
    const typeStr:string = ""+baseElement.type
    let builder = this.getMessageElementBuilder(typeStr)
    if (builder) {
      let result = builder(json)
      result.type = typeStr
      return result
    } else {
      return new BaseCustomElement()
    }
  }
}

export type elementBuilder = (json: string) => BaseCustomElement

