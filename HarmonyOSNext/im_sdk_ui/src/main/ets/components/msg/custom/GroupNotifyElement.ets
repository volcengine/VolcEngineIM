import { BaseCustomElement } from './BaseCustomElement';

export class GroupNotifyElement extends BaseCustomElement {
  text: string;

  constructor(text: string) {
    super();
    this.text = text;
    this.type = "2"
  }

  static createElement(data: string): GroupNotifyElement {
    let r = new GroupNotifyElement("")
    try {
      r = JSON.parse(data) as GroupNotifyElement
    } catch (e) {
      console.error("GroupNotifyElement", `e:${JSON.stringify(e)}`)
    }
    return r
  }
}

