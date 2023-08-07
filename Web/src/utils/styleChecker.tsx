export const isStyleSupport = (styleName: string | Array<string>): boolean => {
  const styleNameList = Array.isArray(styleName) ? styleName : [styleName];
  const { documentElement } = window.document;

  return styleNameList.some(name => name in documentElement.style);
};
