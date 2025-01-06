import { VEBaseTool } from '../viewModel/VEToolsViewModel';
import { picker } from '@kit.CoreFileKit';
import { checkPermissionGrant, reqPermissionsFromUser } from '../../../utils/CheckPermissin';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import BIMUILog from '../../../../log/BIMUILog';

export class VideoToolBtn implements VEBaseTool {
  tag = "VideoToolBtn"
  resId: ResourceStr = $r('app.media.icon_im_input_optional_img');
  title: string = '视频';
  resultCallback: (isSuccess: boolean, uri: string[]) => void = () => {
  }

  constructor(resultCallback: (isSuccess: boolean, uri: string[]) => void) {
    this.resultCallback = resultCallback;
  }


  async onClick() {
    let permit = await this.checkAndReqPermission()
    if (permit) {
      let uriList = await this.PickPhoto()
      if (uriList && uriList.length > 0) {
        this.resultCallback(true, uriList)
      } else {
        this.resultCallback(false, [])
      }
    }
  }

  async PickPhoto(): Promise<string[]> {
    let photoSelectOptions = new picker.PhotoSelectOptions();
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.VIDEO_TYPE
    photoSelectOptions.maxSelectNumber = 9;
    let photoPicker = new picker.PhotoViewPicker()
    let result: picker.PhotoSelectResult = await photoPicker.select(photoSelectOptions)
    return result.photoUris
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