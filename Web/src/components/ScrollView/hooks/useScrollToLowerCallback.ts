import React, { useCallback, useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

export const useScrollToLowerCallback = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { onScrollToLower } = props;
  const handleScrollToLower = useCallback(() => {
    if (onScrollToLower) {
      onScrollToLower(instance.current);
    } else {
      instance.current?.finishPullUp();
    }
  }, [onScrollToLower, instance]);

  useEffect(() => {
    if (!onScrollToLower)
      return () => {
        /** empty */
      };
    instance.current?.on('pullingUp', handleScrollToLower);
    return () => {
      instance.current?.off('pullingUp', handleScrollToLower);
    };
  }, [handleScrollToLower, instance, onScrollToLower]);

  return {
    handleScrollToLower,
  };
};
