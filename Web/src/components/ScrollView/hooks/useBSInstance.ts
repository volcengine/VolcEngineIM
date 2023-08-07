import { IScrollViewProps } from '../interface';
import { useBetterScroll } from './useBetterScroll';

import mouseWheelPlugin from '@better-scroll/mouse-wheel';
import observeImagePlugin from '@better-scroll/observe-image';
import observerDOMPlugin from '@better-scroll/observe-dom';
import scrollBarPlugin from '@better-scroll/scroll-bar';
import InfinityScroll from '@better-scroll/infinity';

import React, { useMemo } from 'react';
import { Options } from '@better-scroll/core';

const plugins = [
  mouseWheelPlugin,
  observeImagePlugin,
  observerDOMPlugin,
  scrollBarPlugin,
  InfinityScroll,
];

export const useBSInstance = (
  props: IScrollViewProps,
  ref: React.RefObject<HTMLDivElement>,
) => {
  const {
    upperThreshold = 90,
    upperStop = 0,
    lowerThreshold = 50,
    mouseWheel,
    scrollX,
    scrollY,
    scrollbar,
    bounce = true,
    bounceTime = 800,
    momentum = true,
    momentumLimitDistance = 15,
    momentumLimitTime = 300,
    onScrollToLower,
    onScrollToUpper,
    click = false,
    preventDefault,
    infinity,
  } = props;
  const options: Options = useMemo(() => {
    const ret: Options = {};

    if (onScrollToLower) {
      Object.assign<Options, Options>(ret, {
        pullUpLoad: {
          threshold: lowerThreshold,
        },
      });
    }

    if (onScrollToUpper) {
      Object.assign<Options, Options>(ret, {
        pullDownRefresh: {
          threshold: upperThreshold,
          stop: upperStop,
        },
      });
    }

    if (mouseWheel) {
      const config = mouseWheel === true ? {} : mouseWheel;
      Object.assign<Options, Options>(ret, {
        mouseWheel: {
          ...config,
        },
      });
    }

    Object.assign<Options, Options>(ret, {
      click,
      observeDOM: true,
      observeImage: true,
      scrollX,
      scrollY,
      scrollbar,
      bounce,
      bounceTime,
      easeTime: 100,
      momentum,
      momentumLimitDistance,
      momentumLimitTime,
      preventDefault,
      infinity,
      probeType: 3,
    });

    return ret;
  }, []);

  const { instance } = useBetterScroll(ref, options, plugins);
  return {
    instance,
  };
};
