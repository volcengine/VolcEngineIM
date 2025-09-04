import { ServerMessageStatus } from '../../../api/const/consts';
import { IIMExtendMsgHandlerDepend } from '../../../api/depend/IIMExtendMsgHandlerDepend';
import { Message } from '../../../api/model/Message';
import { im_proto } from '../../../api/proto';
export declare class BIMExtendMsgHandlerDepend implements IIMExtendMsgHandlerDepend {
    isMsgUnread(msg: Message): boolean;
    genMsgSvrStatus(msg: Message, body: im_proto.IMessageBody): ServerMessageStatus;
    hackMessage(body: im_proto.MessageBody, sourceType: number): Nullable<im_proto.MessageBody>;
    /**
     * 消息入库前将content返回给业务层做处理
     */
    hackContent(msg: Message): void;
    notifyMessageDropped(body: im_proto.IMessageBody): void;
    onNewMsgNotify(body: im_proto.IMessageBody): void;
}
