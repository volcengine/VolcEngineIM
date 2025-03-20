import React, { useCallback, CSSProperties, ReactNode, forwardRef, useRef, useState } from 'react';
import classNames from 'classnames';
import { Button } from '@arco-design/web-react';
import { IconClose } from '@arco-design/web-react/icon';

import Protal from '../Portal';
import Transition from '../Transition';
import DialogBox, { GlobalStyle } from './Styles';

const prefixCls = 'im-dialog';
interface DialogProps {
  style?: CSSProperties;
  className?: string | string[];
  /** 关闭弹出框的回调 */
  onCancel?: () => void;
  /** 点击确认按钮的回调 */
  onOk?: (e?: MouseEvent, useStringUid?: boolean) => Promise<any> | void;
  /** 指定弹出框挂载的父节点 [[() => document.body]] */
  getPopupContainer?: () => Element;
  /** 弹出框的标题 */
  title?: string | ReactNode;
  /** 弹出框是否可见 */
  visible?: boolean;
  /** 是否显示遮罩。[[true]] */
  mask?: boolean;
  /** 确认按钮文案 */
  okText?: string;
  /** 字符串确认按钮文案 */
  stringOkText?: string;
  /** 取消按钮文案 */
  cancelText?: string;
  /** 自定义页脚，传入 null 则不显示 */
  footer?: ReactNode;
  /** 是否显示右上角的关闭按钮 */
  closable?: boolean;
  /** 点击蒙层是否可以关闭 [[true]] */
  maskClosable?: boolean;
  /** 蒙层的样式（`2.6.0`开始支持） */
  maskStyle?: CSSProperties;
  /** 弹框打开之后的回调 */
  afterOpen?: () => void;
  /** 弹框关闭之后的回调 */
  afterClose?: () => void;
  /** 是否在隐藏之后销毁DOM结构 */
  unmountOnExit?: boolean;
  /** 弹出框外层 dom 类名。 */
  wrapClassName?: string | string[];
  /** 弹出框外层样式 */
  wrapStyle?: CSSProperties;
  modalStyle?: CSSProperties;
  hideCancel?: boolean;
  hideOk?: boolean;
  children?: ReactNode;
}

type CursorPositionType = { left: number; top: number } | null;
let cursorPosition: CursorPositionType | null = null;

document.documentElement.addEventListener(
  'click',
  (e: MouseEvent) => {
    cursorPosition = {
      left: e.clientX,
      top: e.clientY,
    };
    // 受控模式下，用户不一定马上打开弹窗，这期间可能出现其他 UI 操作，那这个位置就不可用了。
    setTimeout(() => {
      cursorPosition = null;
    }, 100);
  },
  true
);

const Dialog = (props: DialogProps, ref) => {
  const {
    style,
    className,
    getPopupContainer = () => document.body,
    visible,
    unmountOnExit = true,
    hideCancel,
    hideOk,
    children,

    // Wrapper
    title,
    modalStyle,
    wrapStyle,
    wrapClassName,
    okText,
    stringOkText,
    cancelText,
    footer,
    onCancel: _onCancel,
    onOk,
    afterOpen,
    afterClose,

    // Dialog
    closable = true,

    // Mask
    mask = true,
    maskClosable = true,
    maskStyle,
    ...other
  } = props;

  const containerCls = classNames(`${prefixCls}-root`, className);
  const wrapCls = classNames(`${prefixCls}-wrap`, wrapClassName);
  const [wrapperVisible, setWrapperVisible] = useState(false);
  const wrapperRef = useRef<HTMLDivElement>(null);
  const contentWrapper = useRef<HTMLDivElement>(null);
  const cursorPositionRef = useRef<CursorPositionType>(null);
  const haveOriginTransformOrigin = useRef<boolean>(false);

  const onConfirm = useCallback(
    (e, useStringUid = false) => {
      onOk?.(e, useStringUid);
    },
    [onOk]
  );

  const onCancel = useCallback(() => {
    _onCancel?.();
  }, [_onCancel]);

  const onMaskClick = (e: React.MouseEvent<any>) => {
    if (maskClosable && mask) {
      setTimeout(() => {
        onCancel();
      }, 100);
    }
  };

  const setTransformOrigin = (e: HTMLDivElement) => {
    if (haveOriginTransformOrigin.current) return;

    let transformOrigin = '';
    if (cursorPositionRef.current) {
      const eRect = e.getBoundingClientRect();
      const { left, top } = cursorPositionRef.current;
      transformOrigin = `${left - eRect.left}px ${top - eRect.top}px`;
    }
    e.style.transformOrigin = transformOrigin;
  };

  const renderFooter = () => {
    if (footer === null) return null;

    return (
      <div className={`${prefixCls}-footer`}>
        {footer || (
          <>
            {!hideCancel && (
              <Button size="small" onClick={onCancel}>
                {cancelText || '取消'}
              </Button>
            )}
            {!hideOk && (
              <>
                <Button type="primary" size="small" className="im-button" onClick={onConfirm}>
                  {okText || '确定'}
                </Button>

                {stringOkText && (
                  <Button
                    type="primary"
                    size="small"
                    className="im-button"
                    onClick={e => {
                      onConfirm(e, true);
                    }}
                  >
                    {stringOkText}
                  </Button>
                )}
              </>
            )}
          </>
        )}
      </div>
    );
  };

  return (
    <Protal getContainer={getPopupContainer}>
      <GlobalStyle />
      <DialogBox className={containerCls} ref={ref} style={style}>
        {mask && (
          <Transition
            classNames="fadeModal"
            duration={400}
            in={visible}
            appear
            unmountOnExit={unmountOnExit}
            onEnter={(e: HTMLDivElement) => {
              e.style.display = 'block';
            }}
            onExited={(e: HTMLDivElement) => {
              e.style.display = 'none';
            }}
          >
            <div className={`${prefixCls}-mask`} style={maskStyle} />
          </Transition>
        )}

        <div
          ref={wrapperRef}
          className={wrapCls}
          style={{
            ...(wrapStyle || {}),
            display: visible || wrapperVisible ? 'block' : 'none',
            overflow: !visible && wrapperVisible ? 'hidden' : '',
          }}
          {...other}
        >
          <div className="mask-placehoder" onClick={onMaskClick} />
          <Transition
            in={visible}
            duration={400}
            appear
            classNames="zoomModal"
            unmountOnExit={unmountOnExit}
            onEnter={(e: HTMLDivElement) => {
              setWrapperVisible(true);
              cursorPositionRef.current = cursorPosition;
              haveOriginTransformOrigin.current = Boolean(e.style.transformOrigin);
              setTransformOrigin(e);
            }}
            onEntered={(e: HTMLDivElement) => {
              setTransformOrigin(e);
              cursorPositionRef.current = null;
              afterOpen && afterOpen();
            }}
            onExited={e => {
              setWrapperVisible(false);
              setTransformOrigin(e);
              afterClose?.();
            }}
          >
            <div className={prefixCls} style={modalStyle}>
              {closable && (
                <div onClick={onCancel} className={`${prefixCls}-close-icon`}>
                  <span className="close-icon-wrap">
                    <IconClose />
                  </span>
                </div>
              )}
              {title && (
                <div className={`${prefixCls}-header`}>
                  <div className={`${prefixCls}-title`}>{title}</div>
                </div>
              )}
              <div ref={contentWrapper} className={`${prefixCls}-content`}>
                {children}
              </div>
              {renderFooter()}
            </div>
          </Transition>
        </div>
      </DialogBox>
    </Protal>
  );
};

export default forwardRef(Dialog);
