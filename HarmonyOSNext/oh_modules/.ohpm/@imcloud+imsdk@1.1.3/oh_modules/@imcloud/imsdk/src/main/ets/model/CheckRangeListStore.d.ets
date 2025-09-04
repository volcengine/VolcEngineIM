import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { RangeList } from './LeakMsgRepairedRangeStore';
export declare class CheckRangeListStore extends IMSdkBaseObject {
    private static MAX_LRU;
    private readonly lruCache;
    constructor(context: IMSdkContext);
    get(convId: string): Promise<RangeList>;
    update(convId: string, rangeList: RangeList): Promise<void>;
}
