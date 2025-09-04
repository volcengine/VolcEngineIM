import { ReceiveMsgExtra } from '../api/bean/message/ReceiveMsgExtra';
import { SendMsgStatus, StatusCode } from '../api/const/consts';
import { Message } from '../api/model/Message';
import { LocalPropertyItem, ModifyMsgPropertyMsg } from '../api/model/MessageProperty';
import { LoadTypeEnum } from '../model/loader/MessageLoader';
import { MessageInitLoadAnchor } from '../model/MessageModel';
export interface IMessageObserver {
    /**
     * 发送消息
     *
     * @param statusCode 状态码
     * @param message 消息
     * @param metrics 发送消息指标
     */
    onSendMessage(statusCode: SendMsgStatus, message: Message): void;
    /**
     * 发送消息下行推送回调
     *
     * @param message 消息
     * @param hasChanged 消息状态、check_message 是否发生改变
     */
    onSendMessageAsyncResp(message: Message, hasChanged: boolean): void;
    /**
     * 添加消息
     *
     * @param message 消息
     */
    onAddMessage(statusCode: StatusCode, message: Message): void;
    /**
     * 接收消息
     *
     * @param list 消息列表
     * @param msgSource 消息来源
     * @param extra 接收消息额外数据
     */
    onGetMessage(list: Message[], msgSource: number, extra: ReceiveMsgExtra): void;
    /**
     * 删除消息
     *
     * @param message
     */
    onDelMessage(message: Message): void;
    /**
     * 消息拉取
     *
     * @param list
     * @param direction 消息拉取方向，定义见 IMConstants.MsgLoadDirection
     */
    onQueryMessage(list: Message[], direction: number, from?: string): void;
    /**
     * MessageModel 注册就会回调
     *
     * @param list
     */
    onRegisterStickObserver(list: Message[]): void;
    /**
     * 消息更新
     *
     * @param list
     */
    onUpdateMessage(list: Message[]): void;
    /**
     * 消息被编辑，通知业务
     * @param message
     */
    onEditMessage(message: Message[]): void;
    /**
     * 撤回消息回调
     *
     * @param message
     */
    onRecallMessage(message: Message): void;
    /**
     * 清空消息回调
     */
    onClearMessage(conversationId: string, needNotify: boolean): void;
    /**
     * 接收属性消息
     * @param oldPropertyItemListMap 变更前的属性
     * @param newPropertyItemListMap 变更后的属性
     *                               业务可以根据oldPropertyItemListMap、newPropertyItemListMap计算出本次新增或减少了哪些属性
     */
    onGetModifyPropertyMsg(msg: Message, oldPropertyMap: Map<string, LocalPropertyItem[]>, newProperty: Map<string, LocalPropertyItem[]>): void;
    /**
     * 发送修改消息属性
     *
     * @param statusCode:<br>      {@link com.bytedance.im.core.client.IMEnum.StatusCode#IM_ILLEGAL_PARAMETERS} 参数非法<br>
     *                             {@link com.bytedance.im.core.client.IMEnum.StatusCode#OK} 网络请求成功，返回成功<br>
     *                             {@link com.bytedance.im.core.client.IMEnum.StatusCode#IM_GET_MESSAGE_FAIL} 网络请求成功，返回错误<br>
     * @param modifyMsgPropertyMsg 发送请求时的参数
     */
    onSendModifyPropertyMsg(statusCode: number, modifyMsgPropertyMsg: ModifyMsgPropertyMsg): void;
}
/**
 * 会话详情页消息加载结果
 */
export declare class MessageListLoadResult {
    msgList?: Message[];
    anchor?: MessageInitLoadAnchor;
    success?: boolean;
    hasMore?: boolean;
    loadType?: LoadTypeEnum;
    dataSourceFrom?: number;
}
