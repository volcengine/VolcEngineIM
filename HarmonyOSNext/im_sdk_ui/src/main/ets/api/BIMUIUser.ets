export class BIMUIUser {
  uid: string = ""
  portraitUrl: string | Resource = ""
  nickName: string = ""
  alias: string = ""
  memberAlias: string = ""
  memberPortraitUrl: string | Resource = ""
  isBlock: boolean = false
  isFriend: boolean = false

  getName(): string {
    if (this.memberAlias != "") {
      return this.memberAlias
    }
    if (this.nickName != "") {
      return this.nickName
    }
    return this.uid
  }

  getPortraitUrl(): string | Resource {
    if (this.memberPortraitUrl != "") {
      return this.memberPortraitUrl
    }
    return this.portraitUrl
  }
}