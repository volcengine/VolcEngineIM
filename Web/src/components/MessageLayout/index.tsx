import React, { FC, CSSProperties, useMemo, useEffect, useState, useCallback } from 'react';
import classNames from 'classnames';
import { useRecoilValue } from 'recoil';
import { FlightStatus, im_proto, Message } from '@volcengine/im-web-sdk';
import { Message as MessageToast } from '@arco-design/web-react';

import { MessageItemType } from '../../types';
import {
  MessageAvatar,
  MessageStatusCmp,
  MessageTime,
  MessageReply,
  Toolbar,
  EmojiTable,
  MessageProperty,
} from './components';
import { IconReply, IconDelete, IconRevocation, IconFillPin, IconLike } from '../Icon';
import { getMessageComponent } from '../MessageCards';
import { useInView } from '../../hooks';
import { getMessageTimeFormat } from '../../utils/formatTime';
import MessageWrap from './Styles';
import { BytedIMInstance, CurrentConversation } from '../../store';
import { getMsgStatusIcon } from '../../utils';

interface MessageLayoutProps {
  className?: string;
  style?: CSSProperties;
  message: MessageItemType;
  avatarUrl?: string;
  sender?: string;
  index?: number;
  markMessageRead?: (msg: Message, index?: number) => void;
  isLast?: boolean;
  onAvatarClick?: (isFromMe: boolean) => void;
  recallMessage?: (msg: Message) => void;
  deleteMessage?: (msg: Message) => void;
  replyMessage?: (msg: Message) => void;
  resendMessage?: (msg: Message) => void;
  modifyProperty?: (msg: Message, key: string, value: string) => void;
}

const MessageLayout: FC<MessageLayoutProps> = props => {
  const {
    className,
    message,
    avatarUrl,
    index,
    sender,
    isLast,
    markMessageRead,
    onAvatarClick,
    recallMessage,
    deleteMessage,
    replyMessage,
    resendMessage,
    modifyProperty,
    ...otherProps
  } = props;
  const { isFromMe, createdAt, flightStatus, type, isRecalled, referenceInfo, ext, property, indexInConversation } =
    message || {};
  const [replyMsg, setReplyMsg] = useState<Message>();
  const [isHover, setIsHover] = useState<boolean>(false);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const [messageItemRef, isInview] = useInView(null, { threshold: 0.7, disabled: isFromMe }, [
    document.visibilityState,
  ]);

  useEffect(() => {
    (async () => {
      const { MESSAGE_TYPE_AUDIO, MESSAGE_TYPE_IMAGE, MESSAGE_TYPE_VIDEO, MESSAGE_TYPE_FILE } = im_proto.MessageType;
      if ([MESSAGE_TYPE_AUDIO, MESSAGE_TYPE_IMAGE, MESSAGE_TYPE_VIDEO, MESSAGE_TYPE_FILE].includes(message.type)) {
        if (message.content && !bytedIMInstance.validateFileUrl({ message })) {
          await bytedIMInstance.refreshFileUrl({ message });
        }
      }
    })();
  }, []);

  useEffect(() => {
    if (isInview && document.visibilityState === 'visible') {
      markMessageRead?.(message, index);
    }
  }, [isInview, markMessageRead, index, message]);

  useEffect(() => {
    if (referenceInfo) {
      const { referenced_message_id } = referenceInfo;
      if (currentConversation.id !== message.conversationId) {
        return;
      }

      bytedIMInstance
        ?.getMessageByServerId({
          conversation: currentConversation,
          serverMessageId: referenced_message_id.toString(),
        })
        .then(ret => {
          setReplyMsg(ret);
        })
        .catch(err => {
          console.error(err);
          return err;
        });
    }
  }, [currentConversation, message, referenceInfo]);

  const handleAvatarClick = () => {};

  const handleMouseLeave = useCallback(() => {
    setIsHover(false);
  }, []);

  const handleMouseEnter = useCallback(() => {
    setIsHover(true);
  }, []);

  const modifyMessageProperty = useCallback(
    (key: string, value: string) => {
      modifyProperty(message, key, value);
    },
    [modifyProperty, message]
  );

  const renderAvatar = () => {
    return <MessageAvatar onClick={handleAvatarClick} source={avatarUrl} desc={sender} />;
  };

  /** 每一个间隔的时间 */
  const renderMessageTimestamp = () => {
    if (!message.isTimeVisible) {
      return null;
    }
    return <MessageTime createAt={createdAt} />;
  };

  /** 每个消息的时间 */
  const renderMessageOwnerInfo = () => {
    return (
      <div className="message-info">
        <span className="message-timestamp noselect">{getMessageTimeFormat(createdAt)}</span>
      </div>
    );
  };

  /** 回复的消息 */
  const renderReply = msg => {
    if (referenceInfo) {
      return <MessageReply message={msg} messageStatus={referenceInfo.referenced_message_status} />;
    }
  };

  const MessageItemCmp = useMemo(() => {
    return getMessageComponent(type, isRecalled);
  }, [type, isRecalled]);

  const renderMessageContent = () => {
    return Boolean(MessageItemCmp) && <MessageItemCmp message={message} />;
  };

  const MessageStatusEle = useMemo(() => {
    return getMsgStatusIcon(flightStatus);
  }, [flightStatus]);

  const renderMsgError = icon => {
    const handleClick = () => {
      resendMessage(message);
    };

    return (
      <div className="message-err-text-tip-wrapper">
        {icon}
        <span className="message-err-text-tip" onClick={handleClick}>
          重新发送
        </span>
      </div>
    );
  };

  /** 消息状态*/
  const renderMessageState = () => {
    if (!MessageStatusEle) {
      return null;
    }
    const { icon, status } = MessageStatusEle;
    let iconContet = icon;
    if (status === FlightStatus.Failed) {
      iconContet = renderMsgError(icon);
    }
    return <MessageStatusCmp showMessageStatus={message.isFromMe} icon={iconContet} />;
  };

  /** 消息的操作栏 */
  const renderToolbar = () => {
    const items = [
      {
        name: '',
        icon: <IconLike />, // 表情评论
        onClick: () => {
          modifyMessageProperty('[赞]', '[赞]');
        },
        table: EmojiTable,
        tableProps: {
          onSelectEmoji: modifyMessageProperty,
          message,
        },
      },
      {
        name: '回复',
        icon: <IconReply />, // 回复
        onClick: () => {
          replyMessage(message);
        },
      },
      {
        name: '撤回',
        icon: <IconRevocation />, // 撤回
        onClick: async () => {
          try {
            await recallMessage(message);
          } catch (err) {
            if (err.message?.includes('RecallTimeout:RECALL_TIMEOUT')) {
              MessageToast.error('超过2分钟，消息撤回失败');
            }
          }
        },
      },
      {
        name: '删除',
        icon: <IconDelete />, // 删除
        onClick: () => {
          deleteMessage(message);
        },
      },
    ];
    if (!isFromMe) {
      items.splice(2, 1);
    }
    return !isRecalled && <Toolbar items={items} isFromMe={isFromMe} setToolBarVisible={setIsHover} />;
  };

  /** 标志 pin */
  const renderPinner = () => {
    return (
      <div className="message-meta-pin">
        <span className="message-meta-pin-icon">
          <IconFillPin />
        </span>
        <span className="replay__pin--text">xxx Pin 了这条消息，对会话双方均可见</span>
      </div>
    );
  };

  /** 消息表情回复 */
  const renderMessageProperty = () => {
    if (Object.keys(property).length) {
      return <MessageProperty property={property} isFromMe={message.isFromMe} modifyProperty={modifyMessageProperty} />;
    }
  };

  const wrapClass = useMemo(() => {
    return classNames({
      'message-item': true,
      hover: isHover,
      'message-self': message.isFromMe,
      'message-other': !message.isFromMe,
      'message-item-last': isLast,
      [className]: Boolean(className),
      'message-position-right': message.isFromMe,
    });
  }, [message, isHover, className, isLast, isRecalled]);

  return (
    <MessageWrap id={`index${indexInConversation?.toString()}`} className="im-message-wrap" {...otherProps}>
      {renderMessageTimestamp()}

      <div className={wrapClass} ref={messageItemRef} onMouseLeave={handleMouseLeave} onMouseEnter={handleMouseEnter}>
        <div className="message-left">{renderAvatar()}</div>
        <div className="message-right">
          {renderMessageOwnerInfo()}

          <div className="message-section">
            <div
              className={classNames({
                'message-section-left': true,
              })}
            >
              {renderReply(replyMsg)}
              {renderMessageContent()}
              {renderMessageProperty()}
            </div>

            <div className="message-section-right">
              {renderToolbar()}
              {renderMessageState()}
            </div>
          </div>
        </div>
      </div>
    </MessageWrap>
  );
};

export default MessageLayout;
