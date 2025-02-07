import { IMPage, IMRouter } from '@imcloud/imapp_router';
import { VELoginViewModel } from './VELoginViewModel';
import { VEIMAppConst } from '../../const/VEIMAppConst';
import { VEIMAppSP } from '../../sp/VEIMAppSP';
import { promptAction } from '@kit.ArkUI';
import { BIMLoginListener } from '@imcloud/im_sdk_ui';
import { BIMUIUtils } from '@imcloud/im_sdk_ui/src/main/ets/utils/BIMUIUtils';


@Component
export struct VELoginPage {
  private tag: string = "VELoginPage";
  @State uid: string = "";
  @State isShowLoginPage: boolean = false;
  private loginMode = new VELoginViewModel()
  private isAgree = false;
  private listener: BIMLoginListener = {
    onProtoAgree: (): void => {
      this.isAgree = true
    },
    doLogin: async (uid: string, token: string): Promise<boolean> => {
      if (this.isAgree) {
        return await this.realLogin(uid, token)
      } else {
        promptAction.showToast({ message: "请先同意协议" })
        return false
      }
    },
    onDebugClick: (): void => {
      IMRouter.push(IMPage.TOB_DEBUG)
    }
  }

  private async realLogin(uid: string, token: string): Promise<boolean> {
    console.debug(this.tag, `toLogin uid:${uid} token:${token}`)
    let isSuccess = await this.loginMode.loginIM(VEIMAppConst.APP_ID, uid, token)
    if (isSuccess) {
      promptAction.showToast({ message: `登录成功` })
      this.gotoMain()
      return true
    } else {
      promptAction.showToast({ message: `登录失败` })
    }
    return false
  }

  async aboutToAppear(): Promise<void> {
    BIMUIUtils.fullScreen(getContext())
    VEIMAppSP.getInstance().init(getContext(), VEIMAppConst.APP_ID)
    let isSuccess = await this.loginMode.loginWithCache()
    if (isSuccess) {
      promptAction.showToast({ message: `登录成功` })
      this.gotoMain()
    } else {
      this.isShowLoginPage = true
    }
    let envInfo = await VEIMAppSP.getInstance().getEnv()
    VEIMAppConst.provider.init(getContext(this), VEIMAppConst.APP_ID, envInfo?.env ?? 0)
  }

  build() {
    NavDestination() {
      Row() {
        Row() {
          VEIMAppConst.provider.createLoginFragment().builder(this.listener)
        }
        .visibility(this.isShowLoginPage ? Visibility.Visible : Visibility.Hidden)
      }.width('100%')
      .height('100%')
    }.hideTitleBar(true)
  }

  private gotoMain() {
    this.isShowLoginPage = false
    IMRouter.push(IMPage.TOB_MAIN, undefined, (popInfo) => {
      let map = popInfo.result as Map<string, string>
      this.isShowLoginPage = true
      this.uid = ""
    })
  }
}


@Builder
function veLoginPageBuilder() {
  VELoginPage()
}

IMRouter.registerBuilder(IMPage.TOB_LOGIN, wrapBuilder(veLoginPageBuilder))


