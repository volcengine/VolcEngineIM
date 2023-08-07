import React, {
  useEffect,
  ReactNode,
  CSSProperties,
  forwardRef,
  memo,
  useMemo,
  useRef,
  useState,
  useCallback,
} from 'react';
import classNames from 'classnames';

import { useComposeRef } from '../../hooks';
import { isString, isNumber, isFunction } from '../../utils/tools';
import Text from '../Text';
import { IconDown } from '../Icon';

import BubbleBox from './Styles';

// 需要拓展 富文本
interface BubbleProps {
  role?: 'self' | 'other';
  align?: 'left' | 'center' | 'right';
  maxHeight?: number; // isEllipsis = true 时生效
  isEllipsis?: boolean;
  className?: string;
  style?: CSSProperties;
  children?: ReactNode;
  renderFoldElement?: () => ReactNode;
}

const prefixCls = 'im-bubble';

function Bubble(props: BubbleProps, ref) {
  const {
    className,
    role = 'self',
    align = 'left',
    maxHeight = 300,
    isEllipsis = true,
    children,
    style = {},
    renderFoldElement,
    ...other
  } = props;

  const bubbleRef = useRef<HTMLTextAreaElement>();
  const composedRef = useComposeRef(bubbleRef, ref);

  const [isFolded, setFolded] = useState(false);

  const wrapClass = useMemo(() => {
    return classNames(
      {
        [`${prefixCls}`]: true,
        [`${prefixCls}-${role}`]: Boolean(role),
        [`${prefixCls}-${align}`]: Boolean(align),
      },
      className
    );
  }, [className, role, align]);

  // 是否显示 查看更多
  useEffect(() => {
    const bubbleEle = bubbleRef.current as HTMLTextAreaElement;
    if (!isEllipsis || !bubbleEle) {
      return;
    }

    const computedStyle = getComputedStyle(bubbleEle);
    if (parseFloat(computedStyle.height) >= maxHeight) {
      setFolded(true);
    } else {
      setFolded(false);
    }
  }, [bubbleRef.current, isEllipsis, maxHeight, setFolded]);

  const handleMoreClick = useCallback(() => {
    setFolded(false);
  }, [setFolded]);

  const composedStyle = useMemo(() => {
    if (isEllipsis && isFolded) {
      return {
        ...style,
        maxHeight: `${maxHeight}px`,
        overflow: 'hidden',
      };
    }
    return style;
  }, [style, isEllipsis, maxHeight, isFolded]);

  const childrenNode = useMemo(() => {
    if (isString(children) || isNumber(children)) {
      return <Text>{children}</Text>;
    }
    return children;
  }, [children]);

  const foldActionElement = useMemo(() => {
    if (!isFolded) return <></>;

    if (isFunction(renderFoldElement)) {
      return renderFoldElement();
    }

    return (
      <div className={`${prefixCls}-foldBox`}>
        <div className={`${prefixCls}-mask`} />
        <div className={`${prefixCls}-actionBox`} onClick={handleMoreClick}>
          <span className={`${prefixCls}-action-btn`}>
            查看更多 <IconDown />
          </span>
        </div>
      </div>
    );
  }, [renderFoldElement, isFolded, handleMoreClick]);

  return (
    // @ts-ignore
    <BubbleBox className={wrapClass} ref={composedRef} style={composedStyle} {...other}>
      {childrenNode}
      {foldActionElement}
    </BubbleBox>
  );
}

export default memo(forwardRef<HTMLDivElement, BubbleProps>(Bubble));
