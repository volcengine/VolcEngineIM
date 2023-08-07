import React, { useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

const isNil = (val: any): val is undefined | null =>
  val === undefined || val === null;

/**
 * 可能有坑
 */
export const useScrollLeftEffect = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { scrollLeft } = props;
  useEffect(() => {
    if (!isNil(scrollLeft)) {
      instance.current?.scrollTo(scrollLeft, 0, 300);
    }
  }, [scrollLeft, instance]);
};
