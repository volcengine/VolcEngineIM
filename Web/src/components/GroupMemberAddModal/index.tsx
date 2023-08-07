import { Form, Transfer } from '@arco-design/web-react';
import React, { FC, useState, useEffect } from 'react';
import { useRecoilValue } from 'recoil';
import { ACCOUNTS_INFO } from '../../constant';

import { CurrentConversation, Participants } from '../../store';
import { UserIdsInput } from '../ConversationModal/Group';

interface GroupMemberAddModalProps {
  setSelectedParticipant?: (p) => void;
}

const GroupMemberAddModal: FC<GroupMemberAddModalProps> = React.forwardRef(props => {
  const { setSelectedParticipant } = props;
  const [groupIds, setGroupIds] = useState<string[]>([]);

  return (
    <Form>
      <Form.Item label={'添加群成员'}>
        <UserIdsInput
          groupIds={groupIds}
          setGroupIds={v => {
            setGroupIds(v);
            setSelectedParticipant(v);
          }}
        ></UserIdsInput>
      </Form.Item>
    </Form>
  );
});

export default GroupMemberAddModal;
