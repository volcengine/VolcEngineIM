import React, { useState, useCallback, useEffect, useRef, forwardRef, useMemo, useImperativeHandle } from 'react';
import { findDOMNode } from 'react-dom';
import classNames from 'classnames';
import { IconClose } from '@arco-design/web-react/icon';

import Transition from '../Transition';
import Portal from '../Portal';
import ImagePreviewToolbar from './ImagePreviewToolbar';
import {
  IconLoading,
  IconFullscreen,
  IconRotateRight,
  IconRotateLeft,
  IconZoomIn,
  IconZoomOut,
  IconOriginalSize,
} from '../Icon';

import getScale, { minScale, maxScale } from '../../utils/getScale';
import { on, off, getFixTranslate } from '../../utils/dom';
import { ImagePreviewProps } from './interface';
import useImageStatus from './useImageStatus';
import useMergeValue from './useMergeValue';
import { GlobalStyle } from './Styles';

export type ImagePreviewHandle = {
  reset: () => void;
};

const ROTATE_STEP = 90;
const prefixCls = 'im-image-preview';

const defaultActionsLayout = ['fullScreen', 'rotateRight', 'rotateLeft', 'zoomIn', 'zoomOut', 'originalSize', 'extra'];
const noop = () => document.body;

const ImagePreview: React.FC<ImagePreviewProps> = (props, ref) => {
  const {
    className,
    style,
    src,
    maskClosable = true,
    closable = true,
    actions,
    actionsLayout = defaultActionsLayout,
    getPopupContainer = noop,
    onVisibleChange,
  } = props;

  const [visible, setVisible] = useMergeValue(false, {
    defaultValue: false,
    value: props.visible,
  });

  const refImage = useRef<HTMLImageElement>();
  const refImageContainer = useRef<HTMLDivElement>();
  const refWrapper = useRef<HTMLDivElement>();

  const refMoveData = useRef({
    pageX: 0,
    pageY: 0,
    originX: 0,
    originY: 0,
  });

  const { isLoading, isLoaded, setStatus } = useImageStatus('loading');
  const [translate, setTranslate] = useState({ x: 0, y: 0 });
  const [scale, setScale] = useState(1);
  const [scaleValueVisible, setScaleValueVisible] = useState(false);
  const [rotate, setRotate] = useState(0);
  const [moving, setMoving] = useState(false);

  const mergedSrc = src;

  const wrapClass = classNames(
    prefixCls,
    {
      [`${prefixCls}-hide`]: !visible,
    },
    className
  );

  /** 重置图片参数 */
  function reset() {
    setTranslate({ x: 0, y: 0 });
    setScale(1);
    setRotate(0);
  }

  useImperativeHandle<ImagePreviewHandle, ImagePreviewHandle>(ref, () => ({
    reset,
  }));

  const [container, setContainer] = useState<HTMLElement>();
  const getContainer = useCallback(() => container, [container]);

  useEffect(() => {
    const container = getPopupContainer?.();
    const containerDom = (findDOMNode(container) || document.body) as HTMLElement;
    setContainer(containerDom);
  }, [getPopupContainer]);

  const isFixed = useMemo(() => container === document.body, [container]);

  /** 缩放 */
  const hideScaleTimer = useRef(null);
  const showScaleValue = () => {
    !scaleValueVisible && setScaleValueVisible(true);
    hideScaleTimer.current && clearTimeout(hideScaleTimer.current);
    hideScaleTimer.current = setTimeout(() => {
      setScaleValueVisible(false);
    }, 1000);
  };
  const onScaleChange = newScale => {
    if (scale !== newScale) {
      setScale(newScale);
      showScaleValue();
    }
  };

  /** 满屏 */
  function onFullScreen() {
    const wrapperRect = refWrapper.current.getBoundingClientRect();
    const imgRect = refImage.current.getBoundingClientRect();
    const newHeightScale = wrapperRect.height / (imgRect.height / scale);
    const newWidthScale = wrapperRect.width / (imgRect.width / scale);
    let newScale = Math.max(newHeightScale, newWidthScale);

    onScaleChange(newScale);
  }

  /** 逆时针旋转 */
  function onRotateLeft() {
    setRotate(rotate === 0 ? 360 - ROTATE_STEP : rotate - ROTATE_STEP);
  }

  /** 顺时针旋转 */
  function onRotateRight() {
    setRotate((rotate + ROTATE_STEP) % 360);
  }

  /** 放大 */
  function onZoomIn() {
    const newScale = getScale(scale, 'zoomIn');
    onScaleChange(newScale);
  }

  /** 缩小 */
  function onZoomOut() {
    const newScale = getScale(scale, 'zoomOut');
    onScaleChange(newScale);
  }

  /** 缩放到100% */
  function onResetScale() {
    onScaleChange(1);
  }

  /** 点击包裹图片的区域 */
  function onOutsideImgClick(e) {
    if (e.target === e.currentTarget && maskClosable) {
      close();
    }
  }

  /** 点击关闭按钮 */
  function onCloseClick() {
    close();
  }

  function close() {
    if (visible) {
      onVisibleChange && onVisibleChange(false, visible);
      setVisible(false);
    }
  }

  /** 检查和矫正偏移量  */
  const checkAndFixTranslate = () => {
    if (!refWrapper.current || !refImage.current) return;
    const wrapperRect = refWrapper.current.getBoundingClientRect();
    const imgRect = refImage.current.getBoundingClientRect();
    const [x, y] = getFixTranslate(wrapperRect, imgRect, translate.x, translate.y, scale);
    if (x !== translate.x || y !== translate.y) {
      setTranslate({
        x,
        y,
      });
    }
  };

  /** 图片移动中：计算和更新位移 */
  const onMoving = e => {
    if (visible && moving) {
      e.preventDefault && e.preventDefault();
      const { originX, originY, pageX, pageY } = refMoveData.current;
      const nextX = originX + (e.pageX - pageX) / scale;
      const nextY = originY + (e.pageY - pageY) / scale;
      setTranslate({
        x: nextX,
        y: nextY,
      });
    }
  };

  /** 图片结束移动 */
  const onMoveEnd = e => {
    e.preventDefault && e.preventDefault();
    setMoving(false);
  };

  /** 抓住图片，要开始移动：记录初始数据 */
  const onMoveStart = e => {
    e.preventDefault && e.preventDefault();
    setMoving(true);

    const ev = e.type === 'touchstart' ? e.touches[0] : e;
    refMoveData.current.pageX = ev.pageX;
    refMoveData.current.pageY = ev.pageY;
    refMoveData.current.originX = translate.x;
    refMoveData.current.originY = translate.y;
  };

  useEffect(() => {
    if (visible && moving) {
      on(document, 'mousemove', onMoving, false);
      on(document, 'mouseup', onMoveEnd, false);
    }
    return () => {
      off(document, 'mousemove', onMoving, false);
      off(document, 'mouseup', onMoveEnd, false);
    };
  }, [visible, moving]);

  /** 移动完之后要矫正偏移量 */
  useEffect(() => {
    if (!moving) {
      checkAndFixTranslate();
    }
  }, [moving, translate]);

  /** scale 也要矫正偏移量  */
  useEffect(() => {
    checkAndFixTranslate();
  }, [scale]);

  /** 打开： 设置 document 滚动状态 */
  useEffect(() => {
    if (visible) {
      reset();
    }
  }, [visible]);

  /** 第一次加载图片/图片切换 */
  useEffect(() => {
    setStatus('loading');
    reset();
  }, [mergedSrc]);

  const defaultActions = [
    {
      key: 'fullScreen',
      content: <IconFullscreen />,
      onClick: onFullScreen,
    },
    {
      key: 'rotateRight',
      content: <IconRotateRight />,
      onClick: onRotateRight,
    },
    {
      key: 'rotateLeft',
      content: <IconRotateLeft />,
      onClick: onRotateLeft,
    },
    {
      key: 'zoomIn',
      content: <IconZoomIn />,
      onClick: onZoomIn,
      disabled: scale === maxScale,
    },
    {
      key: 'zoomOut',
      content: <IconZoomOut />,
      onClick: onZoomOut,
      disabled: scale === minScale,
    },
    {
      key: 'originalSize',
      content: <IconOriginalSize />,
      onClick: onResetScale,
    },
  ];

  return (
    <Portal getContainer={getContainer}>
      <GlobalStyle />
      <div
        className={wrapClass}
        style={{
          ...(style || {}),
          ...(isFixed ? {} : { zIndex: 'inherit', position: 'absolute' }),
        }}
      >
        <Transition
          in={visible}
          duration={400}
          classNames="fadeImage"
          mountOnEnter
          onEnter={e => {
            e.parentNode.style.display = 'block';
            e.style.display = 'block';
          }}
          onExited={e => {
            e.parentNode.style.display = '';
            e.style.display = 'none';
          }}
        >
          <div className={`${prefixCls}-mask`} />
        </Transition>
        {visible && (
          <div ref={refWrapper} className={`${prefixCls}-wrapper`} onClick={onOutsideImgClick}>
            <div
              ref={refImageContainer}
              className={`${prefixCls}-img-container`}
              style={{ transform: `scale(${scale}, ${scale})` }}
              onClick={onOutsideImgClick}
            >
              <img
                ref={refImage}
                className={classNames(`${prefixCls}-img`, {
                  [`${prefixCls}-img-moving`]: moving,
                })}
                key={mergedSrc}
                src={mergedSrc}
                style={{
                  transform: `translate(${translate.x}px, ${translate.y}px) rotate(${rotate}deg)`,
                }}
                onLoad={() => {
                  setStatus('loaded');
                }}
                onError={() => {
                  setStatus('error');
                }}
                onMouseDown={onMoveStart}
              />
              {isLoading && (
                <div className={`${prefixCls}-loading`}>
                  <IconLoading />
                </div>
              )}
            </div>
            <Transition in={scaleValueVisible} duration={400} appear classNames="fadeImage" unmountOnExit>
              <div className={`${prefixCls}-scale-value`}>{(scale * 100).toFixed(0)}%</div>
            </Transition>
            {isLoaded && (
              <ImagePreviewToolbar actions={actions} actionsLayout={actionsLayout} defaultActions={defaultActions} />
            )}
            {closable && (
              <div className={`${prefixCls}-close-btn`} onClick={onCloseClick}>
                <IconClose />
              </div>
            )}
          </div>
        )}
      </div>
    </Portal>
  );
};

const PreviewComponent = forwardRef<ImagePreviewHandle, ImagePreviewProps>(ImagePreview as any);

export default PreviewComponent;
