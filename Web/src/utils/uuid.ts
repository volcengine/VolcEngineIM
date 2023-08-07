/**
 * 产生唯一标志ID
 * @param len 长度
 * @param radix 基,产生的随机字符串每一位字符所属的字符集有多大
 * @returns {string}
 * @constructor
 */
export default function UUID(len = 10, radix = 62) {
  const alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split(
    '',
  );
  const uuid = [];
  let i = null;
  let r = null;
  let randomNum = null;
  const alphabetLen = alphabet.length;
  radix = radix || alphabetLen;
  radix = radix > alphabetLen ? alphabetLen : radix;
  if (len) {
    // Compact form
    for (i = 0; i < len; i++) {
      randomNum = 0 | (Math.random() * radix);
      uuid[i] = alphabet[randomNum];
    }
  } else {
    // rfc4122, version 4 form
    // rfc4122 requires these characters
    uuid[8] = '-';
    uuid[13] = '-';
    uuid[18] = '-';
    uuid[23] = '-';
    uuid[14] = '4';
    for (i = 0; i < 36; i++) {
      if (!uuid[i]) {
        r = 0 | (Math.random() * 16);
        uuid[i] = alphabet[i === 19 ? (r & 0x3) | 0x8 : r];
      }
    }
  }
  return uuid.join('');
}
