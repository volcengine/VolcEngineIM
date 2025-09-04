import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare enum PreferencesServiceConst {
    SP_NAME_PREFIX = "imsdk_preferences",
    KEY_RECENT_CONV_VERSION = "recent_conv_version",
    KEY_CMD_INDEX = "cmd_index",
    KEY_READ_VERSION = "read_version",
    KEY_RECENT_CONV_RANGE = "recent_conv_range",
    KEY_IM_INIT_V2 = "im_init_v2",
    KEY_IM_INIT = "im_init",
    KEY_CURSOR = "msg_by_user_cursor",
    KEY_IM_INIT_CURSOR = "im_init_page_cursor",
    KEY_INIT_V2_FAIL_VERSION = "init_v2_fail_version",
    KEY_EVER_USE_INIT_V2 = "ever_user_init_v2",
    KEY_EVER_USE_RECENT_LINK = "ever_use_recent_link",
    KEY_STOCK_SORT_ORDER_UPDATED = "stock_sort_order_updated",
    KEY_RECENT_STRANGER_VERSION = "recent_stranger_version",
    KEY_RECENT_STRANGER_LOAD_MORE_VERSION = "recent_stranger_load_more_version",
    KEY_CONSULT_VERSION = "consult_version_new",
    KEY_LAST_LOGIN_UID = "last_login_uid",
    KEY_ALLOW_CONVERSATION_PAGINATION = "allow_conversation_pagination",
    KEY_MSG_TABLE_FLAG_UPDATED = "msg_flag_bits_updated",
    KEY_CON_CORE_INFO_CREATOR_UPDATED = "con_core_info_creator_updated",
    KEY_ERROR_VERSION = "error_conv_version",
    KEY_MARK_NOT_DISPLAY_ORDER_INDEX = "mark_not_display_order_index_",
    KEY_DRAFT_UPDATED_AFTER_NOT_DISPLAY = "draft_updated_after_not_display_",
    KEY_MIN_INDEX = "min_index",
    KEY_LABEL_VERSION = "label_version",
    KEY_CMD_VERSION_RANGE_STORE = "cmd_version_range_store",
    KEY_MARK_READ_VERSION_RANGE_STORE = "mark_read_version_range_store",
    KEY_IM_CONFIG = "key_im_config",
    KEY_IM_LAST_LOGIN_INFO = "key_last_login_info"
}
export declare class PreferencesService extends IMSdkBaseObject {
    private preferences;
    private defaultBigIntValue;
    constructor(context: IMSdkContext);
    init(): Promise<void>;
    clear(): Promise<void>;
    private getKey;
    private mixKey;
    getBigint(key: string, defValue: bigint): Promise<bigint>;
    putBigint(key: string, value: bigint): Promise<void>;
    private getNumber;
    private putNumber;
    private getBoolean;
    private putBoolean;
    private getString;
    private getStringArr;
    private putStringArr;
    private putString;
    getRecentVersion(inbox: number): Promise<bigint>;
    setRecentVersion(inbox: number, version: bigint): Promise<void>;
    getCmdIndex(inbox: number): Promise<bigint>;
    setCmdIndex(inbox: number, index: bigint): Promise<void>;
    getMarkReadVersion(inbox: number): Promise<bigint>;
    setMarkReadVersion(inbox: number, version: bigint): Promise<void>;
    /**
     * 获取陌生人会话链LoadMore起点
     * @param inbox
     * @returns
     */
    getStrangerLoadMoreVersion(inbox?: number): Promise<bigint>;
    /**
     * 设置陌生人会话链LoadMore起点
     * @param inbox
     * @returns
     */
    setStrangerLoadMoreVersion(version: bigint, inbox?: number): Promise<void>;
    getStrangerVersion(inbox?: number): Promise<bigint>;
    setStrangerVersion(version: bigint, inbox?: number): Promise<void>;
    getConsultVersion(inbox: number): Promise<bigint>;
    setConsultVersion(inbox: number, version: bigint): Promise<void>;
    getRecentLinkRange(inbox: number, isStart: boolean): Promise<bigint[]>;
    setRecentLinkRange(inbox: number, isStart: boolean, value: bigint[]): Promise<void>;
    isImInit(inbox: number): Promise<boolean>;
    setImInit(inbox: number, isInit: boolean): Promise<void>;
    isIMCloudInit(inbox: number): Promise<boolean>;
    setIMCloudInit(inbox: number, isInit: boolean): Promise<void>;
    getIMInitPageCursor(inbox: number): Promise<bigint>;
    setIMInitPageCursor(inbox: number, initPageCursor: bigint): Promise<void>;
    setIMCloudUserMsgCursor(inbox: number, userMsgCursor: bigint): Promise<void>;
    getIMCloudUserMsgCursor(inbox: number): Promise<bigint>;
    getInitV2FailVersion(inbox: number): Promise<bigint>;
    setInitV2FailVersion(inbox: number, version: bigint): Promise<void>;
    isEverUseInitV2(): Promise<boolean>;
    markEverUseInitV2(): Promise<void>;
    isEverUseRecentLink(): Promise<boolean>;
    markUseRecentLink(): Promise<void>;
    isConSortOrderUpdated(inbox: number, cid: string): Promise<boolean>;
    setConSortOrderUpdated(inbox: number, cid: string): Promise<void>;
    getLastLoginUid(): Promise<string>;
    setLoginUid(uid: string): Promise<void>;
    isAllowPagination(): Promise<boolean>;
    setAllowPagination(): Promise<void>;
    isMsgTableFlagUpdated(): Promise<boolean>;
    setMsgTableFlagUpdated(updated: boolean): Promise<void>;
    isConCoreInfoCreatorUpdated(): Promise<boolean>;
    setConCoreInfoCreatorUpdated(updated: boolean): Promise<void>;
    isDraftUpdatedAfterNotDisplay(conversationId: string): Promise<boolean>;
    setDraftUpdatedAfterNotDisplay(conversationId: string, draftUpdated: boolean): Promise<void>;
    getMarkNotDisplayOrderIndex(conversationId: string): Promise<bigint>;
    setMarkNotDisplayOrderIndex(conversationId: string, orderIndex: bigint): Promise<void>;
    shouldIgnoreVersionError(inbox: number): Promise<boolean>;
    setMinIndex(convId: string, minIndex: bigint): Promise<void>;
    getMinIndex(convId: string): Promise<bigint>;
    setCmdVersionRange(inbox: number, value: string): Promise<void>;
    getCmdVersionRange(inbox: number): Promise<string>;
    setMarkReadVersionRange(inbox: number, value: string): Promise<void>;
    getMarkReadVersionRange(inbox: number): Promise<string>;
    setIMConfig(inbox: number, json: string): Promise<void>;
    getIMConfig(inbox: number): Promise<string>;
    setLastLoginToken(key: string, token: string): Promise<void>;
    getLastLoginToken(key: string): Promise<string>;
}
