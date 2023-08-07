import { MutableRefObject, useRef, useEffect, useCallback } from 'react';

// 鼠标点击事件，click 不会监听右键
const defaultEvent = 'click';

type RefType = HTMLElement | (() => HTMLElement | null) | null | undefined;

export default function useClickOutside<T extends HTMLElement = any>(
  dom: RefType = undefined,
  onClickAway: (event: KeyboardEvent) => void,
  eventName: string = defaultEvent,
): MutableRefObject<T> {
  const element = useRef<T>();

  const handler = useCallback(
    event => {
      const targetElement = typeof dom === 'function' ? dom() : dom;
      const el = targetElement || element.current;
      // https://developer.mozilla.org/en-US/docs/Web/API/Event/composedPath
      // 1. 包裹元素包含点击元素
      // 2. 点击元素曾在包裹元素内
      if (
        !el ||
        el.contains(event.target) ||
        (event.composedPath && event.composedPath().includes(el))
      ) {
        return;
      }

      onClickAway(event);
    },
    [element.current, onClickAway, dom],
  );

  useEffect(() => {
    document.addEventListener(eventName, handler);

    return () => {
      document.removeEventListener(eventName, handler);
    };
  }, [eventName, handler]);

  return element as MutableRefObject<T>;
}
