interface DebounceOption {
  wait: number;
  immediate: boolean;
}

export const debounce = (fn, option?: DebounceOption) => {
  let timer;
  const wait = option?.wait || 500;
  const immediate = option?.immediate || false;

  return (...args) => {
    if (timer) {
      clearTimeout(timer);
    }
    if (immediate && timer === undefined) {
      fn(...args);
    }
    timer = setTimeout(() => {
      fn(...args);
      timer = undefined;
    }, wait);
  };
};
