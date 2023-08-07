import { name2icon } from './map';

interface EmojiItem {
  name: string;
  icon: string;
}

interface EmojifyParams {
  str: string;
  onMissing?: (str: string) => any;
  format?: (text: string, source: string) => any;
}

const emojiNameRegex = /\[([a-zA-Z0-9\u4e00-\u9fa5]+)\]/g;

const Emoji = {
  emojify(params: EmojifyParams): string {
    if (!params.str) {
      return '';
    }

    return params.str
      .split(emojiNameRegex)
      .map((s: string, i: number) => {
        if (i % 2 === 0) {
          return s;
        }

        const emojiText = this.wrapEmoji(s);
        const emojiRes = this.getEmojiResName(emojiText);

        if (!emojiRes && typeof params.onMissing === 'function') {
          return params.onMissing(s);
        }

        if (emojiRes && typeof params.format === 'function') {
          return params.format(emojiText, emojiRes);
        }

        return emojiText;
      })
      .join('');
  },

  wrapBrackets(str: string) {
    return str.length > 0 ? '[' + str + ']' : '';
  },

  wrapEmoji(str: string) {
    return str[0] !== ']' ? this.wrapBrackets(str) : str;
  },

  getEmojiResName(emoji: string) {
    const icon = name2icon(emoji);
    if (!icon) {
      return;
    }

    return icon;
  },
};

export { Emoji };
