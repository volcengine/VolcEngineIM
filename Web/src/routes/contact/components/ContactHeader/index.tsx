import React, { FC, useCallback, useState } from 'react';

import HeaderBox from './Styles';
import { Button, Form, Input, Message, Modal, Select } from '@arco-design/web-react';
import { IconMessageBanned, IconUserAdd, IconUserGroup } from '@arco-design/web-react/icon';
import CreateConversationModel from '../../../../components/ConversationModal/OneOne';
import { useRecoilState } from 'recoil';
import { BytedIMInstance } from '../../../../store';
import { im_proto } from '@volcengine/im-web-sdk';

interface ConversationHeaderProps {}

export const ContactHeader: FC<ConversationHeaderProps> = props => {
  const [showAddFriendModal, setShowAddFriendModal] = useState(false);
  const [showAddBlackModal, setShowAddBlackModal] = useState(false);
  const [bytedIMInstance, setBytedIMInstance] = useRecoilState(BytedIMInstance);

  return (
    <HeaderBox>
      <Button.Group>
        <Button
          type="primary"
          icon={<IconUserAdd />}
          onClick={() => {
            setShowAddFriendModal(true);
          }}
        >
          添加好友
        </Button>
        <Button
          icon={<IconMessageBanned />}
          onClick={() => {
            setShowAddBlackModal(true);
          }}
        >
          添加黑名单
        </Button>
      </Button.Group>
      {showAddFriendModal && (
        <CreateConversationModel
          title={'添加好友'}
          hint={'请输入 UID'}
          emptyUidMessage={'请输入 UID'}
          notExistUidMessage={'UID 不存在，请重新输入'}
          onClose={() => setShowAddFriendModal(false)}
          onCreate={async inputUserId => {
            try {
              const resp = await bytedIMInstance.applyFriend({
                userId: inputUserId,
                ext: { demo_from_web: 'applyFriend' },
              });
              if (resp) {
                Message.success('发送好友申请成功');
                return true;
              } else {
                Message.error('发送好友申请失败，请稍后重试');
                return false;
              }
            } catch (e) {
              switch (e.type) {
                case im_proto.StatusCode.IS_FRIEND:
                  Message.error('TA 已经是你的好友，请重新输入');
                  break;
                case im_proto.StatusCode.FRIEND_MORE_THAN_LIMIT:
                  Message.error('已超出好友数量上限');
                  break;
                case im_proto.StatusCode.ADD_SELF_FRIEND_NOT_ALLOW:
                  Message.error('自己不能添加自己为好友');
                  break;
                case im_proto.StatusCode.DUPLICATE_APPLY:
                  Message.error('已发送过好友申请，请等待对方处理');
                  break;
                case im_proto.StatusCode.FROM_USER_FRIEND_MORE_THAN_LIMIT:
                  Message.error('操作失败，对方的好友数量已到上限');
                  break;
                default:
                  Message.error(`发送好友申请失败: ${e.msg} ${e.logid}`);
                  break;
              }
              return false;
            }
          }}
        ></CreateConversationModel>
      )}
      {showAddBlackModal && (
        <CreateConversationModel
          title={'添加黑名单'}
          hint={'请输入 UID'}
          onClose={() => setShowAddBlackModal(false)}
          onCreate={async inputUserId => {
            try {
              const resp = await bytedIMInstance.addUserToBlack({
                userIds: [inputUserId],
                ext: { demo_from_web: 'addUserToBlack' },
              });
              if (resp) {
                if (resp.failedInfos.length) {
                  Message.error(getErrorMessage(resp.failedInfos[0].failedCode));
                  return false;
                }
                Message.success('操作成功');
                return true;
              } else {
                Message.error('添加黑名单失败，请稍后重试');
                return false;
              }
            } catch (e) {
              Message.error(getErrorMessage(e.type));

              return false;
            }
          }}
        ></CreateConversationModel>
      )}
    </HeaderBox>
  );
};

function getErrorMessage(type: number) {
  switch (type) {
    case im_proto.StatusCode.AlREADY_IN_BLACK:
      return 'TA 已经被你拉黑，请重新输入';
    case im_proto.StatusCode.BLACK_MORE_THAN_LIMIT:
      return '已超出黑名单数量上限';
    case im_proto.StatusCode.ADD_SELF_BLACK_NOT_ALLOW:
      return '不能自己拉黑自己';
    default:
      return `添加黑名单失败`;
  }
}
