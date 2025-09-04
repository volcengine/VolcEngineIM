import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { VECreateRemoveDataSource } from './VECreateRemoveDataSource'
import { BIMUIUser } from '@imcloud/im_sdk_ui/src/main/ets/api/BIMUIUser'

export class VECreateGroupRemoveViewModel {
  data: VECreateRemoveDataSource = new VECreateRemoveDataSource()

  pushData(uid: string) {
    let user = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid)
    this.data.pushData(user)
  }

  getSelectedList(): BIMUIUser[] {
    return this.data.selectData()
  }

  onConfirmClick():string[] {
    let r = this.data.selectData();
    return r.map((user) => {
      return user.uid
    })
  }
}