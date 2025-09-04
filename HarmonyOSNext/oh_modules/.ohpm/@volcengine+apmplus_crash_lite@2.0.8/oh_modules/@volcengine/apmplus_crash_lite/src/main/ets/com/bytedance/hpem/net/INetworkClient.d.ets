export interface INetworkClient {
    post: (url: string, body: string | ArrayBuffer, header: Object, callback: Function) => void;
    get: (url: string, body: string, header: Object, callback: Function) => void;
}
