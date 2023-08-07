import React, { useCallback, useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

export const useScrollToUpperCallback = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { onScrollToUpper } = props;
  const handleScrollToUpper = useCallback(() => {
    if (onScrollToUpper) {
      onScrollToUpper(instance.current);
    } else {
      instance.current?.finishPullDown();
    }
  }, [onScrollToUpper, instance]);

  useEffect(() => {
    if (!onScrollToUpper)
      return () => {
        /** empty */
      };
    instance.current?.on('pullingDown', handleScrollToUpper);
    return () => {
      instance.current?.off('pullingDown', handleScrollToUpper);
    };
  }, [handleScrollToUpper, instance, onScrollToUpper]);

  return {
    handleScrollToUpper,
  };
};
