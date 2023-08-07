const Agents = ['iphone', 'ipad', 'ipod', 'android', 'linux', 'windows phone'];

export function _isMobile() {
  const userAgentInfo = navigator.userAgent.toLowerCase();

  for (let i = 0, len = Agents.length; i < len; i++) {
    if (userAgentInfo.indexOf(Agents[i]) !== -1) {
      return true;
    }
  }
  return false;
}

export const isMobile = _isMobile();

/** 传递第二个参数可以筛选特定的参数 */
export const getURLParams = <T extends string>(search?: string, outputParams?: T[]) => {
  const params = new URLSearchParams(search || window.location.search);
  const res: { [props: string]: string } = {};

  if (!Array.isArray(outputParams)) {
    params.forEach((val, key) => {
      res[key] = val;
    });
  } else {
    outputParams.forEach(key => {
      res[key] = params.get(key);
    });
  }

  return res;
};

export const isNumeric = n => !isNaN(n);

export * from './storage';
export * from './message';
export * from './formatTime';
export * from './tools';
export * from './download';
export * from './dom';
export { default as CalcVideo } from './calcVideo';
