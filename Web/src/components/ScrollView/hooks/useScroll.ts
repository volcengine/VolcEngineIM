import React, { useCallback, useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

export const useScroll = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { onScroll } = props;
  const handleScroll = useCallback(
    (position: { x: number; y: number }) => {
      if (onScroll) {
        onScroll(position, instance.current);
      }
    },
    [onScroll, instance],
  );

  useEffect(() => {
    if (!onScroll)
      return () => {
        /** empty */
      };
    instance.current?.on('scroll', handleScroll);
    return () => {
      instance.current?.off('scroll', handleScroll);
    };
  }, [handleScroll, instance, onScroll]);

  return {
    handleScroll,
  };
};
