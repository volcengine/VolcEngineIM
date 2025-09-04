import Long from 'long';
import { im_proto } from '../../api/proto';
export declare class GetGroupConversationListParams {
    sortType?: Nullable<im_proto.SortType>;
    /** GetUserConversationListRequestBody cursor */
    cursor?: Nullable<Long>;
    /** GetUserConversationListRequestBody con_type */
    conType?: Nullable<im_proto.ConversationType>;
    /** GetUserConversationListRequestBody limit */
    limit?: Nullable<Long>;
    /** GetUserConversationListRequestBody include_role */
    includeRole?: Nullable<number>;
    /** GetUserConversationListRequestBody exclude_role */
    excludeRole?: Nullable<number>;
    /** GetUserConversationListRequestBody include_removed_group */
    includeRemovedGroup?: Nullable<boolean>;
    /** GetUserConversationListRequestBody with_cold */
    withCold?: Nullable<boolean>;
    /** GetUserConversationListRequestBody customed_con_type */
    customConType?: Nullable<number>;
    /** GetUserConversationListRequestBody push_status */
    pushStatus?: Nullable<number>;
}
