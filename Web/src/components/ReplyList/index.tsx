import React, { useEffect, useState, FC } from 'react';
import { useRecoilValue } from 'recoil';
import { Tooltip } from '@arco-design/web-react';
import { IconClose } from '@arco-design/web-react/icon';
import { Message } from '@volcengine/im-web-sdk';

import { BytedIMInstance } from '../../store';
import MessageItem from './components/MessageItem/index';

import Container from './Style';
interface IReplyListPorps {
  message?: Message;
  handleClose?: () => void;
}

const ReplyList: FC<IReplyListPorps> = ({ message, handleClose }) => {
  const [messageList, setMessageList] = useState<Message[]>([message]);
  const IMInstance = useRecoilValue(BytedIMInstance);

  useEffect(() => {
    IMInstance?.getMessageReferenceList({ message }).then(list => {
      setMessageList(list);
    });
  }, [message]);

  return (
    <Container>
      <div className="reply-list-head">
        <div className="title-container">详情页</div>
        <div className="tool-group">
          <div className="tool-item" onClick={handleClose}>
            <Tooltip content="退出" position="bottom">
              <div>
                <IconClose />
              </div>
            </Tooltip>
          </div>
        </div>
      </div>

      <div className="reply-list-body">
        <div className="message-list-container">
          {messageList.map((item, index) => (
            <MessageItem message={item} index={index} key={item?.serverId ?? index} messageLen={messageList.length} />
          ))}
        </div>
      </div>
    </Container>
  );
};

export default ReplyList;
