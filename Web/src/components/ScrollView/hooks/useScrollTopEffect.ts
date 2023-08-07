import React, { useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

const isNil = (val: any): val is undefined | null =>
  val === undefined || val === null;

/**
 * 可能有坑
 */
export const useScrollTopEffect = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { scrollTop } = props;
  useEffect(() => {
    if (!isNil(scrollTop)) {
      instance.current?.scrollTo(0, -scrollTop, 300);
    }
  }, [scrollTop, instance]);
};
