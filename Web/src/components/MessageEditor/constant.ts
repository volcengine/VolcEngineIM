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
import VideoButtonV2 from './ToolBar/VideoButtonV2';

const TOOL_BAR_ITEM_MAP: any = {
  Image: ImageButton,
  Emoji: EmojiButton,
  Video: VideoButton,
  VideoV2: VideoButtonV2,
  Audio: AudioButton,
  File: FileButton,
  Mention: MentionButton,
  MorePanel: MorePanelButton,
  Volc: VolcButton,
  Coupon: CouponButton,
};

export { TOOL_BAR_ITEM_MAP };
