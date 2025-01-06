import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { VELoginViewModel } from './VELoginViewModel';
import { VEIMAppConst } from '../../const/VEIMAppConst';
import { VEIMAppSP } from '../../sp/VEIMAppSP';
import { promptAction } from '@kit.ArkUI';
import { BIMLoginListener } from '@imcloud/im_sdk_ui';


@Component
export struct VELoginPage {
  private tag: string = "VELoginPage";
  @State uid: string = "";
  private loginMode = new VELoginViewModel()
  private isAgree = false;
  private listener: BIMLoginListener = {
    onProtoAgree: (): void => {
      this.isAgree = true
    },
    doLogin: (uid: string, token: string): void => {
      if (this.isAgree) {
        this.realLogin(uid, token)
      } else {
        promptAction.showToast({ message: "请先同意协议" })
      }
    },
    onDebugClick: (): void => {
      IMRouter.push(IMPage.TOB_DEBUG)
    }
  }

  private async realLogin(uid: string, token: string) {
    console.debug(this.tag, `toLogin uid:${uid} token:${token}`)
    let isSuccess = await this.loginMode.loginIM(VEIMAppConst.APP_ID, uid, token)
    if (isSuccess) {
      promptAction.showToast({ message: `登录成功` })
      this.gotoMain()
    }
  }

  async aboutToAppear(): Promise<void> {
    VEIMAppSP.getInstance().init(getContext(), VEIMAppConst.APP_ID)
    let isSuccess = await this.loginMode.loginWithCache()
    if (isSuccess) {
      promptAction.showToast({ message: `登录成功` })
      this.gotoMain()
    }
    let envInfo = await VEIMAppSP.getInstance().getEnv()
    VEIMAppConst.provider.init(getContext(this), VEIMAppConst.APP_ID, envInfo?.env ?? 0)
  }

  build() {
    NavDestination() {
      Row() {
        VEIMAppConst.provider.createLoginFragment().builder(this.listener)
      }.width('100%')
    }.hideTitleBar(true)
  }

  private gotoMain() {
    IMRouter.push(IMPage.TOB_MAIN, undefined, (popInfo) => {
      let map = popInfo.result as Map<string, string>
      this.uid = ""
    })
  }
}


@Builder
function veLoginPageBuilder() {
  VELoginPage()
}

IMRouter.registerBuilder(IMPage.TOB_LOGIN, wrapBuilder(veLoginPageBuilder))


