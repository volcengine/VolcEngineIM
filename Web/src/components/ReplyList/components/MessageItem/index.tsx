import React, { useCallback, useState } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import { getMessageComponent } from '../../../MessageCards';
import { Avatar } from '../../..';
import { IconReply, IconLike } from '../../../Icon';
import { getMessageTimeFormat } from '../../../../utils';
import useMessage from '../../../../hooks/useMessage';
import { Toolbar } from '../../../MessageLayout/components';
import EmojiTable from '../../../MessageLayout/components/EmojiTable';

import Container from './Style';
import { useAccountsInfo } from '../../../../hooks';

interface IMessageItemProps {
  message: Message;
  index: number;
  messageLen: number;
}

const MessageItem = ({ message, index, messageLen }: IMessageItemProps) => {
  const CMP = getMessageComponent(message?.type, message?.isRecalled);
  const [isHover, setIsHover] = useState<boolean>(false);
  const { modifyMessageProperty } = useMessage();

  const handleMouseEnter = useCallback(() => {
    setIsHover(true);
  }, [setIsHover]);
  const handleMouseLeave = useCallback(() => {
    setIsHover(false);
  }, [setIsHover]);

  const renderToolbar = () => {
    const items = [
      {
        name: '',
        icon: <IconLike />, // 表情评论
        onClick: () => {
          modifyMessageProperty(message, '[赞]', '[赞]');
        },
        table: EmojiTable,
        tableProps: {
          onSelectEmoji: (key: string, value: string) => modifyMessageProperty(message, key, value),
          message,
        },
      },
    ];
    return <Toolbar items={items} setToolBarVisible={setIsHover} />;
  };
  const ACCOUNTS_INFO = useAccountsInfo();

  return (
    <Container className={index === 0 ? 'divider' : ''}>
      <div
        className={`message-main-container ${isHover ? 'hover' : ''}`}
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
      >
        <div className="message-head-container">
          <div className="message-head-avatar">
            <Avatar url={ACCOUNTS_INFO[message?.sender].url} size={36} />
          </div>

          <div className="message-head-detail">
            <div className="message-detail-name">{message?.sender}</div>
            <div className="message-detail-time">{message?.createdAt && getMessageTimeFormat(message?.createdAt)}</div>
          </div>

          <div className="message-head-toolbar">{renderToolbar()}</div>
        </div>

        <div className="message-body-container">{CMP && <CMP message={message} />}</div>
      </div>

      {index === 0 && (
        <div className="message-extra-container">
          <IconReply />
          <div className="message-foot-container">{messageLen - 1}条回复</div>
        </div>
      )}
    </Container>
  );
};

export default MessageItem;
