import { Message } from '../api/model/Message';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { SenderInfo } from '../api/model/SenderInfo';
export declare class MessageUtil extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    static getConversationUpdateTimeFromMsg(lastMsg?: Message): number;
    static getMsgIndex(msg?: Nullable<Message>): bigint;
    static isShareMerge(msg: Message): boolean;
    static isSelf(userId: bigint, msg: Message): boolean;
    static msgNotFloat(currUid: bigint, msg: Message): boolean;
    static setShareMerge(msg: Message): void;
    static getMergeShareCardConId(msg: Message): string | undefined;
    static setMergeShareCardConId(msg: Message, originId: string): void;
    static getMsgIndexV2(msg?: Nullable<Message>): bigint;
    static isMsgEnableRecall(msg: Nullable<Message>): boolean;
    static convert(p2PMessageNotify: im_proto.INewP2PMessageNotify): Message;
    static convertStrangerMessage(context: IMSdkContext, body: im_proto.MessageBody): Message;
    /**
     * 更新消息localExt内容写入到DB
     * @param conversationId 待更新消息所属会话
     * @param msgUuid 待更新消息的uuid
     * @param localExt 待更新消息的localExt
     * @param needNotify 更新成功后是否通知业务观察者
     * @returns true 更新成功；false 更新失败
     */
    updateMsgLocalExt(conversationId: string, msgUuid: string, localExt: Map<string, string>, needNotify: boolean): Promise<Nullable<Message>>;
    convert(uuid: string, body: im_proto.IMessageBody, isUpdate: boolean, isAlwaysRead: boolean, cmdMsgType: number, message?: Message): Promise<Message>;
    static getMsgSendInfo(body: im_proto.IMessageBody): SenderInfo | undefined;
    static isMsgUnread(context: IMSdkContext, msg: Message): Promise<boolean>;
    /**
     * 由于历史原因，目前存在两个字段：s:visible和s:invisible。
     * s:visible字段存在，且uid在里面，则对uid可见；不里面则不可见，直接得出结论。
     * 若s:visible不存在，则再判断s:invisible，若uid在黑名单里，则不可见；否则可见
     * @param msg
     * @param uid
     * @return true:不可见;false 可见
     */
    static isMessageInvisibleToUid(msg: Message, uid: string): Promise<boolean>;
    /**
     * 消息的index是否是本地的
     *
     * @return
     */
    static isIndexLocal(msg: Message): boolean;
    static hasReadMessage(imObj: IMSdkBaseObject, selfMsg: Message, readIndex: bigint, readUid: bigint): Promise<boolean>;
    updateRefInfo(conversationId: string, newContent: string, svrId: string, ext: Map<string, string>): Promise<Nullable<Message[]>>;
    static convertReferenceInfoToJson(refInfo: im_proto.IReferenceInfo): string;
    static isBeenMentionedAnyway(msg: Message, currentUid: string): boolean;
    static isGroupOwnerMessage(msg: Message): boolean;
    static isLiveReminderAndWorkSync(msg: Message): boolean;
    static isBeenStraightlyMentioned(msg: Message, currentUid: string): boolean;
    static isBeenBatchMentioned(msg: Message): boolean;
}
