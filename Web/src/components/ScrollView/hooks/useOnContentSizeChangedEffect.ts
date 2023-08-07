import React, { useCallback, useEffect } from 'react';
import { BetterScrollInstanceRef, IScrollViewProps } from '../interface';

export const useOnContentSizeChangedEffect = (
  props: IScrollViewProps,
  instance: BetterScrollInstanceRef,
) => {
  const { onContentSizeChanged } = props;
  const handleContentSizeChanged = useCallback(
    (newContent: HTMLElement) => {
      if (onContentSizeChanged) {
        onContentSizeChanged(newContent);
      }
    },
    [onContentSizeChanged, instance],
  );

  useEffect(() => {
    if (!onContentSizeChanged)
      return () => {
        /** empty */
      };
    instance.current?.on('contentChanged', handleContentSizeChanged);
    return () => {
      instance.current?.off('contentChanged', handleContentSizeChanged);
    };
  }, [handleContentSizeChanged, instance, onContentSizeChanged]);

  return {
    handleContentSizeChanged,
  };
};
