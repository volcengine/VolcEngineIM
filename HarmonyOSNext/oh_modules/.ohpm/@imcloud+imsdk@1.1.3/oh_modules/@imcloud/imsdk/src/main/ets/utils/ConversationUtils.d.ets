import { Conversation } from '../api/model/Conversation';
import { Member } from '../api/model/Member';
import { Message } from '../api/model/Message';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { ConversationCoreInfo } from '../api/model/ConversationCoreInfo';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class ConversationUtils extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    static convertFromMessageBody(context: IMSdkContext, inboxType: number, conversation: Nullable<Conversation>, info: im_proto.IConversationInfoV2, updateTime: number, from?: string, lastMessage?: Nullable<Message>, sortOrderMsg?: Nullable<Message>, members?: Member[], shouldCalUnread?: boolean): Promise<Conversation>;
    private static updateAllBots;
    static updateSkipMuteBadgeCount(context: IMSdkContext, conversation: Conversation, infos: Nullable<im_proto.IMuteBadgeCountInfo[]>): Promise<void>;
    static setMuteBadgeOrMuteReadBadgeCount(conversation: Conversation, type: string, count: number): boolean;
    static convertMessageTypeToString(messageType: im_proto.MuteMessageType): string | undefined;
    static markReadAllUnreadSkipMuteMsg(context: IMSdkContext, conversation: Conversation): Promise<void>;
    static clearUnReadSkipMuteTypeCount(conversation: Conversation, type: string): boolean;
    static updateSkipMuteReadBadgeCount(imSdkContext: IMSdkContext, conversation: Conversation, muteReadBadgeCountInfos: im_proto.IMuteReadBadgeCountInfo[] | undefined): Promise<void>;
    static updateLastHintMsgWithLastMsgIfNeed(context: IMSdkContext, conversation: Conversation): void;
    static setLastMessage(imObj: IMSdkBaseObject, conversation: Conversation, lastMsg: Nullable<Message>): void;
    /**
     * 更新localExt后saveDB
     * @param conversation
     * @param needNotifyObserver 默认为false，表示不同步观察者，对齐android的默认行为
     */
    updateConversationLocalExt(conversation: Conversation, needNotifyObserver?: boolean): Promise<boolean>;
    static isFansGroup(conversation: Conversation): boolean;
    static convertCoreInfo(cid: string, coreInfoFromRemote: im_proto.IConversationCoreInfo, coreInfoFromLocal?: ConversationCoreInfo): ConversationCoreInfo;
    tryUpdateMemoryConversationUseMsg(conversation: Conversation, lastMsg: Message, sortOrderMsg?: Message): Promise<void>;
    findConversationIdByUid(uid: string): string;
}
