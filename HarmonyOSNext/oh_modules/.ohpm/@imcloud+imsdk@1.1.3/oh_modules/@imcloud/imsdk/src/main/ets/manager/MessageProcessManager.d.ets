import { ISaveMsgResult } from '../api/bean/message/SaveMsgResult';
import { Message } from '../api/model/Message';
import { LocalPropertyItem } from '../api/model/MessageProperty';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class MessageProcessManager extends IMSdkBaseObject {
    private tag;
    constructor(context: IMSdkContext);
    processSaveMessage(messageBody: im_proto.IMessageBody, ignoredUpdateMsg: boolean, msgSource: number, flagKV?: [string, string], saveIntoDB?: boolean): Promise<Nullable<ISaveMsgResult>>;
    /**
     * 对标：android getConvertUtils().convert(uuid, localMsg, body)
     * 根据服务端下发的数据和本地DB查询到的消息，构造或更新消息数据结构
     * @param body 服务端下发的消息Body
     * @param localMsg 本地DB查询到的消息数据
     * @param uuid
     * @returns
     */
    static convertFromMessageBody(context: IMSdkContext, body: im_proto.IMessageBody, localMsg: Nullable<Message>, isUpdate: boolean, cmdMsgType: im_proto.MessageType, uuid?: string, msgBodyExtMap?: Map<string, string>): Message;
    static convertFromServerProperty(msg: im_proto.IMessageBody, msgBodyExtMap?: Map<string, string>): Map<string, LocalPropertyItem[]>;
    /**
     * 添加一条消息到数据库，一般为提示消息
     * @param msg 待写入DB的消息
     */
    addMessage(msg: Message): Promise<boolean>;
    markConversationHasMore(convId: string, hasMore: boolean): Promise<void>;
}
