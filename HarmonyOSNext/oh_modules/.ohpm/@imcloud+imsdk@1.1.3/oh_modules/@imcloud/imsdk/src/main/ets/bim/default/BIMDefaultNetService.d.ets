import { IMAccessor, IMNetService, IMRequest, IMResponse } from '@imcloud/imsdk_common';
/**
 * 兜底使用，无实际意义
 */
export declare class BIMDefaultNetService implements IMNetService {
    postHttp(request: IMRequest): Promise<IMResponse>;
    onConfigReady(json: string): void;
    init(context: Context, imAccessor: IMAccessor): void;
    unInit(context: Context): void;
    onLogin(context: Context, uid: bigint): void;
    onLogout(): void;
}
