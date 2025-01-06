import { BIMUserProvider } from '@imcloud/im_sdk_ui/Index';
import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser';

export class BIMUSerProvider implements BIMUserProvider {
  getUserInfo(uid: string): BIMUIUser {
    return this.createUser(uid)
  }

  async getUserInfoAsync(uid: string): Promise<BIMUIUser> {
    return this.createUser(uid)
  }

  private createUser(uid: string): BIMUIUser {
    const user = new BIMUIUser()
    user.uid = uid
    user.portraitUrl = this.getFakeRes(uid)
    user.nickName = uid.toString()
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