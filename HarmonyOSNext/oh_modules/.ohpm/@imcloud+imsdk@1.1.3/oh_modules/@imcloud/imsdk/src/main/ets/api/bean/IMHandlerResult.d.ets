/**
 * IM网络请求结果的结构体, 对外暴露
 *                                    true -> 请求结果成功 -> 使用data
 *                                 /
 * 业务消费一般流程 --> success --
 *                                 \
 *                                   false -> 请求结果失败 -> 查看errorInfo状态码
 *
 * 简单直接可以这样用：
 *
 *    if(result && result.data){
 *      doSomeThingWithData(result.data)
 *    }else {
 *      seeWhatHappened(result?.errorInfo)
 *    }
 */
export interface IMResult<T> {
    success?: boolean;
    data?: Nullable<T>;
    errorMsg?: string;
    errorInfo?: Nullable<IMError>;
    extMap?: Map<string, string>;
}
export interface IMError {
    errorCode?: number;
    statusCode?: number;
    extraInfo?: string;
    checkCode?: bigint;
    checkMsg?: string;
    responseLogId?: Nullable<string>;
}
