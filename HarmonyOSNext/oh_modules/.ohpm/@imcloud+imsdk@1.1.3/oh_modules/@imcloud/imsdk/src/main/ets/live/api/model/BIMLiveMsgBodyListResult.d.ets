import Long from 'long';
import { im_proto } from '../../../api/proto';
export declare class BIMLiveMsgBodyListResult {
    hasMore: boolean;
    nextCursor: Long;
    msgBodyList: im_proto.IMessageBody[];
    constructor(hasMore: boolean, nextCursor: Long, messageList: im_proto.IMessageBody[]);
}
