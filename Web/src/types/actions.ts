export enum ActionEvent {
  MessageHasRead = 'MessageHasRead' /** 消息已读 */,
  ReceiveNewMessage = 'ReceiveNewMessage' /** 收到非 50000+ 新消息 */,
  Jump = 'Jump' /** 跳转 */,
  UnReadCountChange = 'UnReadCountChange' /** 未读数改变 */,
  ConversationTrigger = 'ConversationTrigger' /** 会话改变 */,
}
