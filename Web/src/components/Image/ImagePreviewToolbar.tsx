import React, { CSSProperties, forwardRef } from 'react';
import classNames from 'classnames';

import { ImagePreviewActionProps } from './interface';

interface ImagePreviewToolbarProps {
  style?: CSSProperties;
  className?: string | string[];
  actions: ImagePreviewActionProps[];
  actionsLayout: string[];
  defaultActions: ImagePreviewActionProps[];
}

const prefixCls = 'im-image-preview-toolbar';

const ImagePreviewToolbar = (props: ImagePreviewToolbarProps, ref) => {
  const {
    actions = [],
    actionsLayout = [],
    defaultActions = [],
    className,
    ...restProps
  } = props;

  // 根据 layout 过滤
  const actionsLayoutSet = new Set(actionsLayout);

  const filterWithLayout = (item: ImagePreviewActionProps) =>
    actionsLayoutSet.has(item.key);
  const filteredActions = [
    ...defaultActions.filter(filterWithLayout),
    ...actions.filter(filterWithLayout),
  ];

  const extraActions = actions.filter(item => !actionsLayoutSet.has(item.key));

  // 根据 layout 排序
  const resultActions = filteredActions.sort((pre, cur) => {
    const preIndex = actionsLayout.indexOf(pre.key);
    const curIndex = actionsLayout.indexOf(cur.key);
    return preIndex > curIndex ? 1 : -1;
  });

  if (actionsLayoutSet.has('extra')) {
    const extraIndex = actionsLayout.indexOf('extra');
    resultActions.splice(extraIndex, 0, ...extraActions);
  }

  if (!resultActions.length) return null;

  const renderAction = (itemData: ImagePreviewActionProps) => {
    const { content, disabled, key, getContainer, onClick, ...rest } = itemData;

    const action = (
      <div
        className={classNames(`${prefixCls}-action`, {
          [`${prefixCls}-action-disabled`]: disabled,
        })}
        key={key}
        onClick={e => {
          if (!disabled && onClick) {
            onClick(e);
          }
        }}
        onMouseDown={e => {
          /** 解决快速点击按钮的情况下 tooltip 被选中 */
          e.preventDefault();
        }}
        {...rest}>
        {content && (
          <span className={`${prefixCls}-action-content`}>{content}</span>
        )}
      </div>
    );
    if (getContainer) {
      return getContainer(action);
    }
    return action;
  };

  const actionList = resultActions.map(item => {
    return renderAction(item);
  });

  const wrapClass = classNames(prefixCls, className);

  return (
    <div ref={ref} className={wrapClass} {...restProps}>
      {actionList}
    </div>
  );
};

export default forwardRef<unknown, ImagePreviewToolbarProps>(
  ImagePreviewToolbar,
);
