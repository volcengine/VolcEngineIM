/**
 * https://better-scroll.github.io/docs/zh-CN/guide/base-scroll-options.html
 */

import BScroll, { Options } from '@better-scroll/core';

import { RefObject, useEffect, useLayoutEffect, useRef } from 'react';

export const delay = (cb: (...arg: any[]) => void, timeout = 1000) => {
  const timer = setTimeout(() => {
    cb();
  }, timeout);

  return () => {
    clearTimeout(timer);
  };
};

export const frame =
  window.requestAnimationFrame ||
  function(callback) {
    return window.setTimeout(callback, 1000 / 60);
  };
export const cancelAnimationFrame =
  window.cancelAnimationFrame || window.clearTimeout;

export const runAnimationFrameLoop = (
  cb: (...arg: any) => void,
  test = () => true,
  duration: number = 1000 / 60,
) => {
  let start: number;
  let timer: number;
  const step = (timestamp?: number) => {
    if (!timestamp) {
      timer = frame(step);
      return;
    }
    if (start === undefined) start = timestamp;
    const elapsed = timestamp - start;
    if (elapsed >= duration) {
      start = timestamp;

      if (test()) {
        cb();
      }
    }

    timer = frame(step);
  };

  step();

  const play = () => {
    dispose();
    step();
  };

  const dispose = () => {
    disposeDelay();
    cancelAnimationFrame(timer);
  };

  let disposeDelay = () => {
    // empty
  };
  let dirty = false; // 保证 dispose 多次调用只执行最开始的调用，回调执行完之后重置
  const disposeAfter = (timeout = 1000) => {
    if (dirty) return;
    dirty = true;
    disposeDelay = delay(() => {
      dirty = false;
      cancelAnimationFrame(timer);
    }, timeout);
  };
  return {
    dispose,
    disposeAfter,
    play,
  };
};

export const useBetterScroll = (
  ref: RefObject<HTMLElement>,
  options: Options,
  plugins: any[] = [],
) => {
  const instance = useRef<BScroll>();

  useLayoutEffect(() => {
    if (ref.current) {
      plugins.forEach(p => BScroll.use(p));
      const bs = new BScroll(ref.current, options);
      instance.current = bs;
    }

    return () => {
      if (instance.current) {
        instance.current.destroy();
      }
    };
  }, []);

  // useEffect(() => {
  //   const disposal = runAnimationFrameLoop(() => {
  //     if (instance.current) {
  //       // instance.current.refresh()
  //     }
  //   })

  //   return () => {
  //     disposal.dispose()
  //   }
  // })

  return {
    instance,
  };
};
