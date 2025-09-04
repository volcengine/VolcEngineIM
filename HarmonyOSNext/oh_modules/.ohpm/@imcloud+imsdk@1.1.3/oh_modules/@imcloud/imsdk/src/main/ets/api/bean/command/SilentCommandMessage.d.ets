import Long from 'long';
import { im_proto } from '../../proto/index';
export interface SilentCommandMessage {
    block_status: im_proto.BlockStatus;
    type: number;
    userID: Nullable<Long[]>;
    blockTime: Map<Long, Long>;
}
