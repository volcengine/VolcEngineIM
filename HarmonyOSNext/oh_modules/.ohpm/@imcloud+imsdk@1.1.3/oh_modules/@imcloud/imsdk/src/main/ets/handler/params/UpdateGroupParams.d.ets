import { im_proto } from '../../api/proto';
export declare class UpdateGroupParams {
    inboxType: number;
    conversationId: string;
    conversationShortId: string;
    updateValue: Nullable<string>;
    type: number;
    groupManagerSettingInfo: Nullable<im_proto.IGetGroupManagerInfoResponseBody>;
    constructor(conversationId: string, convShortId: string, inboxType: number, type: number, updateValue: Nullable<string>, groupManagerSettingInfo?: Nullable<im_proto.IGetGroupManagerInfoResponseBody>);
    get infoStr(): string;
}
