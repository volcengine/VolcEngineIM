import { BasicDataSource } from '../../../../source/BasicDataSource';
import { OptionInfo } from './model/OptionInfo';

export class MsgOptDataSource extends BasicDataSource<OptionInfo> {
  public setData(options: OptionInfo[]) {
    this.data = options
    this.notifyDataReload()
  }
}