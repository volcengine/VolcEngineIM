import { BIMUIUser, BIMUserProvider } from "@imcloud/im_sdk_ui";
import BIMUILog from "@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog";

export class LiveUserProvider implements BIMUserProvider {
  private tag = "LiveUserProvider"
  private cache: Map<string, BIMUIUser> = new Map<string, BIMUIUser>()

  addCache(uid: string, memberName: string, memberUrl: string): boolean {
    BIMUILog.debug(this.tag, `addCache uid: ${uid} memberName: ${memberName} memberUrl: ${memberUrl}`)
    let old = this.cache.get(uid)
    if (old){
      let nameSame = old.memberAlias == memberName
      let urlSame = false;
      if (typeof old.memberPortraitUrl === 'string') {
        urlSame = old.memberPortraitUrl == memberUrl
      } else {
        if (memberUrl == "") { //不更新
          urlSame = true
        }
      }
      if(nameSame && urlSame){
        return false
      }
    }

    let user = new BIMUIUser()
    user.uid = uid
    user.memberAlias = memberName
    if (memberUrl == "") {
      user.memberPortraitUrl = this.getFakeRes(uid)
    } else {
      user.memberPortraitUrl = memberUrl
    }
    this.cache.set(uid, user)
    return true
  }

  getUserInfo(uid: string): BIMUIUser {
    let cacheUser = this.cache.get(uid)
    if (cacheUser) {
      return cacheUser
    } else {
      return this.createUser(uid)
    }
  }

  async getUserInfoAsync(uid: string): Promise<BIMUIUser> {
    return this.createUser(uid)
  }

  private createUser(uid: string): BIMUIUser {
    const user = new BIMUIUser()
    user.portraitUrl = $r('app.media.icon_recommend_user_default')
    user.nickName = uid.toString()
    user.uid = uid
    return user
  }

  private getFakeRes(uid: string): Resource {
    let uidStr = uid.toString()
    let c = uidStr.charAt(uidStr.length - 1)
    let res = $r('app.media.fake_icon_user_10')
    switch (c) {
      case '0':
        res = $r('app.media.fake_icon_user_10');
        break
      case '1':
        res = $r('app.media.fake_icon_user_1');
        break;
      case '2':
        res = $r('app.media.fake_icon_user_2');
        break;
      case '3':
        res = $r('app.media.fake_icon_user_3');
        break;
      case '4':
        res = $r('app.media.fake_icon_user_4');
        break;
      case '5':
        res = $r('app.media.fake_icon_user_5');
        break;
      case '6':
        res = $r('app.media.fake_icon_user_6');
        break;
      case '7':
        res = $r('app.media.fake_icon_user_7');
        break;
      case '8':
        res = $r('app.media.fake_icon_user_8');
        break;
      case '9':
        res = $r('app.media.fake_icon_user_9');
        break;
    }
    return res
  }
}