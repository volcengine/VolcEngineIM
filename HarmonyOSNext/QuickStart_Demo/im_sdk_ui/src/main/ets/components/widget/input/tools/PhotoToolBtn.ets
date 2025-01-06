import { cameraPicker as picker } from '@kit.CameraKit';
import { camera } from '@kit.CameraKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import BIMUILog from '../../../../log/BIMUILog';
import { VEBaseTool } from '../viewModel/VEToolsViewModel';
import { checkPermissionGrant, reqPermissionsFromUser } from '../../../utils/CheckPermissin';


export class PhotoToolBtn implements VEBaseTool {
  private tag = "PhotoToolBtn"
  resId: ResourceStr = $r('app.media.icon_im_input_optional_photo');
  title: string = '拍照';
  resultCallback: (isSuccess: boolean, uri: string) => void = () => {
  }

  constructor(resultCallback: (isSuccess: boolean, uri: string) => void) {
    this.resultCallback = resultCallback;
  }

  async onClick() {
    let permit = await this.checkAndReqPermission()
    if (permit) {
      let uri = await this.tickPhoto()
      if (uri) {
        this.resultCallback(true, uri)
      } else {
        this.resultCallback(false, uri)
      }
    }
  }

  private async tickPhoto(): Promise<string> {
    try {
      let mContext = getContext(this) as common.Context;
      let pickerProfile: picker.PickerProfile = { cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK };
      let pickerResult: picker.PickerResult = await picker.pick(mContext, [picker.PickerMediaType.PHOTO], pickerProfile);
      BIMUILog.info(this.tag, "the pick pickerResult is:" + pickerResult.resultUri);
      return pickerResult.resultUri
    } catch (error) {
      let err = error as BusinessError;
      BIMUILog.info(this.tag, `the pick call failed. error code: ${err.code}`);
      return ""
    }
  }

  private async checkAndReqPermission(): Promise<boolean> {
    let grantStatus = await checkPermissionGrant('ohos.permission.READ_MEDIA')
    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      BIMUILog.debug(this.tag, `READ_MEDIA  有文件权限!`)
      return true
    } else {
      BIMUILog.debug(this.tag, `READ_MEDIA 无文件权限!`)
      let result = await reqPermissionsFromUser(['ohos.permission.READ_MEDIA'], getContext() as common.UIAbilityContext)
      if (result[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        BIMUILog.debug(this.tag, `用户授予文件权限!`)
        return true
      } else {
        BIMUILog.debug(this.tag, `用户拒绝文件权限!`)
        return false;
      }
    }
  }
}