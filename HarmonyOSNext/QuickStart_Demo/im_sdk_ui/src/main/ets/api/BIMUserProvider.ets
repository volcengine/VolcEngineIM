import { BIMUIUser } from "./BIMUIUser"

export interface BIMUserProvider {
  getUserInfo(uid: string): BIMUIUser

  getUserInfoAsync(uid: string): Promise<BIMUIUser>
}