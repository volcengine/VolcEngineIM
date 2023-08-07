import React, { useState } from 'react';
import Container from './Style';
import { useConversation } from '../../hooks';
import { Button, Input, Message } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';
import { CurrentConversation, UserId } from '../../store';

const { TextArea } = Input;

const GroupNotice: React.FC = ({ }) => {
  const currentConversation = useRecoilValue(CurrentConversation);
  const { configGroupConversationCoreInfo } = useConversation();
  const userId = useRecoilValue(UserId);
  const {
    coreInfo: { notice, owner },
    id,
  } = currentConversation;
  const isOwner = owner === userId;
  const [text, setText] = useState(notice);

  const handleTextChange = async () => {
    try {
      await configGroupConversationCoreInfo(id, { notice: text });
    } catch (err) {
      Message.error('保存失败');
    }
  };

  const handleAreaChange = (value: string) => {
    setText(value);
  };

  return (
    <Container>
      <div className="group-notice-head">
        <div className="title-container">
          <div className="title-name">群公告</div>
        </div>
      </div>

      <div className="group-notice-body">
        <TextArea
          autoSize
          placeholder="请输入"
          style={{ minHeight: 100 }}
          maxLength={100}
          showWordLimit
          value={text}
          readOnly={!isOwner}
          onChange={handleAreaChange}
        />
        {isOwner && (
          <div className="notice-btn-wrapper">
            <Button className="notice-btn" type="primary" onClick={handleTextChange}>
              保存
            </Button>
          </div>
        )}
      </div>
    </Container>
  );
};

export default GroupNotice;
