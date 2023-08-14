const getIcon = (n: number) => {
  return require(`./${n}.png`);
};
const emojiMap = {
  微笑: '😊',
  大笑: '😄',
  龇牙笑: '😁',
  爱慕: '😍',
  惊呆: '😲',
  酷拽: '😎',
  流泪: '😢',
  发怒: '😠',
  呲牙: '😬',
  鼾睡: '😴',
  害羞: '😳',
  可爱: '🥰',
  晕: '😵',
  衰: '🥺',
  闭嘴: '🤐',
  机智: '😆',
  灵光一闪: '✨',
  耶: '🙌',
  捂脸: '🤦',
  笑哭: '😂',
  什么: '🤨',
  泣不成声: '😭',
  小鼓掌: '👏',
  笑: '😏',
  思考: '🤔',
  可怜: '😥',
  嘘: '🤫',
  抓狂: '😫',
  钱: '💰',
  吻: '💋',
  恐惧: '😨',
  翻白眼: '🙄',
  互粉: '🤝',
  赞: '👍',
  祈祷: '🙏',
  玫瑰: '🌹',
  啤酒: '🍺',
  委屈: '😩',
  飞吻: '😘',
  再见: '👋',
  求抱抱: '🤗',
  吐舌: '😛',
  呆无辜: '😶',
  骷髅: '💀',
  汗: '😓',
  皱眉: '😕',
  流汗: '😅',
  鬼脸: '😜',
  强: '💪',
  吐: '🤮',
  拳头: '👊',
  彩虹: '🌈',
  比心: '❤️',
  伤心: '💔',
  刀: '🔪',
  屎: '💩',
  礼物: '🎁',
  蛋糕: '🍰',
  撒花: '🎉',
  不看: '🙈',
  炸弹: '💣',
};

export const map: Record<string, number> = {
  微笑: 1,
  大笑: 2,
  龇牙笑: 3,
  爱慕: 4,
  惊呆: 5,
  酷拽: 6,
  流泪: 7,
  发怒: 8,
  呲牙: 9,
  鼾睡: 10,
  害羞: 11,
  可爱: 12,
  晕: 13,
  衰: 14,
  闭嘴: 15,
  机智: 16,
  灵光一闪: 17,
  耶: 18,
  捂脸: 19,
  笑哭: 20,
  什么: 21,
  泣不成声: 22,
  小鼓掌: 23,
  笑: 24,
  思考: 25,
  可怜: 26,
  嘘: 27,
  抓狂: 28,
  钱: 29,
  吻: 30,
  恐惧: 31,
  翻白眼: 32,
  互粉: 33,
  赞: 34,
  祈祷: 35,
  玫瑰: 36,
  啤酒: 37,
  委屈: 38,
  飞吻: 39,
  再见: 40,
  求抱抱: 41,
  吐舌: 42,
  呆无辜: 43,
  骷髅: 44,
  汗: 45,
  皱眉: 46,
  流汗: 47,
  鬼脸: 48,
  强: 49,
  吐: 50,
  拳头: 51,
  彩虹: 52,
  比心: 53,
  伤心: 54,
  刀: 55,
  屎: 56,
  礼物: 57,
  蛋糕: 58,
  撒花: 59,
  不看: 60,
  炸弹: 61,
};

const name2iconMap = Object.keys(map).reduce((acc, key) => {
  acc[`[${key}]`] = map[key];

  return acc;
}, {} as Record<string, number>);

export const icon2nameMap = Object.keys(map).reduce((acc, key) => {
  acc[map[key]] = `[${key}]`;

  return acc;
}, {} as Record<number, string>);

export const name2icon = (name: string) => {
  if (name[0] === '[' && name[name.length - 1] === ']') {
    const realName = name.substr(1, name.length - 2);
    if (realName in map) {
      return getIcon(map[realName]);
    }
  }
};

export const emoticons = Object.values(map).map(icon => ({
  name: icon2nameMap[icon],
  icon: getIcon(icon),
}));
