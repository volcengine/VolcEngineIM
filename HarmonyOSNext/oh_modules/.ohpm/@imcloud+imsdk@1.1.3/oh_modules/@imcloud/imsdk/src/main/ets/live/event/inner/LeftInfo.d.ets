import { MemberInfo } from "./MemberInfo";
export declare class LeftInfo {
    online_member_count: number;
    removed_participant: MemberInfo[];
    operator_type: number;
    operator: string;
    operator_str: string;
}
export declare enum OperationType {
    KNOWN = -1,
    LEAVE = 1,
    KICK = 2
}
