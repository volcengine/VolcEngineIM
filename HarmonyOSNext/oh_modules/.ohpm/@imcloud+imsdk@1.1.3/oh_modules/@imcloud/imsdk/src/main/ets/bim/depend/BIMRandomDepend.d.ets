import { IIMSdkRandomDepend } from '../../api/depend/IIMSdkRandomDepend';
export declare class BIMRandomDepend implements IIMSdkRandomDepend {
    getUuidV4(): string;
    int(lower: number, upper?: number): number;
}
