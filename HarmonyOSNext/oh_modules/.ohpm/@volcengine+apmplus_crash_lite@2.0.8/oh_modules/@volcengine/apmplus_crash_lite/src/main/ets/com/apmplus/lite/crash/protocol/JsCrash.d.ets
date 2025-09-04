/**
 * @madewei
 * @date 2023/11/17
 * 把堆栈处理成服务端要求的json格式
 */
export declare class JsCrash {
    error_message: string;
    source_code: string;
    stack_trace: string;
    constructor(g6: string);
    toJsonString(): string;
}
