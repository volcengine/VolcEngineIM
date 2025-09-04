import { BIMBaseElement } from './BIMBaseElement';
/**
 * @hidden
 */
export declare class BIMSystemElement extends BIMBaseElement {
    conversation_id: string;
    command_type: number;
    conversation_type: number;
    inboxType: number;
    added_participant: bigint[];
    modified_participant: bigint[];
    removed_participant: bigint[];
    text: string;
}
