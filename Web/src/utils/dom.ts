import { MutableRefObject } from 'react';

export function stopPropagation(event: Event) {
  event.stopPropagation();
}

export function preventDefault(event: Event, isStopPropagation?: boolean) {
  if (typeof event.cancelable !== 'boolean' || event.cancelable) {
    event.preventDefault();
  }

  if (isStopPropagation) {
    stopPropagation(event);
  }
}

export type BasicTarget<T = HTMLElement> = (() => T | null) | T | null | MutableRefObject<T | null | undefined>;

type TargetElement = HTMLElement | Element | Document | Window;

export function getTargetElement(
  target?: BasicTarget<TargetElement>,
  defaultElement?: TargetElement
): TargetElement | undefined | null {
  if (!target) {
    return defaultElement;
  }

  let targetElement: TargetElement | undefined | null;

  if (typeof target === 'function') {
    targetElement = target();
  } else if ('current' in target) {
    targetElement = target.current;
  } else {
    targetElement = target;
  }

  return targetElement;
}

export function getImageSize(url: string): Promise<{ width: number; height: number; url: string }> {
  return new Promise((resolve, reject) => {
    const img = new window.Image();
    img.onload = () =>
      resolve({
        width: img.naturalWidth,
        height: img.naturalHeight,
        url,
      });
    img.onerror = () => reject();
    img.src = url;
  });
}

export function getScrollBottom(element?: HTMLElement | Element) {
  let scrollBottom = 0;

  if (!element) {
    return scrollBottom;
  }

  scrollBottom = element.scrollHeight - element.clientHeight - element.scrollTop;

  return scrollBottom;
}

export function scrollTo(el?: HTMLElement | Element, type?: 'top' | 'bottom') {
  if (!el) {
    return;
  }

  if (type === 'bottom') {
    el?.scrollTo({
      top: el.scrollHeight - el.clientHeight,
    });
  } else {
    el?.scrollTo({
      top: 0,
    });
  }
}

export function checkReadHistoryMessage(el?: HTMLElement | Element | number, distance = 50) {
  if (!el) {
    return false;
  }

  if (typeof el === 'number') {
    return el > distance;
  }

  return el.scrollHeight - el.clientHeight - el.scrollTop > distance;
}

export const on = (function () {
  return function (
    element: any,
    event: string,
    // eslint-disable-next-line no-undef
    handler: EventListener | EventListenerObject | Function,
    capture?: boolean
  ) {
    element && element.addEventListener(event, handler, capture || false);
  };
})();

export const off = (function () {
  return function (
    element: any,
    event: string,
    // eslint-disable-next-line no-undef
    handler: EventListener | EventListenerObject | Function,
    capture?: boolean
  ) {
    element && element.removeEventListener(event, handler, capture || false);
  };
})();

export function getFixTranslate(
  wrapperRect: DOMRect,
  imgRect: DOMRect,
  translateX: number,
  translateY: number,
  scale: number
): [number, number] {
  let fixTranslateX = translateX;
  let fixTranslateY = translateY;
  if (translateX) {
    /** img 的宽度小于 wrapper 的宽度，则不应该有位移 */
    if (wrapperRect.width > imgRect.width) {
      fixTranslateX = 0;
    } else {
      /** img 的宽度大于 wrapper 的宽度 */
      if (imgRect.left > wrapperRect.left) {
        // 左边框跑到 wrapper 范围内，则往左退到 wrapper 左侧：减少位移量
        fixTranslateX -= Math.abs(wrapperRect.left - imgRect.left) / scale;
      }
      if (imgRect.right < wrapperRect.right) {
        // 右边框跑到 wrapper 范围内，则往右退到 wrapper 右侧：增加位移量
        fixTranslateX += Math.abs(wrapperRect.right - imgRect.right) / scale;
      }
    }
  }
  if (translateY) {
    /** img 的高度度小于 wrapper 的高度度，则不应该有位移 */
    if (wrapperRect.height > imgRect.height) {
      fixTranslateY = 0;
    } else {
      /** img 的高度大于 wrapper 的高度 */
      if (imgRect.top > wrapperRect.top) {
        // 上边框跑到 wrapper 范围内，则往上退到 wrapper 上侧：减少位移量
        fixTranslateY -= Math.abs(wrapperRect.top - imgRect.top) / scale;
      }
      if (imgRect.bottom < wrapperRect.bottom) {
        // 下边框跑到 wrapper 范围内，则往下退到 wrapper 下侧：增加位移量
        fixTranslateY += Math.abs(wrapperRect.bottom - imgRect.bottom) / scale;
      }
    }
  }
  return [fixTranslateX, fixTranslateY];
}
