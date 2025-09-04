import { Message } from '../model/Message';
/**
 * 私信已读相关业务注入
 */
export interface IMReadStatusDepend {
    /**
     * 私信已读支持设置，需要过滤用户已读开关状态
     * @param readerListMap <message, <不包含自己的已读的群成员id, 不包含自己的所有能读到消息的群成员id>> 只有已读列表不为空的消息才需要业务层转换
     * @returns [Map<msgId, readerList>, allReadMsgIdList]
     */
    transformSafeReaders: (readerListMap: Map<Message, [bigint[], bigint[]]>) => Promise<[Map<bigint, bigint[]>, bigint[]]>;
}
