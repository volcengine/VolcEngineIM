import { BIMLiveMemberOnlineInfo } from "@imcloud/imsdk/src/main/ets/live/api/model/BIMLiveMemberOnlineInfo";
import { BasicDataSource } from "@imcloud/im_sdk_ui";

export class VEOnlineResultDataSource extends BasicDataSource<BIMLiveMemberOnlineInfo> {
  public appendData(list: BIMLiveMemberOnlineInfo[]) {
    for (let w of list) {
      this.data.push(w)
      this.notifyDataAdd(this.data.length - 1)
    }
  }
}