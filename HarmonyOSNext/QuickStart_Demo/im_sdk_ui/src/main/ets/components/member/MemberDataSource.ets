import { BasicDataSource } from '../source/BasicDataSource';
import { MemberWrapper } from './MemberWrapper';

export class MemberDataSource extends BasicDataSource<MemberWrapper> {
  initData(data: MemberWrapper[]) {
    this.data = data
    this.notifyDataReload()
  }
}