import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConvRdbManager } from './IMConvRdbManager';
import { IMFtsRdbManager } from './IMFtsRdbManager';
import { IMInfoRdbManager } from './IMInfoRdbManager';
import { IMMessageRdbManager } from './IMMessageRdbManager';
/**
 * 关系型数据库整体管理类
 */
export declare class IMRdbManager extends IMSdkBaseObject {
    /**
     * 会话数据库管理类
     */
    readonly convRdbManager: IMConvRdbManager;
    /**
     * info数据库管理类
     */
    readonly infoRdbManager: IMInfoRdbManager;
    /**
     * fts数据库管理类
     */
    readonly ftsRdbManager: IMFtsRdbManager;
    /**
     * 消息数据库管理类
     */
    private readonly msgRdbManagers;
    constructor(context: IMSdkContext);
    /**
     * 初始化数据库
     * 主要是建表、建索引等操作
     */
    init(): Promise<void>;
    clearData(): Promise<void>;
    getMsgDbNumber(conversationId: string): number;
    getMsgRdbManager(conversationId: string): IMMessageRdbManager;
    getMsgRdbManagers(): IMMessageRdbManager[];
}
