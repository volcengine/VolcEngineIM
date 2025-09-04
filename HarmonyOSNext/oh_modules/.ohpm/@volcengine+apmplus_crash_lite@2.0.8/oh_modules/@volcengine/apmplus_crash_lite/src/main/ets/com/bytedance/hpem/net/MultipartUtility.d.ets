import HashMap from '@ohos.util.HashMap';
import { IMultipartUtility } from './IMulitipartHeader';
import { INetworkClient } from './INetworkClient';
import Buffer from '@ohos.buffer';
/**
 * @madewei
 * @date 2023/12/11
 */
export declare class MultiPartUtility {
    private boundary;
    private url;
    private line;
    private params;
    private multipartHeader;
    private networkClient;
    constructor(y13: string, z13: IMultipartUtility, a14?: INetworkClient);
    addFormField(u13: string, v13: string, w13?: boolean): void;
    addFilePart(q13: string, r13: string, s13?: HashMap<string, string>): void;
    finish(j13: Function): void;
}
export interface IMultiPart {
    write: (list: Buffer.Buffer[]) => void;
}
