import React, { FC, useMemo } from 'react';
import classNames from 'classnames';
import { Tooltip } from '@arco-design/web-react';
import { Conversation } from '@volcengine/im-web-sdk';
import { useRecoilState, useRecoilValue } from 'recoil';

import { Avatar } from '../..';
import { IconHumanSet, IconDelete } from '../../Icon';
import { ACCOUNTS_INFO, ROLE } from '../../../constant';

import GroupSearchModalBox from './Styles';
import { CurrentConversation, Participants } from '../../../store';

interface GroupSearchModalProps {
  currentConversation?: Conversation;
  role: number;
  ownUserId: string;
  removeGroupParticipants: (conversationId: string, userId: string[]) => void;
  updateGroupParticipant: (conversationId: string, userId: string, config?: any) => void;
}

const sortMember = participants => {
  const groupOwner = participants.filter(item => item.role === ROLE.Owner);
  const groupManager = participants.filter(item => item.role === ROLE.Manager);
  const groupMember = participants.filter(item => ![ROLE.Owner, ROLE.Manager].includes(item.role));
  return [...groupOwner, ...groupManager, ...groupMember];
};

const GroupMemberManageModal: FC<GroupSearchModalProps> = props => {
  const { removeGroupParticipants, role, updateGroupParticipant, ownUserId } = props;
  const [participants, setParticipants] = useRecoilState(Participants);
  const currentConversation = useRecoilValue(CurrentConversation);
  const { id } = currentConversation;

  const isOwner = useMemo(() => role === ROLE.Owner, [role]);
  const isManager = useMemo(() => role === ROLE.Manager, [role]);

  const handleRoleChange = (userId, role) => {
    const participant = participants.find(item => item.userId === userId);
    participant.role = role;
    setParticipants([...participants]);

    updateGroupParticipant(id, userId, {
      role,
    });
  };

  const handleMemberDelete = userId => {
    const newParticipants = participants.filter(item => item.userId !== userId);

    setParticipants([...newParticipants]);
    removeGroupParticipants(id, [userId]);
  };

  const renderGroupOptions = (userId: string, role: number) => {
    const GroupOptions = [
      {
        key: 'GroupOptions_1',
        icon: <IconHumanSet />,
        className: 'group-option-icon-humanSet',
        tipText: '设为群管理员',
        handleClick: () => {
          handleRoleChange(userId, ROLE.Manager);
        },
        visible: isOwner && role !== ROLE.Manager,
      },
      {
        key: 'GroupOptions_2',
        icon: <IconHumanSet />,
        className: 'group-option-icon-humanSet',
        tipText: '取消群管理员',
        handleClick: () => {
          handleRoleChange(userId, ROLE.Normal);
        },
        visible: isOwner && role === ROLE.Manager,
      },
      {
        key: 'GroupOptions_4',
        icon: <IconDelete />,
        className: 'group-option-icon-delete',
        tipText: '删除群成员',
        handleClick: () => {
          handleMemberDelete(userId);
        },
        visible: isOwner || (isManager && role === ROLE.Normal),
      },
    ];

    return GroupOptions.map(
      item =>
        item.visible && (
          <Tooltip key={item.key} content={item.tipText} position="top">
            <span className={classNames('group-option-icon', item.className)} onClick={item.handleClick} data-id={id}>
              {item.icon}
            </span>
          </Tooltip>
        )
    );
  };

  return (
    <GroupSearchModalBox>
      <div className="search-member-list">
        {sortMember(participants).map(item => (
          <div className="group-auth-item" key={item.userId.toString()}>
            <div className="group-auth-avatar">
              <Avatar size={32} url={ACCOUNTS_INFO[item.userId]?.url} />
            </div>
            <div className="group-auth-item-info">
              <div className="group-auth-username">{ACCOUNTS_INFO[item.userId]?.name}</div>
              {item.userId.toString() === ownUserId && <div className="group-title-tag group-my-title">我</div>}
              {item.role === ROLE.Owner && <div className="group-title-tag group-owner-title">群主</div>}
              {item.role === ROLE.Manager && <div className="group-title-tag group-manager-title">群管理员</div>}
            </div>
            {isOwner && item.userId.toString() !== ownUserId && (
              <div className="group-auth-options">{renderGroupOptions(item.userId.toString(), item.role)}</div>
            )}
          </div>
        ))}
      </div>
    </GroupSearchModalBox>
  );
};

export default GroupMemberManageModal;
