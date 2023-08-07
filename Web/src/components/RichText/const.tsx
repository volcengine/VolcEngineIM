import { richTextTag } from './interface';
import Mention from './Mention';
import Emotion from './Emotion';
import Text from './Text';
import Paragraph from './Paragraph';

const RichComponentMap: any = {
  [richTextTag.EMOTION]: Emotion,
  [richTextTag.TEXT]: Text,
  [richTextTag.AT]: Mention,
  [richTextTag.P]: Paragraph,
};

export { RichComponentMap };
