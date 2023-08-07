import BScroll, { Options } from '@better-scroll/core';
import { BScrollConstructor } from '@better-scroll/core/dist/types/BScroll';
import { MouseWheelOptions } from '@better-scroll/mouse-wheel';
import { InfinityOptions } from '@better-scroll/infinity';

export type BsInstance = BScroll;

import React, { CSSProperties, PropsWithChildren } from 'react';

type IBaseProps = PropsWithChildren<{
  className?: string;
  /**
   * click
   */
  onClick?: (e?: any) => void;
  style?: CSSProperties;
}>;

export interface IScrollViewProps
  extends IBaseProps,
    Pick<Options, 'bounce' | 'bounceTime' | 'momentum' | 'momentumLimitTime' | 'momentumLimitDistance' | 'click'> {
  /**
   * 是否允许横向滚动
   */
  scrollX?: boolean;
  /**
   * 是否允许竖向滚动
   */
  scrollY?: boolean;
  /**
   * 暂时不实现
   * 在设置滚动条位置时是否使用动画过渡
   */
  scrollWithAnimation?: boolean;
  /**
   * 距顶部/左边多远时（单位 px），触发 scrolltoupper 事件。
   * 在 pc 上滚轮触发的话建议 设置为0， 否则滚轮触发不了
   * 因为滚轮触发的检测上拉下拉的回调里，拿到的 y 值 = 0，如果 upperThreshold > 0,就不会触发上拉
   * lowerThreshold 一样
   */
  upperThreshold?: number;
  /**
   * 顶部悬停距离
   */
  upperStop?: number;
  /**
   * 距底部/右边多远时（单位 px），触发 scrolltolower 事件。
   */
  lowerThreshold?: number;
  /**
   * 设置竖向滚动条位置
   */
  scrollTop?: number;
  /**
   * 设置横向滚动条位置
   */
  scrollLeft?: number;
  /**
   * 值应为某子元素id（不能以数字开头）。设置哪个方向可滚动，则在哪个方向滚动到该元素。
   */
  scrollIntoView?: string;
  /**
   * 滚动事件
   */
  onScroll?: (position: { x: number; y: number }, bsInstance?: BScroll) => void;
  /**
   * 滚动到顶部/左边时触发, 配置之后自动启用 下拉加载插件
   */
  onScrollToUpper?: (bsInstance?: BScroll) => void;
  /**
   * 滚动到底部/右边时触发，配置之后自动启用 上拉加载插件
   */
  onScrollToLower?: (bsInstance?: BScroll) => void;
  /**
   * 滚动停止时触发
   */
  onScrollEnd?: (bsInstance?: BScroll) => void;
  /**
   * 内容尺寸变更时触发
   */
  onContentSizeChanged?: (newContent: HTMLElement) => void;
  /**
   * 主内容容器样式
   */
  contentClassName?: string;
  /**
   * 鼠标滚轮配置
   */
  mouseWheel?: MouseWheelOptions | boolean;
  /**
   * 是否显示滚动窕
   */
  scrollbar?: true;

  /**
   * 当事件派发后是否阻止浏览器默认行为。这个值应该设为 true，除非你真的知道你在做什么，通常你可能用到的是 preventDefaultException。
   */
  preventDefault?: boolean;

  /**
   * BetterScroll 会阻止原生的滚动，这样也同时阻止了一些原生组件的默认行为。
   * 这个时候我们不能对这些元素做 preventDefault，所以我们可以配置 preventDefaultException。
   * 默认值 {tagName: /^(INPUT|TEXTAREA|BUTTON|SELECT|AUDIO)$/}表示标签名为 input、textarea、button、select、audio 这些元素的默认行为都不会被阻止。
   */
  preventDefaultException?: Options['preventDefaultException'];

  infinity?: InfinityOptions;
}

export interface IScrollViewRef {
  instance?: BScroll;
  isInBottomCurrent(): boolean;
  scrollToBottom(): void;
}

export type BetterScrollInstanceRef = React.MutableRefObject<BScrollConstructor<Options> | undefined>;
