export declare class GetGroupSettingInfoParams {
    inboxType: number;
    conversationId: string;
    conversationShortId: bigint;
    useLocalCached: boolean;
    typeList: number[];
    constructor(conversationId: string, convShortId: bigint, inboxType: number, typeList: number[], useLocalCached: boolean);
    get infoStr(): string;
}
