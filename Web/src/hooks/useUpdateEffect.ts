import { DependencyList, useCallback, useEffect, useRef } from 'react';

const useUpdateEffect = (effect: Function, deps: any[]) => {
  const isMountRef = useRef(false);

  useEffect(() => {
    if (!isMountRef.current) {
      isMountRef.current = true;
    } else {
      effect?.();
    }
  }, deps);
};

export default useUpdateEffect;
