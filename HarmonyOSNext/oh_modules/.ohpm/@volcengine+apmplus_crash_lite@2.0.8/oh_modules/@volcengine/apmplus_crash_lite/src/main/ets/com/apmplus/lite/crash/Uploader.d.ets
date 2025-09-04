import { Config } from './Config';
import { IMultipartUtility } from '../../../bytedance/hpem/net/IMulitipartHeader';
export default class Uploader {
    static start(p11: Context, q11: Config): Promise<void>;
    private static handle;
    private static acceptCrash;
    private static acceptStack;
    private static uploadCrash;
    private static getUploadUrl;
}
export declare class MultiPartHeader implements IMultipartUtility {
    private boundary;
    private config;
    constructor(j10: Config);
    getHeader(): object;
    getBoundary(): string;
}
