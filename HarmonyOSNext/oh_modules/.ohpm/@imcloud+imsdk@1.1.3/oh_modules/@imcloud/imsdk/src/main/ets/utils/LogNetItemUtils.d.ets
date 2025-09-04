import { im_proto } from '../api/proto';
export declare class LogNetItemUtils {
    static stringifyRequest(request: im_proto.Request | undefined): string;
    static stringifyResponse(response: im_proto.Response | undefined): string;
}
