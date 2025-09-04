import { BaseCustomElement } from './BaseCustomElement';

export class ShareElement extends BaseCustomElement {
  link: string;
  text: string;

  constructor(link: string, text: string) {
    super();
    this.link = link;
    this.text = text;
    this.type = "1"
  }

  static createElement(data: string): ShareElement {
    let r = new ShareElement("", "")
    try {
      r = JSON.parse(data) as ShareElement
    } catch (e) {
      console.error("ShareElement", `e:${JSON.stringify(e)}`)
    }
    return r
  }
}

