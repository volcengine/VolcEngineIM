import { Message } from '../../api/model/Message';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMMsgSearchDataSource } from '../datasource/IMMsgSearchDataSource';
export declare class IMMsgLikeSearchDao extends IMSdkBaseObject implements IMMsgSearchDataSource {
    private readonly dbManager;
    private readonly TOTAL_BUILD_FTS_INDEX_TIMES;
    private readonly EACH_BUILD_FTS_INDEX_LIMIT;
    constructor(context: IMSdkContext);
    /**
     * 建立FTS索引
     * @returns
     */
    buildSearchIndex(): Promise<void>;
    /**
     * 建立FTS索引
     * @returns
     */
    delayBuildSearchIndex(seconds: number): void;
    private doBuildSearchIndex;
    insertOrUpdateList(messageList: Message[]): Promise<void>;
    queryMsgsByConvId(conversationId: string, key: string, limit: number, createdTime?: number): Promise<Nullable<Message[]>>;
    private buildValues;
    deleteByMsgUuid(msgUuid: string): Promise<number>;
    batchDeleteByMsgUuid(msgUuid: string[]): Promise<number>;
    deleteByCid(conversationId: string): Promise<number>;
}
