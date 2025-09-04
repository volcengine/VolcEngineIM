import { picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { VEBaseTool } from '../viewModel/VEToolsViewModel';

export class FileToolBtn implements VEBaseTool {
  resId: ResourceStr = $r('app.media.icon_im_input_optional_file');
  title: string = '文件';
  resultCallback: (isSuccess: boolean, uri: string) => void = () => {
  }

  constructor(resultCallback: (isSuccess: boolean, uri: string) => void) {
    this.resultCallback = resultCallback;
  }

  async onClick() {
    let uriList = await this.pickDoc()
    if (uriList && uriList.length > 0) {
      this.resultCallback(true, uriList[0])
    } else {
      this.resultCallback(false, "")
    }
  }

  private async pickDoc(): Promise<Array<string>> {
    const documentSelectOptions = new picker.DocumentSelectOptions();
    documentSelectOptions.maxSelectNumber = 1;
    // documentSelectOptions.authMode = true;
    let context = getContext(this) as common.Context;
    // 创建文件选择器实例
    const documentViewPicker = new picker.DocumentViewPicker(context);
    let uriList = await documentViewPicker.select(documentSelectOptions)
    console.info('documentViewPicker.select to file succeed and uris are:' + uriList);
    return uriList
  }
}