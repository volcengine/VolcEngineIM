import { Message } from '../model/Message';
import { im_proto } from '../proto';
export interface IIMExtendMsgHandlerDepend {
    /**
     * 不包括cmd消息
     * @param msg
     * @return
     */
    isMsgUnread: (msg: Message) => boolean;
    /**
     * 重新指定消息的服务器状态，可以用来接入方客制化消息是否隐藏
     * 只有当服务器状态为Enable时才会回调
     * @param msg
     * @return 返回服务器消息状态
     * @see IMEnum.ServerMsgStatus
     */
    genMsgSvrStatus: (msg: Message, body: im_proto.IMessageBody) => number;
    /**
     * 黑科技，接入方可以直接把消息本地任意转换成一个新的消息本体
     * 谨慎使用！！！
     * @param body 如果不需要hack，返回本身即可
     * @param sourceType {@link IMEnum.MsgSource}
     * @return
     */
    hackMessage: (body: im_proto.MessageBody, sourceType: number) => Nullable<im_proto.MessageBody>;
    /**
     * 消息入库前将content返回给业务层做处理
     * @param msg
     */
    hackContent: (msg: Message) => void;
    /**
     * 如果有新消息因为长链推送，但本地cursor不连续导致的丢弃，回调这个接口
     */
    notifyMessageDropped: (body: im_proto.IMessageBody) => void;
    /**
     * 长连接推送回调
     * @param body
     */
    onNewMsgNotify: (body: im_proto.IMessageBody) => void;
}
