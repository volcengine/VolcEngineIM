import { im_proto } from '@volcengine/im-web-sdk';

export const SEND_MESSAGE_STATUS_STR: { [k in im_proto.SendMessageStatus]: string } = {
  [im_proto.SendMessageStatus.SEND_SUCCEED]: 'SEND_SUCCEED',
  [im_proto.SendMessageStatus.USER_NOT_IN_CONVERSATION]: 'USER_NOT_IN_CONVERSATION',
  [im_proto.SendMessageStatus.CHECK_CONV_NOT_PASS]: 'CHECK_CONV_NOT_PASS',
  [im_proto.SendMessageStatus.CHECK_MSG_NOT_PASS]: 'CHECK_MSG_NOT_PASS',
  [im_proto.SendMessageStatus.CHECK_MSG_NOT_PASS_BUT_SELF_VISIBLE]: 'CHECK_MSG_NOT_PASS_BUT_SELF_VISIBLE',
  [im_proto.SendMessageStatus.USER_HAS_BEEN_BLOCKED]: 'USER_HAS_BEEN_BLOCKED',
  [im_proto.SendMessageStatus.CHECK_SUB_CONV_STATUS_ERROR]: 'CHECK_SUB_CONV_STATUS_ERROR',
  [im_proto.SendMessageStatus.CHECK_CONVERSATION_NOT_FOUND]: 'CHECK_CONVERSATION_NOT_FOUND',
};
