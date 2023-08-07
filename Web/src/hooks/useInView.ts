import React, { useState, useEffect, useCallback, useRef } from 'react';
import 'intersection-observer';

interface IOptions {
  disabled?: boolean;
}

const useInView = <T extends HTMLElement = any>(
  el?: T | (() => T),
  // eslint-disable-next-line no-undef
  options?: IntersectionObserverInit & IOptions,
  deps: any[] = [],
): [React.MutableRefObject<T>, boolean] => {
  const { disabled, ...intersectionOptions } = options;

  const ref = useRef<T>();
  const [inView, setInView] = useState(false);

  const callback = useCallback((entries: IntersectionObserverEntry[]) => {
    setInView(entries[0].isIntersecting);
  }, []);

  useEffect(() => {
    if (disabled) {
      return;
    }

    let target = ref.current;

    if (el) {
      target = typeof el === 'function' ? el() : el;
    }
    const ios = new IntersectionObserver(callback, intersectionOptions);
    if (target) {
      ios.observe(target);
    }
    return () => ios.disconnect();
  }, [
    ref.current,
    typeof el === 'function' ? undefined : el,
    options,
    ...deps,
  ]);

  return [ref as React.MutableRefObject<T>, inView];
};

export default useInView;
