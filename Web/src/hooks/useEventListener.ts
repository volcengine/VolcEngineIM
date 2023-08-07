import { useEffect, useRef, useLayoutEffect, MutableRefObject } from 'react';

type Target = Window | HTMLElement | undefined | null;

export interface Options {
  target?: Target | (() => Target);
  capture?: boolean;
  once?: boolean;
  passive?: boolean;
}

function useAddEventListener(
  target: Target | (() => Target),
  type: string,
  listener: Function,
  options?: Options,
): void {
  const listenerRef = useRef(listener);

  useEffect(() => {
    listenerRef.current = listener;
  }, [listener]);

  useLayoutEffect(() => {
    const targetEl = typeof target === 'function' ? target() : target;
    if (!targetEl) return;
    const eventListener = (e: Event) => listenerRef.current(e);
    targetEl.addEventListener(type, eventListener, {
      capture: options?.capture,
      once: options?.once,
      passive: options?.passive,
    });
    return () => {
      targetEl.removeEventListener(type, eventListener, {
        capture: options?.capture,
      });
    };
  }, [target, type, options]);
}

export default function useEventListener<T extends HTMLElement = any>(
  eventName: string,
  eventListener: Function,
  options?: Options,
) {
  const ref = useRef<T>();
  const eventTarget = options?.target || (() => ref.current || window);
  useAddEventListener(eventTarget, eventName, eventListener, options);
  return ref as MutableRefObject<T>;
}
