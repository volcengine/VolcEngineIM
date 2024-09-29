export enum StickTopState {
  /** 未置顶 */
  Off = 0,

  /** 已置顶 */
  On = 1,
}

export enum ConversationType {
  ONE_TO_ONE_CHAT = 1,
  GROUP_CHAT = 2,
  LIVE_CHAT = 3,
  BROADCAST_CHAT = 4,
}

export enum MessageType {
  MESSAGE_TYPE_TEXT = 10001,
  MESSAGE_TYPE_STICKER = 10002,
  MESSAGE_TYPE_IMAGE = 10003,
  MESSAGE_TYPE_VIDEO = 10004,
  MESSAGE_TYPE_FILE = 10005,
  MESSAGE_TYPE_AUDIO = 10006,
  MESSAGE_TYPE_LOCATION = 10007,
  MESSAGE_TYPE_SYSTEM = 10008,
  MESSAGE_TYPE_LINK = 10009,
  MESSAGE_TYPE_CUSTOM = 10012,
}

export enum CustomTypeEnum {
  volc = 1,
  notice = 2,
}
