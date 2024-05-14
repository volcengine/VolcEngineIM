import React, { FC, useCallback } from 'react';
import { Select, Tooltip } from '@arco-design/web-react';
import { IconAt } from '@arco-design/web-react/icon';

import IconButtonMask from '../../IconButtonMask';
import { useAccountsInfo } from '../../../hooks';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation } from '../../../store';
import { im_proto } from '@volcengine/im-web-sdk';

interface MentionButtonProps {
  isSimple: boolean;
  suggestions: any;
  editor?: HTMLTextAreaElement;
}

const MentionButton: FC<MentionButtonProps> = props => {
  const { isSimple, suggestions, editor } = props;
  const ACCOUNTS_INFO = useAccountsInfo();
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  return (
    <Select
      value={''}
      defaultActiveFirstOption={false}
      onChange={value => {
        editor.value += '@' + ACCOUNTS_INFO[value].realName;
        if (currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
          bytedIMInstance.sendP2PMessage({
            conversation: currentConversation,
            sendType: im_proto.SendType.BY_CONVERSATION,
            msgType: im_proto.MessageType.MESSAGE_TYPE_CUSTOM_P2P,
            content: JSON.stringify({
              type: 1000,
              ext: '',
              message_type: im_proto.MessageType.MESSAGE_TYPE_TEXT,
            }),
          });
        }
      }}
      triggerProps={{
        position: 'tl',
        autoAlignPopupWidth: false,
      }}
      triggerElement={
        <Tooltip
          position="top"
          content={
            <>
              <div>提及成员</div>
            </>
          }
        >
          <div className="toolbar-item">
            <IconButtonMask>
              <IconAt style={{ fontSize: '20px' }} />
            </IconButtonMask>
          </div>
        </Tooltip>
      }
    >
      {suggestions?.map(i => (
        <Select.Option value={i.id} key={i.id}>
          {i.username}
        </Select.Option>
      ))}
    </Select>
  );
};

export default MentionButton;
