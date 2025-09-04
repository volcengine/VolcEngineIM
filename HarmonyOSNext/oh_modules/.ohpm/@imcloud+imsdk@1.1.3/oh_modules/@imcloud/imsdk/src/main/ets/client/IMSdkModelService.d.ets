import { IConversationListModel } from '../api/model/IConversationListModel';
import { IMessageModel } from '../model/IMessageModel';
import { IMSearchModel } from '../model/IMSearchModel';
import { IMSdkContext } from './IMSdkContext';
import { ILabelModel } from '../model/ILabelModel';
import { IStrangerListModel } from '../model/IStrangerListModel';
import { IMessageBrowserModel } from '../model/IMessageBrowserModel';
import { IConversationAuditModel } from '../model/IConversationAuditModel';
/**
 * 提供IMSDK所有对外暴露的Model
 */
export declare class IMSdkModelService {
    protected readonly context: IMSdkContext;
    private conversationListModel;
    private strangerListModel;
    private conversationAuditModel;
    private labelModel;
    constructor(context: IMSdkContext);
    /**
     * 会话标签构建能力，依赖业务注入会话打标实现
     * @returns
     */
    getLabelModel(): ILabelModel;
    /**
     * 获取IM-SDK内部会话列表数据查询、会话列表维度的会话操作能力
     * @returns
     */
    getConversationListModel(): IConversationListModel;
    /**
     * 消息数据加载、查询Model
     * @param conversationId
     * @returns
     */
    getMessageModel(conversationId: string): IMessageModel;
    /**
     * 特定消息类型的消息数据加载、查询Model
     * @param conversationId
     * @param filterMsgTypes
     * @returns
     */
    getMessageBrowserModel(conversationId: string, filterMsgTypes: number[]): IMessageBrowserModel;
    /**
     * 陌生人会话、陌生人消息盒子，数据加载和操作
     * @param inboxType 会话/消息收件箱标识符，默认使用InBoxType.DEFAULT，一般不用关注，业务有自定义诉求可以配置其他
     * @param pageSize 分页数据加载的size
     * @returns 返回陌生人数据加载、操作的Model
     */
    getStrangerListModel(inboxType?: number, pageSize?: number): IStrangerListModel;
    /**
     * 群聊相关的审核操作
     * @returns
     */
    getConversationAuditModel(): IConversationAuditModel;
    getSearchModel(): IMSearchModel;
}
