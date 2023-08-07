export interface MatchPattern {
  name: string;
  test: RegExp | ((userAgent?: string) => any);
}

export function _matchUA(rule: MatchPattern, userAgent: string): boolean {
  const { test } = rule;
  if (typeof test === 'function') {
    return test(userAgent);
  }
  return new RegExp(test).test(userAgent);
}

export const getUserAgent = () => {
  const { userAgent } = navigator;
  return userAgent;
};

const platforms: MatchPattern[] = [
  {
    name: 'ios',
    test: /iphone|ipad/gi,
  },
  {
    name: 'android',
    test: /android/gi,
  },
  {
    name: 'UNKNOWN',
    test: (): any => null,
  },
];

export function _getPlatform(userAgent: string): string {
  const matchedPlatform = platforms.find(rule => _matchUA(rule, userAgent));
  if (!matchedPlatform) {
    return 'UNKNOWN';
  }
  return matchedPlatform.name;
}

const userAgent = getUserAgent();

export const platform = _getPlatform(userAgent);
export const isIOS = platform === 'ios' || platform === 'iOS';
export const isAndroid = platform === 'android' || platform === 'Android';

const ua = navigator.userAgent;
const iOS = /iPad|iPhone|iPod/.test(ua);

function uaIncludes(str: string) {
  return ua.indexOf(str) !== -1;
}

function testScrollType() {
  if (iOS) {
    if (uaIncludes('Safari/') || /OS 11_[0-3]\D/.test(ua)) {
      /**
       * 不处理
       * - Safari
       * - iOS 11.0-11.3（`scrollTop`/`scrolIntoView` 有 bug）
       */
      return 0;
    }
    // 用 `scrollTop` 的方式
    return 1;
  }
  // 其它的用 `scrollIntoView` 的方式
  return 2;
}

/** 阿里旺旺 兼容input框被遮挡 */
export function riseInput(input: HTMLElement, target: HTMLElement) {
  const scrollType = testScrollType();
  let scrollTimer: ReturnType<typeof setTimeout>;

  if (!target) {
    // eslint-disable-next-line no-param-reassign
    target = input;
  }

  const scrollIntoView = () => {
    if (scrollType === 0) return;
    if (scrollType === 1) {
      document.body.scrollTop = document.body.scrollHeight;
    } else {
      target.scrollIntoView(false);
    }
  };

  input.addEventListener('focus', () => {
    setTimeout(scrollIntoView, 300);
    scrollTimer = setTimeout(scrollIntoView, 1000);
  });

  input.addEventListener('blur', () => {
    clearTimeout(scrollTimer);

    // 某些情况下收起键盘后输入框不收回，页面下面空白
    // 比如：闲鱼、大麦、乐动力、微信
    if (scrollType && iOS) {
      // 以免点击快捷短语无效
      setTimeout(() => {
        document.body.scrollIntoView();
      });
    }
  });
}
