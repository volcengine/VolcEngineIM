import { BIMUIClient, BIMUIUser, BIMUserProvider } from '@imcloud/im_sdk_ui'
import BuildProfile from '../../../../../BuildProfile'
import { BIMConnectStatus, BIMErrorCode } from '@imcloud/imsdk'
import VEIMAppLog from '../../log/VEIMAppLog'
import { VEIMAppSP } from '../../sp/VEIMAppSP'
import { VETokenInfo } from '../../sp/VETokenInfo'
import { promptAction } from '@kit.ArkUI'

export class VEMineViewModel {
  tag = "INMineViewModel"
  user: BIMUIUser = new BIMUIUser()
  appID: number = 0
  appVersion: string = ""
  versionCode: number = 0
  version: string = ""
  did: string = ""
  connectStatus: string = "已断开"
  env: number = -1
  cacheToken: VETokenInfo | undefined = undefined

  constructor() {
    let uid = BIMUIClient.getInstance().getCurrentUserID()
    this.user = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid)
    this.appID = BIMUIClient.getInstance().getAppID()
    this.appVersion = BuildProfile.HAR_VERSION
    this.versionCode = BIMUIClient.getInstance().getVersionCode()
    this.version = BIMUIClient.getInstance().getVersion()
    this.env = BIMUIClient.getInstance().getEnv()
    this.initDid()
    this.cacheToken = VEIMAppSP.getInstance().getToken();
  }

  private async initDid() {
    BIMUIClient.getInstance().getSDKDid((did) => {
      this.did = did
    })
  }

  onConnectStatusChange(status: BIMConnectStatus) {
    VEIMAppLog.info(this.tag, `onConnectStatusChanged ${status}`)
    if (status == BIMConnectStatus.BIM_CONNECT_STATUS_CONNECTED) {
      this.connectStatus = "已连接"
      promptAction.showToast({ message: "服务已连接" })
    } else if (status == BIMConnectStatus.BIM_CONNECT_STATUS_CONNECTING) {
      this.connectStatus = "连接中"
    } else {
      this.connectStatus = "已断开"
      promptAction.showToast({ message: "服务已断开" })
    }
  }

  logOut() {
    BIMUIClient.getInstance().logout()
  }
}