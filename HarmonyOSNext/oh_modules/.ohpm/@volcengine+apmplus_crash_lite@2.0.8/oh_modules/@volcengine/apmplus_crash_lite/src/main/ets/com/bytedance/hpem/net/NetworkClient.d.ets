import { INetworkClient } from './INetworkClient';
export declare class NetworkClient implements INetworkClient {
    private static default;
    private static userNetworkClient;
    private static getDefault;
    static getNetworkClient(): INetworkClient;
    static setNetworkClient(w14: INetworkClient): void;
    post(s14: string, t14: string | ArrayBuffer, u14: Object, v14: Function): void;
    get(o14: string, p14: string, q14: Object, r14: Function): void;
    execute(b14: string, c14: boolean, d14: string | ArrayBuffer, e14: Object, f14: Function): void;
}
