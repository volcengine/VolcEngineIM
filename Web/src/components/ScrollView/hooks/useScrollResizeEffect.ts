import React, { useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

export const useScrollViewResizeEffect = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  useEffect(() => {
    const cb = () => {
      instance.current?.refresh();
    };

    window.addEventListener('resize', cb);
    return () => {
      window.removeEventListener('resize', cb);
    };
  }, [instance]);
};
