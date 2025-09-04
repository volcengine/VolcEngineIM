import { IIMHostEnvDepend } from '../../../api/depend/IIMHostEnvDepend';
export declare class BIMHostEnvDepend implements IIMHostEnvDepend {
    isMainProcess(): boolean;
    getCurrentServerTime(): number;
    getDeltaTimeFromServer(): number;
    isNewUser(): boolean;
}
