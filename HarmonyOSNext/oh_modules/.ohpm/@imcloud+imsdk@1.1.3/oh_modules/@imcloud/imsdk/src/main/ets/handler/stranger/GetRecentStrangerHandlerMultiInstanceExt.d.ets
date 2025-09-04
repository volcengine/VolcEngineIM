import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { GetRecentStrangerMsgResult } from './GetRecentStrangerHandler';
export declare class GetRecentStrangerHandlerMultiInstanceExt extends IMSdkBaseObject {
    private lastTrimUptimeMs;
    private isLoadMoreLoading;
    private isRefreshing;
    private static LOAD_MORE_ERROR_LOADING;
    private static MIN_TRIM_DURATION_MS;
    constructor(context: IMSdkContext);
    refresh(source: string): Promise<GetRecentStrangerMsgResult | undefined>;
    loadMore(startVersion?: bigint): Promise<GetRecentStrangerMsgResult | undefined>;
    trimStranger(): Promise<void>;
    setRefreshing(refreshing: boolean): void;
    setIsLoadMoreLoading(isLoadMoreLoading: boolean): void;
}
