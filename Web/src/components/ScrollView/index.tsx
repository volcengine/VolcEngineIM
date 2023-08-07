/* eslint-disable no-redeclare */
import React, { forwardRef, useRef } from 'react';
import cls from 'classnames';

import { upperFirst } from 'lodash';
import { IScrollViewProps, IScrollViewRef } from './interface';
import {
  useBSInstance,
  useScroll,
  useScrollEndCallback,
  useScrollIntoViewEffect,
  useScrollLeftEffect,
  useScrollToLowerCallback,
  useScrollTopEffect,
  useScrollToUpperCallback,
  useScrollViewRef,
  useScrollViewResizeEffect,
  useWheelPreventDefaultCallback,
  useOnContentSizeChangedEffect,
} from './hooks';

import ScrollBox from './Styles';

const compType = 'scrollView';

/**
 * 生成一个组件下功能块的 class
 */
function composeClass(prefix: string, comp: string): string;
function composeClass(prefix: string, comp: string[]): string;
function composeClass(prefix: string): undefined;
function composeClass(prefix: string, comp?: string | string[]) {
  return (
    comp && `${prefix}-${typeof comp === 'string' ? comp : comp?.join('-')}`
  );
}

const createDisplayName = (comp: string) => {
  return `${upperFirst(comp)}`;
};

/**
 * 一把梭，监听的事情有点多，性能可优化，可选监听
 */
const ScrollView = forwardRef<IScrollViewRef, IScrollViewProps>(
  (props, ref) => {
    const { className, children, style, contentClassName, onClick } = props;
    const scrollWrapperRef = useRef<HTMLDivElement>(null);

    const { instance } = useBSInstance(props, scrollWrapperRef);

    useScrollViewRef(ref, instance);
    useScrollViewResizeEffect(props, instance);
    useScroll(props, instance);
    useScrollEndCallback(props, instance);
    useScrollIntoViewEffect(props, instance);
    useScrollLeftEffect(props, instance);
    useScrollToUpperCallback(props, instance);
    useScrollToLowerCallback(props, instance);
    useScrollTopEffect(props, instance);
    useOnContentSizeChangedEffect(props, instance);
    useWheelPreventDefaultCallback(props, scrollWrapperRef);

    const compCls = composeClass('chat', compType);

    return (
      <ScrollBox
        className={cls(compCls, className)}
        ref={scrollWrapperRef}
        style={style!}
        onClick={onClick!}>
        <div
          className={cls(composeClass(compCls, 'content'), contentClassName)}>
          {children}
        </div>
      </ScrollBox>
    );
  },
);

ScrollView.displayName = createDisplayName(compType);
ScrollView.defaultProps = {
  upperThreshold: 50,
  lowerThreshold: 50,
  mouseWheel: true,
  preventDefault: false,
  click: false,
};

export default ScrollView;
