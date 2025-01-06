import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { JSON } from '@kit.ArkTS';
import { BIMCustomElement, BIMMessage, BIMMessageType, BIMTextElement } from '@imcloud/imsdk';

export class BIMUIUtils {
  static NAVIGATION_HEIGHT = 0
  static STATUS_HEIGHT = 0
  static KEYBOARD_HEIGHT = 314
  static SCREEN_WIDTH = 0

  static fullScreen(context: Context) {
    let windowClass: window.Window = (context as common.UIAbilityContext).windowStage.getMainWindowSync(); // 获取应用主窗口
    // 1. 设置窗口全屏
    let isLayoutFullScreen = true;
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
      .then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      })
      .catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });
    let navHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height // 获取到导航条区域的高度
    let statusRect = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect
    BIMUIUtils.NAVIGATION_HEIGHT = px2vp(navHeight)
    BIMUIUtils.STATUS_HEIGHT = px2vp(statusRect.height)
    BIMUIUtils.SCREEN_WIDTH = px2vp(statusRect.width)
  }

  static generateRefHint(hint: string, refMsg?: BIMMessage): string {
    return BIMUIUtils.generateHint(refMsg, hint)

  }

  static generateHint(bimMessage?: BIMMessage,defaultHint?:string): string {
    let hint: string = "[未知消息]";
    if (bimMessage) {
      let element = bimMessage.content
      const msgType = bimMessage.getMsgType()
      if (msgType === BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
        let textElement: BIMTextElement = element as BIMTextElement
        let text = textElement.text
        if (text) {
          hint = text;
        }
        let editInfo = bimMessage.getEditInfo();
        if (editInfo && editInfo.content_is_edited) {
          hint = hint + "(已编辑)"
        }
      } else if (msgType === BIMMessageType.BIM_MESSAGE_TYPE_IMAGE) {
        hint = "[图片]"
      } else if (msgType === BIMMessageType.BIM_MESSAGE_TYPE_VIDEO) {
        hint = "[视频]"
      } else if (msgType === BIMMessageType.BIM_MESSAGE_TYPE_FILE) {
        hint = "[文件]"
      } else if (msgType === BIMMessageType.BIM_MESSAGE_TYPE_AUDIO) {
        hint = "[语音]"
      } else if (msgType === BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
        let customElement: BIMCustomElement = element as BIMCustomElement
        try {
          let json: Record<string, string> = JSON.parse(customElement.data) as Record<string, string>
          let type = json['type']
          if (type == '2') {
            hint = "[系统]"
          } else {
            hint = "[自定义]"
          }
        } catch (e) {
          hint = defaultHint ?? "default_hint"
        }
      } else if (msgType.valueOf() === 10008) {
        hint = "[系统消息]"
      } else {
        hint = "[未知消息]"
      }
    }
    return hint
  }
}