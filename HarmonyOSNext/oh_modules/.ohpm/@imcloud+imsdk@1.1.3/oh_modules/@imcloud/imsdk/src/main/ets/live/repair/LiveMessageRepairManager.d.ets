import Long from "long";
import { BIMConversation } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { LiveLifeManager } from "../life/LiveLifeManager";
import { DelayInfo } from "./DelayInfo";
/**
 * 消息缺失兜底拉取
 */
export declare class LiveMessageRepairManager {
    private TAG;
    private conversation;
    private localLastIndexV2;
    private PAGE_SIZE;
    private liveLifeManager;
    private isPulling;
    private static delayInfoList;
    private bimClient;
    private context;
    constructor(context: IMSdkContext, manager: LiveLifeManager, conversation: BIMConversation, oldestIndexV2: Long);
    log(content: string): void;
    isLeak(serverIndexV2: Long, from: CheckFrom): boolean;
    /**
     * 随机数打散客户读请求
     * @return
     */
    private getRepairDelay;
    /**
     * 是否需要拉取消息补偿
     * 服务端 indexV2 和本地最新是否连续,不连续则补偿 1、断连重新ping通后 2、收到新的消息
     * https://bytedance.feishu.cn/wiki/AIpsw1P0aiVMv6kO0SecJKNLn9d
     * @param serverIndexV2
     */
    checkMayPullMessage(serverIndexV2: Long, from: CheckFrom): boolean;
    private pullMessageList;
    static setDelayInfoList(delayInfoList: DelayInfo[]): void;
}
export declare enum CheckFrom {
    JOIN = 0,
    RECEIVE_MESSAGE = 1,
    PING = 2,
    CONNECTED = 3
}
