import Body from './Body';
import faultLogger from '@ohos.faultLogger';
import { CrashLib } from './CrashLib';
/**
 * 处理FaultLog的AppFreeze信息
 */
export default class AppFreeze {
    static parse(t4: faultLogger.FaultLogInfo, u4: Body): void;
    /**
     * 第一个小括号前和/中间作为so的名称， 最后一个括号中间的作为buildid
     * @param stack
     * @returns
     */
    static crashLibParser(e4: string): CrashLib[];
}
