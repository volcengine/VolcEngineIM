import React, { FC, useImperativeHandle, useRef, useState } from 'react';
import { Button, Form, Input, List, Message } from '@arco-design/web-react';

import styles from './index.module.scss';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation } from '../../../../../store';
import { useRequest } from 'ahooks';
import dayjs from 'dayjs';
import { UserIdsInput } from '../../../../../components/ConversationModal/Group';

interface GroupQueryUserInfoModalProps {}

const GroupQueryUserInfoModal: FC<GroupQueryUserInfoModalProps> = React.forwardRef((props, ref) => {
  const [groupIds, setGroupIds] = useState([]);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const { loading, data, run, mutate } = useRequest(
    () => {
      return bytedIMInstance.getLiveParticipantInfoOnline({
        participantIds: groupIds,
        conversation: currentConversation,
      });
    },
    { manual: true }
  );

  console.log(data);
  return data ? (
    <div>
      <List
        height={300}
        size="small"
        dataSource={groupIds}
        render={(id, index) => {
          const item = data[id];
          return (
            <List.Item key={index}>
              <div className={styles['user-list-line']}>
                <div>{id}</div>
                {item ? (
                  <div>
                    {item.is_in_conversation ? (
                      `${dayjs(item.create_time.toNumber()).format('YYYY-MM-DD HH:mm:ss')}进群 在群`
                    ) : (
                      <span style={{ color: 'gray' }}>不在群</span>
                    )}
                  </div>
                ) : (
                  <div style={{ color: 'gray' }}>不在群</div>
                )}
              </div>
            </List.Item>
          );
        }}
      />

      <div style={{ marginTop: 20, display: 'flex', justifyContent: 'end' }}>
        <Button type={'primary'} onClick={() => mutate(undefined)}>
          返回
        </Button>
      </div>
    </div>
  ) : (
    <div>
      <UserIdsInput groupIds={groupIds} setGroupIds={setGroupIds} disabled={loading}></UserIdsInput>
      <div style={{ marginTop: 20, display: 'flex', justifyContent: 'end' }}>
        <Button type={'primary'} loading={loading} onClick={() => run()} disabled={!groupIds.length}>
          查询
        </Button>
      </div>
    </div>
  );
});

export default GroupQueryUserInfoModal;
