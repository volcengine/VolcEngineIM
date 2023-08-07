import React, { useRef, forwardRef, useImperativeHandle } from 'react';
import classNames from 'classnames';

import { useComposeRef } from '../../hooks';

const prefixCls = 'im-textarea';

export type ChangeOptions = {
  rowHeight: number;
};

export interface TexareaAutoSizeProps
  extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  maxRows?: number;
  minRows?: number;
  onHeightChange?: (height: number, options: ChangeOptions) => void;
}

export const noop = () => {};

const TexareaAutoSize: React.ForwardRefRenderFunction<
  HTMLTextAreaElement,
  TexareaAutoSizeProps
> = (props, ref) => {
  const {
    className,
    style,
    minRows = 1,
    maxRows = Infinity,
    onHeightChange = noop,
    onInput = noop,
    ...restProps
  } = props;

  const eleRef = useRef<HTMLTextAreaElement | null>(null);
  const hiddenRef = useRef<HTMLTextAreaElement | null>(null);
  const heightRef = useRef(0);
  const isControl = props.value !== undefined;
  const textareaClass = classNames(prefixCls, className);
  const hiddenTextareaClass = classNames(prefixCls, 'is-hidden', className);

  const mergeRef = useComposeRef(ref as any, eleRef);

  const _resizeTextarea = () => {
    const node = eleRef.current!;
    const hiddenNode = hiddenRef.current!;

    hiddenNode.value = node.value;
    // cache height
    let height = hiddenNode.scrollHeight;

    hiddenNode.value = 'x';
    // single height
    const rowHeight = hiddenNode.scrollHeight;

    let minHeight = rowHeight * minRows;
    height = Math.max(minHeight, height);

    let maxHeight = rowHeight * maxRows;
    height = Math.min(maxHeight, height);

    if (heightRef.current !== height) {
      heightRef.current = height;
      node.style.setProperty('height', `${height}px`, 'important');
      onHeightChange(height, { rowHeight });
    }
  };

  const _handleInput = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
    if (!isControl) {
      _resizeTextarea();
    }
    onInput?.(event);
  };

  const _handleFocus = () => {
    if (!eleRef.current) {
      return;
    }

    eleRef.current.focus();
  };

  useImperativeHandle(
    ref as any,
    () => ({
      focus: _handleFocus,
      resizeTextarea: _resizeTextarea,
    }),
    [_handleFocus, _resizeTextarea],
  );

  // 字体设置和宽度等文字属性需要一致
  return (
    <>
      <textarea
        className={textareaClass}
        ref={mergeRef}
        onInput={_handleInput}
        {...restProps}
      />
      <textarea
        ref={hiddenRef}
        className={hiddenTextareaClass}
        style={{ height: 1, visibility: 'hidden' }}
      />
    </>
  );
};

export default forwardRef(TexareaAutoSize);
