import { AudioRecorder } from './AudioRecoder'
import BIMUILog from '../../../../log/BIMUILog'
import { systemDateTime } from '@kit.BasicServicesKit'
import { fileIo } from '@kit.CoreFileKit'
import { checkPermissionGrant, reqPermissionsFromUser } from '../../../utils/CheckPermissin'
import { abilityAccessCtrl, common } from '@kit.AbilityKit'

export class RecorderViewModel {
  private _tag = "RecorderViewModel"
  recorderTip: string = "点击录音"
  private _recorder = new AudioRecorder()
  private _curPath: string = ""
  private _recorderListener: OnRecorderListener | undefined
  private _isCancel = false

  public set recorderListener(value: OnRecorderListener | undefined) {
    this._recorderListener = value
  }

  async onEvent(event: TouchEvent) {
    if (event.type == TouchType.Down) {
      BIMUILog.debug(this._tag, `down Y: ${event.touches[0].y} `)
      this._isCancel = false
      this.checkAndReqPermission().then((isGrant) => {
        if (isGrant) {
          this.recorderTip = "正在录音，手指上滑取消"
          let fileDir = getContext().tempDir
          this._curPath = fileDir + '/' + systemDateTime.getTime() + '.m4a'
          this._recorder.startRecordingProcess(this._curPath)
        }
      })
    } else if (event.type == TouchType.Up) {
      BIMUILog.debug(this._tag, `up Y: ${event.touches[0].y} `)
      await this._recorder.stopRecordingProcess()
      if(!this._isCancel){
        this._recorderListener?.onRecordAudioComplete(this._curPath)
      }
      this._curPath = ""
      this.recorderTip = "点击录音"
    } else if (event.type == TouchType.Move) {
      if (event.touches[0].y < 0 && !this._isCancel) {
        await this._recorder.stopRecordingProcess()
        this.recorderTip = "点击录音"
        this._curPath = ""
        this._recorderListener?.onRecordAudioCancel()
        this._isCancel = true
      }
    }
  }


  private async checkAndReqPermission(): Promise<boolean> {
    let grantStatus = await checkPermissionGrant('ohos.permission.MICROPHONE')
    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      BIMUILog.debug(this._tag, `MICROPHONE  有麦克风权限!`)
      return true
    } else {
      BIMUILog.debug(this._tag, `MICROPHONE 无麦克风权限!`)
      let result = await reqPermissionsFromUser(['ohos.permission.MICROPHONE'], getContext() as common.UIAbilityContext)
      if (result[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        BIMUILog.debug(this._tag, `用户授予麦克风权限!`)
        return true
      } else {
        BIMUILog.debug(this._tag, `用户拒绝麦克风权限!`)
        return false;
      }
    }
  }
}

export interface OnRecorderListener {
  onRecordAudioComplete(path: string): void

  onRecordAudioCancel(): void
}