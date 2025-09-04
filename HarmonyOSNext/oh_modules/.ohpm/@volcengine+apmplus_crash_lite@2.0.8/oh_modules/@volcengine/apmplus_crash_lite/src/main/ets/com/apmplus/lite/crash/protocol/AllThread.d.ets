import Stack from './Stack';
/**
 * madewei
 * 2023.12.20
 * 全线程堆栈，支持hiAppEvent和FaultLog
 */
export default class AllThread {
    thread_all_count: number;
    thread_stacks: Stack[];
    constructor(d4: string[]);
    stacksParser(y3: string[]): Stack[];
}
