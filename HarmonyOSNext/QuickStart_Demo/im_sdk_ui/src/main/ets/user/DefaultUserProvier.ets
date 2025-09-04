import { BIMUserProvider } from "../../ets/api/BIMUserProvider";
import { BIMUIUser } from "../../ets/api/BIMUIUser";

export class DefaultUserProvider implements BIMUserProvider {
  getUserInfo(uid: string): BIMUIUser {

    return this.createUser(uid);
  }

  async getUserInfoAsync(uid: string): Promise<BIMUIUser> {
    return this.createUser(uid);

  }

  private createUser(uid: string): BIMUIUser {
    const user = new BIMUIUser()
    user.portraitUrl = $r('app.media.icon_recommend_user_default')
    user.nickName = uid.toString()
    user.uid = uid
    return user
  }
}