export declare class LoadMsgByIndexV2RangeParams {
    convId: string;
    minIndexV2: bigint;
    maxIndexV2: bigint;
    direction: number;
    constructor(convId: string, minIndex: bigint, maxIndex: bigint, direction: number);
    get str(): string;
}
