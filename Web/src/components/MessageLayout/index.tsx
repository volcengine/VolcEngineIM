import React, { FC, CSSProperties, useMemo, useEffect, useState, useCallback, useRef } from 'react';
import classNames from 'classnames';
import { useRecoilValue } from 'recoil';
import { Conversation, FlightStatus, im_proto, Message } from '@volcengine/im-web-sdk';
import { Message as MessageToast, Modal, Tooltip } from '@arco-design/web-react';

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
import { useAccountsInfo } from '../../hooks';
import { getMessageTimeFormat } from '../../utils/formatTime';
import MessageWrap from './Styles';
import { BytedIMInstance, CurrentConversation, UserId } from '../../store';
import { getMsgStatusIcon } from '../../utils';
import { IconEdit, IconEye } from '@arco-design/web-react/icon';
import { ENABLE_MESSAGE_INSPECTOR } from '../../constant';
import { useInViewport, useRequest } from 'ahooks';
import Row from '@arco-design/web-react/es/Grid/row';
import Col from '@arco-design/web-react/es/Grid/col';
import MessageReadReceiptState, { MessageReadBatchQuery } from './components/MessageReadReceiptState';

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
  editMessage?: (msg: Message) => void;
  resendMessage?: (msg: Message) => void;
  modifyProperty?: (msg: Message, key: string, value: string) => void;
}
function format(message: Message) {
  return JSON.stringify(message?.getObjectWithoutContext?.(), null, 2);
}
export function MessageDetailModal({
  message,
  setVisible,
  visible,
}: {
  visible: boolean;
  setVisible: (v: boolean) => void;
  message: Message;
}) {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const { data, loading } = useRequest(
    async () => {
      if (visible) {
        return bytedIMInstance.getMessageByServerId({
          conversation: currentConversation,
          serverMessageId: message.serverId,
          online: true,
        });
      }
    },
    {
      refreshDeps: [message.serverId, visible],
    }
  );
  return (
    <Modal
      title="消息详情"
      visible={visible}
      onOk={() => setVisible(false)}
      onCancel={() => setVisible(false)}
      hideCancel={true}
      autoFocus={false}
      focusLock={true}
      escToExit={true}
      style={{ width: 'calc(100vw - 200px)' }}
    >
      {visible && (
        <Row>
          <Col span={12}>
            <div>服务端详情</div>
          </Col>
          <Col span={12}>
            <div>本地详情</div>
          </Col>
          <Col span={12}>
            {loading ? (
              '请求中'
            ) : (
              <pre style={{ maxHeight: 'calc(100vh - 300px)', overflow: 'auto' }}>{format(data)}</pre>
            )}
          </Col>
          <Col span={12}>
            <pre style={{ maxHeight: 'calc(100vh - 300px)', overflow: 'auto' }}>{format(message)}</pre>
          </Col>
        </Row>
      )}
    </Modal>
  );
}
class MessageSendReadBatch extends MessageReadBatchQuery {
  async callApi({ conversation, messages }: { conversation: Conversation; messages: Message[] }): Promise<any> {
    await this.bytedIMInstance.sendMessageReadReceipts({
      conversation: conversation,
      messages: messages,
    });
    for (let message of messages) this.cached[message.serverId] = true;
    return messages.map(i => ({ messageId: i.serverId }));
  }
}

const messageReadQuery = new MessageSendReadBatch();

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
    editMessage,
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

  const messageItemRef = useRef();
  const [isInview] = useInViewport(messageItemRef, { threshold: 0.7 });

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
    if (
      isInview &&
      !message.isFromMe &&
      currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      ![im_proto.MessageType.MESSAGE_TYPE_VIDEO, im_proto.MessageType.MESSAGE_TYPE_AUDIO].includes(message.type)
    ) {
      messageReadQuery.get({
        bytedIMInstance,
        message: message,
      });
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

  const ACCOUNTS_INFO = useAccountsInfo();

  /** 每个消息的时间 */
  const renderMessageOwnerInfo = () => {
    return (
      <div className="message-info">
        {isFromMe && <span className="message-timestamp noselect">{getMessageTimeFormat(createdAt)}&nbsp;</span>}
        <Tooltip content={ACCOUNTS_INFO[sender]?.realName}>
          <span>{ACCOUNTS_INFO[sender]?.name}</span>
        </Tooltip>
        {!isFromMe && <span className="message-timestamp noselect">&nbsp;{getMessageTimeFormat(createdAt)}</span>}
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
  const userId = useRecoilValue(UserId);

  /** 消息状态*/
  const renderMessageState = () => {
    if (
      !message.isOffline &&
      !message.isRecalled &&
      message.isFromMe &&
      currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      currentConversation.toParticipantUserId !== userId
    ) {
      return <MessageReadReceiptState message={message} />;
    }
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

  const [detailModalVisible, setDetailModalVisible] = useState(false);
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
      ...(ENABLE_MESSAGE_INSPECTOR
        ? [
            {
              name: '消息详情',
              icon: <IconEye />,
              onClick: async () => {
                setDetailModalVisible(true);
              },
            },
          ]
        : []),
      ...(message.type === im_proto.MessageType.MESSAGE_TYPE_TEXT && message.isFromMe
        ? [
            {
              name: '编辑',
              icon: <IconEdit />, // 编辑
              onClick: () => {
                editMessage(message);
              },
            },
          ]
        : []),
      {
        name: '删除',
        icon: <IconDelete />, // 删除
        onClick: () => {
          deleteMessage(message);
        },
      },
    ].filter(Boolean);
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
              {!isRecalled && renderMessageProperty()}
            </div>

            <div className="message-section-right">
              {renderToolbar()}
              {renderMessageState()}
            </div>
          </div>
        </div>
      </div>

      <MessageDetailModal visible={detailModalVisible} setVisible={setDetailModalVisible} message={message} />
    </MessageWrap>
  );
};

export default MessageLayout;
