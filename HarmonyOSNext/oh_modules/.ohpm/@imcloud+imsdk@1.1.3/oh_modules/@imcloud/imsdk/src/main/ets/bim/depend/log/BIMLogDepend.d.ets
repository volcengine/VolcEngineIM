import { IIMLogDepend } from '../../../api/depend/IIMLogDepend';
import { IMLogService } from '@imcloud/imsdk_common';
export declare class BIMLogDepend implements IIMLogDepend {
    private logger;
    constructor(logger: IMLogService);
    debug(...args: string[]): void;
    info(...args: string[]): void;
    warn(...args: string[]): void;
    error(...args: string[]): void;
}
