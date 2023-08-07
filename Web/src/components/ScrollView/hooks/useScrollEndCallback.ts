import React, { useCallback, useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

export const useScrollEndCallback = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { onScrollEnd } = props;
  const handleScrollEnd = useCallback(() => {
    if (onScrollEnd) {
      onScrollEnd(instance.current);
    }
  }, [onScrollEnd, instance]);

  useEffect(() => {
    if (!onScrollEnd)
      return () => {
        /** empty */
      };
    instance.current?.on('scrollEnd', handleScrollEnd);
    return () => {
      instance.current?.off('scrollEnd', handleScrollEnd);
    };
  }, [handleScrollEnd, instance, onScrollEnd]);

  return {
    handleScrollEnd,
  };
};
