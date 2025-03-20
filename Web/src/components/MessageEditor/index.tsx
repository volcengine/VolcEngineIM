import React, { FC, CSSProperties, useEffect, useRef, useState, useCallback, useImperativeHandle } from 'react';
import { Message } from '@volcengine/im-web-sdk';
import { IconClose } from '@arco-design/web-react/icon';

import IconButtonMask from '../IconButtonMask';
import BaseEditor from './baseEditor';
import { IRichText } from './interface';
import { EDITOR_TYPE, KeyCode } from '../../constant';
import { getMessagePreview } from '../../utils';
import { useAccountsInfo, useMessage } from '../../hooks';
import { CurrentConversation, CurrentEditorMentionedUsers } from '../../store';
import { useRecoilState, useRecoilValue } from 'recoil';

interface ImEditorProps {
  style?: CSSProperties;
  className?: string;
  placeholder?: string;
  repliedMessage?: Message;
  editingMessage?: Message;
  ref?: any;
  onSubmit?: (richText?: IRichText, mentionedUsers?: string[]) => void;
  changeReplyMessage?: (message) => void;
  onEditorStateChange?: (richText?: IRichText) => void;
  onMessageTyping?: () => void;
  suggestions: any;
  toolBarList?: any;
  editorType?: EDITOR_TYPE;
}

const ImEditor: FC<ImEditorProps> = React.forwardRef((props, ref) => {
  const {
    style,
    className,
    placeholder,
    repliedMessage,
    editingMessage,
    changeReplyMessage,
    onEditorStateChange,
    onSubmit,
    suggestions,
    toolBarList,
    editorType = EDITOR_TYPE.SIMPLE,
    onMessageTyping,
  } = props;
  const baseEditor = useRef<HTMLTextAreaElement>(null);
  const focusAnimationFrame = useRef<any>(null);
  const focusAtEndAnimationFrame = useRef<any>(null);
  const isEditorIsEmpty = useRef(true);
  const { sendFileMessage, sendImageMessage, sendVideoMessage, sendAudioMessage, sendVolcMessage, sendCouponMessage } =
    useMessage();
  const [currentEditorMentionedUsers, setCurrentEditorMentionedUsers] = useRecoilState(CurrentEditorMentionedUsers);

  const focus = () => {
    cancelAnimationFrame(focusAnimationFrame.current);

    focusAnimationFrame.current = requestAnimationFrame(() => {
      baseEditor.current?.focus();
      focusAnimationFrame.current = null;
    });
  };

  const blur = () => {
    baseEditor.current?.blur();
  };

  const getToolBarList = useCallback(
    (): any => [
      {
        key: 'Emoji',
        use: true,
      },
      {
        key: 'Mention',
        use: true,
        params: {
          suggestions,
        },
      },
      {
        key: 'Image',
        use: true,
        params: {
          sendMessage: sendImageMessage,
        },
      },
      {
        key: 'Video',
        use: true,
        params: {
          sendMessage: sendVideoMessage,
        },
      },
      {
        key: 'File',
        use: true,
        params: {
          sendMessage: sendFileMessage,
        },
      },
      {
        key: 'Audio',
        use: true,
        params: {
          sendMessage: sendAudioMessage,
        },
      },
      {
        key: 'Volc',
        use: true,
        params: {
          sendMessage: sendVolcMessage,
        },
      },
      {
        key: 'Coupon',
        use: true,
        params: {
          sendMessage: sendCouponMessage,
        },
      },
      {
        key: 'MorePanel',
        use: false,
      },
    ],
    [sendImageMessage, sendFileMessage, sendAudioMessage, sendVolcMessage]
  );

  /** 退出回复消息状态 */
  const clearReply = useCallback(() => {
    changeReplyMessage?.(null);
  }, [changeReplyMessage]);

  const shouldSendMessage = (ev: KeyboardEvent) => {
    const send = 'Enter';
    if (ev.keyCode !== 13 || ev.shiftKey || ev.altKey) {
      return false;
    }
    if (send === 'Enter' && !ev.metaKey && !ev.ctrlKey) {
      return true;
    }

    return false;
  };
  const ACCOUNTS_INFO = useAccountsInfo();

  const renderReplyTitle = () => {
    const msg = editingMessage || repliedMessage;

    const content = getMessagePreview(msg);

    return (
      <div className="reply-title">
        <IconButtonMask
          maskStyle={{
            width: '20px',
            height: '20px',
            top: '2px',
            left: '1px',
          }}
        >
          <span className="im-icon-cross" onClick={clearReply}>
            <IconClose />
          </span>
        </IconButtonMask>
        <span className="reply-text">
          {editingMessage ? '编辑' : '回复'} {ACCOUNTS_INFO[msg.sender].name}:&nbsp;{content}
        </span>
      </div>
    );
  };

  const handleSubmit = () => {
    onSubmit?.({ text: baseEditor.current?.value }, currentEditorMentionedUsers);
  };

  const clearEditor = () => {
    requestAnimationFrame(() => {
      baseEditor.current.value = '';
    });
    setCurrentEditorMentionedUsers([]);
  };

  let submit = () => {
    clearEditor();
    handleSubmit();
  };

  const handleEditorKeyDown = (event: KeyboardEvent) => {
    switch (event.keyCode) {
      case KeyCode.RETURN:
        if (editorType !== EDITOR_TYPE.CAN_NOT_EDIT && shouldSendMessage(event)) {
          clearEditor();

          handleSubmit();
          // 阻止事件冒泡
          event.stopPropagation();
          // 阻止浏览器默认行为
          event.preventDefault();
        }
        break;
      default:
        break;
    }
  };

  useEffect(() => {
    if (!baseEditor.current) {
      return;
    }

    baseEditor.current.addEventListener('keydown', handleEditorKeyDown);

    return () => {
      baseEditor.current?.removeEventListener('keydown', handleEditorKeyDown);
    };
  }, [handleEditorKeyDown, baseEditor.current]);

  useImperativeHandle(ref, () => ({
    submit: submit,
  }));

  return (
    <BaseEditor
      style={style}
      className={className}
      businessKey="IM_CHAT"
      ref={baseEditor}
      placeholder={placeholder}
      editorType={editorType}
      toolBarList={toolBarList || getToolBarList()}
      renderHeader={editingMessage || repliedMessage ? renderReplyTitle : null}
      suggestions={suggestions}
      onMessageTyping={onMessageTyping}
    />
  );
});

export * from './interface';

export default ImEditor;
