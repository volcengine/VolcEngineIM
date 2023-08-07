import React, { useCallback, useRef } from 'react';

type InnerRef<T> = ((instance: T | null) => void) | React.RefObject<T> | null | undefined;

const useComposeRef = <T extends any>(innerRef: React.MutableRefObject<T | null>, outterRef: InnerRef<T>) => {
  return useCallback(
    (instance: T | null) => {
      innerRef.current = instance;

      if (!outterRef) {
        return;
      }

      updateRef(outterRef, instance);
    },
    [outterRef]
  );
};

function updateRef<T>(ref: InnerRef<T>, value: T | null) {
  if (typeof ref === 'function') {
    ref(value);
    return;
  }

  (ref as any).current = value;
}

export default useComposeRef;
