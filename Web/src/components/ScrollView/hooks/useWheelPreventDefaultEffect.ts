import React, { useCallback, useEffect } from 'react';
import { IScrollViewProps } from '../interface';

/* eslint-disable no-empty */
export const inBrowser = typeof window !== 'undefined';
/* istanbul ignore next */
export let supportsPassive = false;
/* istanbul ignore next */
if (inBrowser) {
  const EventName = 'test-passive' as any;
  try {
    const opts = {};
    Object.defineProperty(opts, 'passive', {
      // eslint-disable-next-line getter-return
      get() {
        supportsPassive = true;
      },
    }); // https://github.com/facebook/flow/issues/285
    window.addEventListener(EventName, () => {}, opts);
  } catch (e) {}
}

export const useWheelPreventDefaultCallback = (
  props: IScrollViewProps,
  ref: React.RefObject<HTMLDivElement>,
) => {
  const { onScroll } = props;
  const handleWheel = useCallback(
    (e: any) => {
      e.preventDefault();
    },
    [ref],
  );

  useEffect(() => {
    const capture = true;
    const useCapture = supportsPassive
      ? {
          passive: false,
          capture,
        }
      : capture;
    ref.current?.addEventListener('wheel', handleWheel, useCapture);
    ref.current?.addEventListener('mousewheel', handleWheel, useCapture);
    ref.current?.addEventListener('DOMMouseScroll', handleWheel, useCapture);

    return () => {
      ref.current?.removeEventListener('wheel', handleWheel, useCapture);
      ref.current?.removeEventListener('mousewheel', handleWheel, useCapture);
      ref.current?.removeEventListener(
        'DOMMouseScroll',
        handleWheel,
        useCapture,
      );
    };
  }, [handleWheel, ref, onScroll]);

  return {
    handleWheel,
  };
};
