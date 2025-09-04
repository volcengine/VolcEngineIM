import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IMMsgDataSource } from '../storage/datasource/IMMsgDataSource';
import { Message } from '../api/model/Message';
export declare class LeakMsgRepairManager extends IMSdkBaseObject {
    dataSource: IMMsgDataSource;
    constructor(context: IMSdkContext);
    /**
     * 检查拿到的消息是否连续
     * @param convId
     * @param msgList
     * @returns [消息是否连续，连续的消息]
     */
    findPreContinue(convId: string, msgList: Message[]): Promise<Nullable<[boolean, Message[]]>>;
    /**
     * 从获取到的消息列表中的maxIndexV2开始往老的消息方向找一段连续的消息子列表返回给用户
     * 如果不连续区间超过一页（20个消息），则直接返回给用户
     * @param convId
     * @param baseIndex
     * @param leakIndexList
     * @param msgList
     * @returns
     */
    getContinueMsgList(convId: string, baseIndex: bigint, leakIndexList: bigint[], msgList: Message[]): Promise<Message[] | undefined>;
    checkCurrentMsgIndexInValid(baseIndex: bigint, hasValidIndex: boolean, index: bigint): boolean;
    getLoadOlderMinOrderIndex(conversationId: string, localMinIndex: bigint): Promise<bigint>;
    getLoadNewerMaxOrderIndex(conversationId: string, localMaxIndex: bigint): Promise<bigint>;
    onUpdateMsg(convId: string, msgList: Message[]): Promise<void>;
}
