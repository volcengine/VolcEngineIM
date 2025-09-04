export declare class UpdateMinIndexMessage {
    conversation_type: number;
    min_index: bigint;
    inbox_type: number;
    conversation_id: string;
    constructor(contentStr: string);
    isValid(): boolean;
}
