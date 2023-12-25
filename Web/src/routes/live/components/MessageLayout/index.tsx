import React, { FC, CSSProperties, useMemo, useEffect, useState, useCallback } from 'react';
import classNames from 'classnames';
import { useRecoilValue } from 'recoil';
import { FlightStatus, im_proto, Message } from '@volcengine/im-web-sdk';
import { Message as MessageToast, Tooltip } from '@arco-design/web-react';

import { MessageItemType } from '../../../../types';
import { MessageAvatar, MessageStatusCmp, MessageTime, Toolbar, MessageProperty } from './components';
import { IconRevocation } from '../../../../components/Icon';
import { getMessageComponent } from '../../../../components/MessageCards';
import { useAccountsInfo, useInView } from '../../../../hooks';
import MessageWrap from './Styles';
import { BytedIMInstance, CurrentConversation, Participants, UserId } from '../../../../store';
import { getMessageTimeFormat, getMsgStatusIcon } from '../../../../utils';
import { EXT_ALIAS_NAME, EXT_AVATAR_URL } from '../../../../constant';
import { IconArrowDown, IconArrowUp, IconMinus } from '@arco-design/web-react/icon';

interface MessageLayoutProps {
  className?: string;
  style?: CSSProperties;
  message: MessageItemType;
  avatarUrl?: string;
  sender?: string;
  index?: number;
  // markMessageRead?: (msg: Message, index?: number) => void;
  isLast?: boolean;
  onAvatarClick?: (isFromMe: boolean) => void;
  recallMessage?: (msg: Message) => void;
  deleteMessage?: (msg: Message) => void;
  replyMessage?: (msg: Message) => void;
  resendMessage?: (msg: Message) => void;
  modifyProperty?: (msg: Message, key: string, value: string) => void;
}

const PRIORITY_STRING = {
  [im_proto.MessagePriority.HIGH]: '高',
  [im_proto.MessagePriority.NORMAL]: '普通',
  [im_proto.MessagePriority.LOW]: '低',
};
const PRIORITY_ICON = {
  [im_proto.MessagePriority.HIGH]: <IconArrowUp />,
  [im_proto.MessagePriority.NORMAL]: <IconMinus />,
  [im_proto.MessagePriority.LOW]: <IconArrowDown />,
};
const MessageLayout: FC<MessageLayoutProps> = props => {
  const {
    className,
    message,
    index,
    sender,
    isLast,
    // markMessageRead,
    onAvatarClick,
    recallMessage,
    deleteMessage,
    replyMessage,
    resendMessage,
    modifyProperty,
    ...otherProps
  } = props;
  const {
    isFromMe,
    createdAt,
    flightStatus,
    type,
    isRecalled,
    referenceInfo,
    ext,
    property,
    indexInConversation,
    content,
    conversationId,
    isTimeVisible,
  } = message || {};
  const [replyMsg, setReplyMsg] = useState<Message>();
  const [isHover, setIsHover] = useState<boolean>(false);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);
  const participants = useRecoilValue(Participants);
  const userId = useRecoilValue(UserId);

  const [messageItemRef, isInview] = useInView(null, { threshold: 0.7, disabled: isFromMe }, [
    document.visibilityState,
  ]);

  useEffect(() => {
    (async () => {
      const { MESSAGE_TYPE_AUDIO, MESSAGE_TYPE_IMAGE, MESSAGE_TYPE_VIDEO, MESSAGE_TYPE_FILE } = im_proto.MessageType;
      if ([MESSAGE_TYPE_AUDIO, MESSAGE_TYPE_IMAGE, MESSAGE_TYPE_VIDEO, MESSAGE_TYPE_FILE].includes(type)) {
        if (content && !bytedIMInstance.validateFileUrl({ message })) {
          await bytedIMInstance.refreshFileUrl({ message });
        }
      }
    })();
  }, []);

  useEffect(() => {
    if (referenceInfo) {
      const { referenced_message_id } = referenceInfo;
      if (currentConversation.id !== conversationId) {
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
  }, [currentConversation?.id, message, referenceInfo]);

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
    const avatarUrl =
      participants.find(i => i.userId === sender)?.avatarUrl || ext[EXT_AVATAR_URL] || ACCOUNTS_INFO[sender]?.url;
    return <MessageAvatar onClick={handleAvatarClick} source={avatarUrl} desc={sender} />;
  };

  /** 每一个间隔的时间 */
  const renderMessageTimestamp = () => {
    if (!isTimeVisible) {
      return null;
    }
    return <MessageTime createAt={createdAt} />;
  };

  /** 每个消息的时间 */
  const ACCOUNTS_INFO = useAccountsInfo();

  const renderMessageOwnerInfo = () => {
    return (
      <div className="message-info">
        {isFromMe && <span className="message-timestamp noselect">{getMessageTimeFormat(createdAt)}&nbsp;</span>}
        <Tooltip content={ACCOUNTS_INFO[sender]?.realName}>
          <span>
            {ACCOUNTS_INFO[sender]?.hasFriendAlias
              ? ACCOUNTS_INFO[sender]?.name
              : participants.find(i => i.userId === sender)?.alias ||
                ext[EXT_ALIAS_NAME] ||
                ACCOUNTS_INFO[sender]?.name}
          </span>
        </Tooltip>
        {!isFromMe && <span className="message-timestamp noselect">&nbsp;{getMessageTimeFormat(createdAt)}</span>}
      </div>
    );
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
    return <MessageStatusCmp showMessageStatus={isFromMe} icon={iconContet} />;
  };

  /** 消息的操作栏 */
  const renderToolbar = () => {
    let b = message.messagePriority !== undefined;
    const items = [
      // {
      //   name: '撤回',
      //   icon: <IconRevocation />, // 撤回
      //   onClick: async () => {
      //     try {
      //       await recallMessage(message);
      //     } catch (err) {
      //       if (err.message?.includes('RecallTimeout:RECALL_TIMEOUT')) {
      //         MessageToast.error('超过2分钟，消息撤回失败');
      //       }
      //     }
      //   },
      // },
      b && {
        name: `消息优先级：${PRIORITY_STRING[message.messagePriority]}`,
        icon: PRIORITY_ICON[message.messagePriority],
      },
    ].filter(Boolean);
    if (!isFromMe) {
      items.splice(2, 1);
    }
    return !isRecalled && <Toolbar items={items} isFromMe={isFromMe} setToolBarVisible={setIsHover} />;
  };

  /** 消息表情回复 */
  const renderMessageProperty = () => {
    if (Object.keys(property).length) {
      return <MessageProperty property={property} isFromMe={isFromMe} modifyProperty={modifyMessageProperty} />;
    }
  };

  const wrapClass = useMemo(() => {
    return classNames({
      'message-item': true,
      hover: isHover,
      'message-self': isFromMe,
      'message-other': !isFromMe,
      'message-item-last': isLast,
      [className]: Boolean(className),
      'message-position-right': isFromMe,
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
