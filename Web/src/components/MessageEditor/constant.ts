import {
  ImageButton,
  EmojiButton,
  VideoButton,
  MentionButton,
  MorePanelButton,
  AudioButton,
  FileButton,
  VolcButton,
  CouponButton,
} from './ToolBar';

const TOOL_BAR_ITEM_MAP: any = {
  Image: ImageButton,
  Emoji: EmojiButton,
  Video: VideoButton,
  Audio: AudioButton,
  File: FileButton,
  Mention: MentionButton,
  MorePanel: MorePanelButton,
  Volc: VolcButton,
  Coupon: CouponButton,
};

export { TOOL_BAR_ITEM_MAP };
