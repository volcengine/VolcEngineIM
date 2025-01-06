import { BIMClient, BIMErrorCode, BIMMessage } from '@imcloud/imsdk'
import { BIMUIClient } from '@imcloud/im_sdk_ui'
import { VEFTSListPageDataSource } from './VEFTSListPageDataSource'
import { VESearchWrapper } from './VESearchWrapper'

export class  VEFTSListPageViewModel {
  cid: string | undefined
  data: VEFTSListPageDataSource = new VEFTSListPageDataSource()
  dataCount: number = 0
  private queryWord: string = ''
  constructor(cid: string | undefined) {
    this.cid = cid
  }


  public async searchText(text: string) {
    if (!this.cid) {
      return
    }

    if (this.queryWord == text) {
      return
    }

    this.queryWord = text
    this.data.clear()
    // if (text == '1') {
    //   this.data.setData([text+'1', '11', '111'])
    // } else if (text == '2') {
    //   this.data.setData([text+'2', '22', '222', '2222'])
    // } else {
    //   // this.data.setData([text+' a', 'b', 'c'])
    //   this.data.clear()
    // }


    let result = await BIMUIClient.getInstance().searchLocalMessage(this.cid, text)
    if (result.code != BIMErrorCode.BIM_OK) {
      return
    }
    let list: VESearchWrapper[] = []
    for (let msg of result.data) {
      let userInfo = BIMUIClient.getInstance().getUserProvider().getUserInfo(msg.getSendUid())
      let wrapper = new VESearchWrapper(userInfo, msg)
      list.push(wrapper)
    }
    this.data.setData(list)

    this.dataCount = this.data.totalCount()
  }

}