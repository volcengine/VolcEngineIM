export declare class VoipCommandMessage {
    from_user_id: bigint;
    room_id: bigint;
    payload_type: number;
    sequence_id: bigint;
    constructor(contentStr: string);
}
