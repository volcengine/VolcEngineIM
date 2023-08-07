import React, { useImperativeHandle } from 'react';
import { BetterScrollInstanceRef, IScrollViewRef } from '../interface';

export const useScrollViewRef = (
  ref:
    | ((instance: IScrollViewRef | null) => void)
    | React.MutableRefObject<IScrollViewRef | null>
    | null,
  instance: BetterScrollInstanceRef,
) => {
  useImperativeHandle(
    ref,
    () => {
      return {
        instance: instance.current,
        isInBottomCurrent() {
          if (!instance.current) return false;
          return (
            Math.abs(instance.current.maxScrollY - instance.current.y) <= 2
          );
        },
        scrollToBottom() {
          instance.current?.scrollTo(0, instance.current.maxScrollY, 100);
        },
      };
    },
    [],
  );
};
