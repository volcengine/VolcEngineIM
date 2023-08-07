import React, { useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

/**
 * 可能有坑。
 */
export const useScrollIntoViewEffect = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { scrollIntoView } = props;
  useEffect(() => {
    if (scrollIntoView) {
      instance.current?.scrollToElement(scrollIntoView, 300, true, true);
    }
  }, [scrollIntoView, instance]);
};
