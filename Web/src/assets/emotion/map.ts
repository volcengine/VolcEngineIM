const getIcon = (n: number) => {
  return require(`./${n}.png`);
};

export const map: Record<string, number> = {
  微笑: 1,
  爱慕: 2,
  惊呆: 3,
  酷拽: 4,
  抠鼻: 5,
  流泪: 6,
  发怒: 7,
  呲牙: 8,
  鼾睡: 9,
  害羞: 10,
  可爱: 11,
  晕: 12,
  衰: 13,
  闭嘴: 14,
  机智: 15,
  来看我: 16,
  灵光一闪: 17,
  耶: 18,
  捂脸: 19,
  打脸: 20,
  大笑: 21,
  哈欠: 22,
  震惊: 23,
  送心: 24,
  困: 25,
  what: 26,
  泣不成声: 27,
  小鼓掌: 28,
  大金牙: 29,
  偷笑: 30,
  石化: 31,
  思考: 32,
  吐血: 33,
  可怜: 34,
  嘘: 35,
  撇嘴: 36,
  黑线: 37,
  笑哭: 38,
  雾霾: 39,
  奸笑: 40,
  得意: 41,
  憨笑: 42,
  抓狂: 43,
  泪奔: 44,
  钱: 45,
  吻: 46,
  恐惧: 47,
  笑: 48,
  快哭了: 49,
  翻白眼: 50,
  互粉: 51,
  赞: 52,
  鼓掌: 53,
  祈祷: 54,
  kiss: 55,
  去污粉: 56,
  '666': 57,
  玫瑰: 58,
  胡瓜: 59,
  啤酒: 60,
  我想静静: 61,
  委屈: 62,
  舔屏: 63,
  鄙视: 64,
  飞吻: 65,
  再见: 66,
  紫薇别走: 67,
  听歌: 68,
  求抱抱: 69,
  周冬雨的凝视: 70,
  马思纯的微笑: 71,
  吐舌: 72,
  呆无辜: 73,
  看: 74,
  白眼: 75,
  熊吉: 76,
  骷髅: 77,
  黑脸: 78,
  吃瓜群众: 79,
  绿帽子: 80,
  汗: 81,
  摸头: 82,
  皱眉: 83,
  擦汗: 84,
  红脸: 85,
  尬笑: 86,
  做鬼脸: 87,
  强: 88,
  如花: 89,
  吐: 90,
  惊喜: 91,
  敲打: 92,
  奋斗: 93,
  吐彩虹: 94,
  大哭: 95,
  比心: 96,
  加油: 97,
  碰拳: 98,
  ok: 99,
  击掌: 100,
  左上: 101,
  握手: 102,
  刀: 104,
  V5: 105,
  给力: 106,
  心: 107,
  伤心: 108,
  屎: 109,
  礼物: 110,
  蛋糕: 111,
  撒花: 112,
  不看: 113,
  炸弹: 114,
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

export const emoticons = [
  19, 21, 8, 2, 6, 10, 17, 7, 5, 4, 18, 11, 15, 20, 38, 61, 44, 52, 54, 58, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
  33, 34, 35, 36, 37, 9, 39, 40, 41, 42, 43, 3, 45, 46, 47, 48, 49, 50, 51, 83, 84, 85, 87, 86, 81, 90, 91, 82, 16, 62,
  63, 64, 65, 67, 94, 68, 69, 70, 71, 92, 80, 66, 79, 88, 89, 93, 13, 14, 12, 95, 101, 53, 102, 96, 97, 98, 99, 100, 55,
  56, 57, 59, 112, 60, 107, 108, 109, 72, 73, 74, 75, 76, 113, 78, 77, 114, 111, 110, 104, 105, 106, 1,
].map(icon => ({
  name: icon2nameMap[icon],
  icon: getIcon(icon),
}));