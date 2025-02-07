import React, { FC, useImperativeHandle, useRef, useState } from 'react';
import { Button, Form, Input, InputTag, List, Message, Select, Space, Switch } from '@arco-design/web-react';

import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation } from '../../../../../store';
import { useRequest } from 'ahooks';
import { UserIdsInput } from '../../../../../components/ConversationModal/Group';
import { im_proto } from '@volcengine/im-web-sdk';

interface MarkUserModalProps {
  onClose: () => void;
}

const MarkUserModal: FC<MarkUserModalProps> = React.forwardRef((props, ref) => {
  const [groupIds, setGroupIds] = useState([]);
  const [marks, setMarks] = useState([]);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const { loading, data, runAsync } = useRequest(
    async (mode: im_proto.MarkAction, useInt64?: boolean) => {
      console.log(groupIds, marks);
      if (groupIds.length) {
        return bytedIMInstance.updateLiveParticipantsMarks({
          markAction: mode,
          conversation: currentConversation,
          participantIds: groupIds,
          markTypes: marks,
          useInt64: useInt64,
        });
      } else {
        return bytedIMInstance.updateLiveConversationMarks({
          conversation: currentConversation,
          markAction: mode,
          markTypes: marks,
        });
      }
    },
    { manual: true }
  );

  const { data: marksData } = useRequest(
    async () => {
      return bytedIMInstance.getLiveConversationMarksOnline({ conversation: currentConversation });
    },
    {
      refreshOnWindowFocus: true,
    }
  );

  return (
    <Form>
      <Form.Item label="用户" field="marks">
        <UserIdsInput groupIds={groupIds} setGroupIds={setGroupIds} disabled={loading}></UserIdsInput>
      </Form.Item>
      <Form.Item label="标记" field="marks">
        <Select
          allowCreate
          placeholder={'输入标记类型'}
          onChange={v => setMarks(v)}
          disabled={loading}
          mode={'multiple'}
          tokenSeparators={[',']}
        >
          {marksData?.markTypes?.map(v => (
            <Select.Option key={v} value={v}>
              {v}
            </Select.Option>
          ))}
        </Select>
      </Form.Item>
      <Space style={{ justifyContent: 'end' }}>
        <Button
          status={'danger'}
          loading={loading}
          onClick={async () => {
            try {
              await runAsync(im_proto.MarkAction.DELETE, true);
              Message.success('删除标记成功');
              props.onClose();
            } catch (e) {
              if (e.type === im_proto.StatusCode.CONVERSATION_MARK_TYPE_MORE_THAN_LIMIT)
                Message.error('标记数量超过限制');
              else Message.error(e.msg);
            }
          }}
          disabled={!marks.length}
        >
          删除标记
        </Button>
        <Button
          status={'danger'}
          loading={loading}
          onClick={async () => {
            try {
              await runAsync(im_proto.MarkAction.DELETE);
              Message.success('删除标记成功');
              props.onClose();
            } catch (e) {
              if (e.type === im_proto.StatusCode.CONVERSATION_MARK_TYPE_MORE_THAN_LIMIT)
                Message.error('标记数量超过限制');
              else Message.error(e.msg);
            }
          }}
          disabled={!marks.length}
        >
          string ID 删除标记
        </Button>

        <Button
          type={'primary'}
          status={'default'}
          loading={loading}
          onClick={async () => {
            try {
              await runAsync(im_proto.MarkAction.ADD, true);
              Message.success('添加标记成功');
              props.onClose();
            } catch (e) {
              if (e.type === im_proto.StatusCode.CONVERSATION_MARK_TYPE_MORE_THAN_LIMIT)
                Message.error('标记数量超过限制');
              else Message.error(e.msg);
            }
          }}
          disabled={!marks.length}
        >
          添加标记
        </Button>
        <Button
          type={'primary'}
          status={'default'}
          loading={loading}
          onClick={async () => {
            try {
              await runAsync(im_proto.MarkAction.ADD);
              Message.success('添加标记成功');
              props.onClose();
            } catch (e) {
              if (e.type === im_proto.StatusCode.CONVERSATION_MARK_TYPE_MORE_THAN_LIMIT)
                Message.error('标记数量超过限制');
              else Message.error(e.msg);
            }
          }}
          disabled={!marks.length}
        >
          stringId 添加标记
        </Button>
      </Space>
    </Form>
  );
});

export default MarkUserModal;
