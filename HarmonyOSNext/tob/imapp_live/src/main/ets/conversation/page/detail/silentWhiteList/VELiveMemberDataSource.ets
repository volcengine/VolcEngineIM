import { BasicDataSource, BIMUIUser } from "@imcloud/im_sdk_ui";
import BIMUILog from "@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog";
import { VELiveUserWrapper } from "../VELiveUserWrapper";

export class VELiveMemberDataSource extends BasicDataSource<VELiveUserWrapper> {
  private tag = "LiveMember"
  // public pushData(wrapper: VELiveUserWrapper) {
  //   this.data.push(wrapper)
  //   this.notifyDataAdd(this.data.length - 1);
  // }
  //
  // public selectData(): BIMUIUser[] {
  //   return this.data.filter((wrapper) => {
  //     return wrapper.isSelect
  //   }).map<BIMUIUser>((wrapper) => {
  //     return wrapper.user
  //   })
  // }


  public appendData(list: VELiveUserWrapper[]) {
    BIMUILog.debug(this.tag, `appendData index:${list.length}`)
    for (let w of list) {
      this.data.push(w)
      this.notifyDataAdd(this.data.length - 1)
    }
  }

  public reload(list: VELiveUserWrapper[]){
    BIMUILog.debug(this.tag, `refreshData index:${list.length}`)
    this.data = list
    this.notifyDataReload()
  }

  public selectData(): BIMUIUser[] {
    return this.data.filter((wrapper) => {
      return wrapper.isSelect
    }).map<BIMUIUser>((wrapper) => {
      return wrapper.user
    })
  }
}