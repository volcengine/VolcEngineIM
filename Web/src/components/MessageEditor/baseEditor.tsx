import React, {
  FC,
  CSSProperties,
  useEffect,
  useRef,
  useState,
  useMemo,
  useCallback,
  forwardRef,
  memo,
  useImperativeHandle,
} from 'react';
import classNames from 'classnames';

import EditorWrap from './Styles';
import { TOOL_BAR_ITEM_MAP } from './constant';
import { Input } from '@arco-design/web-react';

interface IToolBar {
  key: 'Image' | 'Emoji' | 'Video' | 'Mention' | 'MorePanel';
  use: boolean;
  params?: {
    onEmojiPanelTrigger?: (showEmoji: boolean) => void;
    onMorePanelOpen?: () => void;
    popupOffset?: [number, number];
    sendMessage?: any;
    [key: string]: any;
  };
}

interface ImEditorProps {
  style?: CSSProperties;
  businessKey?: string;
  editorType?: string;
  className?: string;
  placeholder?: string;
  toolBarList?: IToolBar[];
  renderHeader?: () => React.ReactNode;
  renderExtra?: () => React.ReactNode;
  updateEditorType?: (editType: string) => void;
  editorContentChange?: (isEmpty?: boolean) => void;
  onMessageTyping?: () => void;
  suggestions: any;
}

const BaseEditor: FC<ImEditorProps> = (props, ref) => {
  const { style, editorType, className, toolBarList = [], editorContentChange, renderHeader, onMessageTyping } = props;

  const editorWrapRef = useRef<HTMLDivElement>(null);

  /** 渲染顶部操作按钮 */
  const renderToolBarList = () => (
    <div className="im__editor--toolbar">
      {toolBarList.map(toolBar => {
        const { use, params, key } = toolBar;
        const ToolBarItem = TOOL_BAR_ITEM_MAP[key] as React.FC<any>;

        if (ToolBarItem && use) {
          return <ToolBarItem key={key + JSON.stringify(params)} {...params} editor={ref.current} />;
        } else {
          return null;
        }
      })}
    </div>
  );

  return (
    <EditorWrap className={'im__editor--default'} style={style}>
      {renderToolBarList()}
      {renderHeader?.()}
      <div className="post-edit-zone" ref={editorWrapRef}>
        <textarea
          className={'editor-textarea'}
          placeholder={'发送消息...'}
          ref={ref}
          maxLength={500}
          onChange={onMessageTyping}
        ></textarea>
      </div>
    </EditorWrap>
  );
};

export default memo(forwardRef<any, ImEditorProps>(BaseEditor as any));
