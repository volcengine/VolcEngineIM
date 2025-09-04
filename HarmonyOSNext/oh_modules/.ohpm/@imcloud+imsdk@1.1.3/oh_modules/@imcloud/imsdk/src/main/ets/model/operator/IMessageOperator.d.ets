import { IMResult } from '../../api/bean/IMHandlerResult';
import { Message } from '../../api/model/Message';
import { ModifyMsgPropertyMsg } from '../../api/model/MessageProperty';
import { BIMSendCallback } from '../../bim/api/interface/BIMSendCallback';
import { SendTrace } from '../../bim/report/BIMMessageReporter';
import { MsgUpdateParams } from '../../storage/datasource/IMMsgDataSource';
export interface IMessageOperator {
    /**
     * 发送消息
     * @param msg
     * @returns true/false 代表消息发送结果成功和失败；undefined代表参数不合法、实际请求未发出
     */
    sendMessage(msg: Message, sendCallback: BIMSendCallback, sendTrace?: SendTrace): Promise<boolean>;
    /**
     * 更新本地消息
     */
    updateLocalMessage(params: MsgUpdateParams): Promise<Nullable<boolean>>;
    /**
     * 撤回消息
     * @param msg 待撤回的消息
     * @returns 操作成功则返回对应的消息数据结构；否则返回undefined
     */
    recallMessage(msg: Message): Promise<IMResult<Message>>;
    /**
     * 修改消息属性
     * @param msgProperty  待修改的消息属性
     * @returns 操作成功则返回对应的消息数据结构；否则返回undefined
     */
    modifyMessageProperty(msgProperty: ModifyMsgPropertyMsg): Promise<IMResult<ModifyMsgPropertyMsg>>;
}
