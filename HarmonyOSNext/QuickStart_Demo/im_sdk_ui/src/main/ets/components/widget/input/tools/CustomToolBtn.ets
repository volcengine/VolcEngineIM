import { VEBaseTool } from '../viewModel/VEToolsViewModel';

export class CustomToolBtn implements VEBaseTool {
  resId: ResourceStr = $r('app.media.icon_im_input_optional_img');
  title: string = '自定义';
  resultCallback: () => void = () => {
  }

  constructor(resultCallback: () => void) {
    this.resultCallback = resultCallback;
  }

  onClick(): void {
    this.resultCallback()
  }
}