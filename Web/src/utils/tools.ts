export function isFunction(v: any) {
  return v && typeof v === 'function';
}

const opt = Object.prototype.toString;

export function isArray(obj: any): obj is any[] {
  return opt.call(obj) === '[object Array]';
}

export function isObject(obj: any): obj is { [key: string]: any } {
  return opt.call(obj) === '[object Object]';
}

export const inBrowser = typeof window !== 'undefined';

export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

// delete keys from object
export function omit<T extends object, K extends keyof T>(
  obj: T,
  keys: Array<K | string> // string为了某些没有声明的属性被omit
): Omit<T, K> {
  const clone = {
    ...obj,
  };

  keys.forEach((key: any) => {
    if (key in clone) {
      delete clone[key as K];
    }
  });
  return clone;
}

export function debounce(func: Function, wait: number, immediate?: boolean) {
  let timeout, result;

  let debounced = function (this: any, ...arg: any[]) {
    let context = this;
    let args = arguments;

    if (timeout) clearTimeout(timeout);
    if (immediate) {
      // 如果已经执行过，不再执行
      let callNow = !timeout;
      timeout = setTimeout(function () {
        timeout = null;
      }, wait);
      if (callNow) result = func.apply(context, args);
    } else {
      timeout = setTimeout(function () {
        func.apply(context, args);
      }, wait);
    }
    return result;
  };

  (debounced as any).cancel = function () {
    clearTimeout(timeout);
    timeout = null;
  };

  return debounced;
}

export function throttle(func: Function, delay: number) {
  var timer = null;
  var startTime = Date.now();
  return function () {
    var curTime = Date.now();
    var remaining = delay - (curTime - startTime);
    // @ts-ignore
    var context = this;
    var args = arguments;
    clearTimeout(timer);
    if (remaining <= 0) {
      func.apply(context, args);
      startTime = Date.now();
    } else {
      timer = setTimeout(func, remaining);
    }
  };
}

export function isString(v: any) {
  return v && typeof v === 'string';
}

export function isNumber(v: any) {
  return v && typeof v === 'number';
}
