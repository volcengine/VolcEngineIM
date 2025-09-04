import { IMResult } from '../../api/bean/IMHandlerResult';
import { Message } from '../../api/model/Message';
import { ModifyMsgPropertyMsg } from '../../api/model/MessageProperty';
import { BIMSendCallback } from '../../bim/api/interface/BIMSendCallback';
import { SendTrace } from '../../bim/report/BIMMessageReporter';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { MsgUpdateParams } from '../../storage/datasource/IMMsgDataSource';
import { IMessageOperator } from './IMessageOperator';
/**
 * 1. 无需持有MessageModel、无上下文场景下即可对消息发起操作的地方，则作为MessageOperator的功能函数
 * 2. 在会话消息列表场景、需要被MessageModel持有，则作为MessageModel自身的功能函数
 */
export declare class MessageOperator extends IMSdkBaseObject implements IMessageOperator {
    constructor(context: IMSdkContext);
    /**
     * 发送消息
     * @param msg
     * @returns true 发送成功; false 代表失败
     */
    sendMessage(msg: Message, sendCallback: BIMSendCallback, sendTrace: SendTrace): Promise<boolean>;
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
    /**
     * 更新本地消息
     * @param params
     * @returns
     */
    updateLocalMessage(params: MsgUpdateParams): Promise<Nullable<boolean>>;
}
