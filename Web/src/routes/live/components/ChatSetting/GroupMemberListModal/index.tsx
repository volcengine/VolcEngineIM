import React, { FC, useEffect, useMemo, useRef, useState } from 'react';
import classNames from 'classnames';
import { Button, Input, Select, Space, Tooltip } from '@arco-design/web-react';
import { IconDelete, IconEdit, IconStop, IconSync } from '@arco-design/web-react/icon';
import { useRecoilState, useRecoilValue } from 'recoil';

import { Avatar } from '../../../../../components';
import { ACCOUNTS_INFO, ROLE } from '../../../../../constant';
import { CurrentConversation, LiveConversationNickName, UserId } from '../../../../../store';

import GroupSearchModalBox from './Styles';
import { useParticipant } from '../../../../../hooks';
import { IconHumanSet } from '../../../../../components/Icon';
import { uniqBy } from 'lodash';
import { Participant } from '@volcengine/im-web-sdk';
import { useRequest } from 'ahooks';

const Option = Select.Option;
const muteTimeOptions = [
  {
    label: '永久禁言',
    value: 0,
  },
  {
    label: '5分钟',
    value: 5 * 60,
  },
  {
    label: '1小时',
    value: 60 * 60,
  },
];

interface GroupSearchModalProps {}

const sortMember = (participants: Participant[], managerParticipants: Participant[], selfId: string) => {
  return uniqBy([...participants, ...managerParticipants], item => item.userId).sort((a, b) => {
    if (a.userId === selfId) {
      return -1;
    }
    if (b.userId === selfId) return 1;

    const roleSeq = [ROLE.Normal, ROLE.Manager, ROLE.Owner];
    if (a.role !== b.role) return roleSeq.indexOf(b.role) - roleSeq.indexOf(a.role);

    if (a.userId < b.userId) {
      return -1;
    }
    if (a.userId > b.userId) {
      return 1;
    }
    return 0;
  });
};
const OperatePermissionMap: Record<Keys, Record<Keys, string[]>> = {
  owner: {
    owner: [],
    admin: ['mute', 'delete', 'setManager'],
    normal: ['mute', 'delete', 'setManager'],
  },
  admin: {
    owner: [],
    admin: [],
    normal: ['mute', 'delete'],
  },
  normal: {
    owner: [],
    admin: [],
    normal: [],
  },
};

type Keys = 'owner' | 'admin' | 'normal';

function calcPermissionKey(p: Participant): Keys {
  return p ? (p.role === ROLE.Owner ? 'owner' : p.role === ROLE.Manager ? 'admin' : 'normal') : 'normal';
}
export const GroupMemberListModal: FC<GroupSearchModalProps> = props => {
  const [liveConversationNickName, setLiveConversationNickName] = useRecoilState(LiveConversationNickName);
  const currentConversation = useRecoilValue(CurrentConversation);
  const userId = useRecoilValue(UserId);

  const [participants, setParticipants] = useState<Participant[]>([]);
  const [managerParticipants, setManagerParticipants] = useState<Participant[]>([]);

  const [muteSettingIndex, setMuteSettingIndex] = useState(-1);
  const [muteTime, setMuteTime] = useState(muteTimeOptions[0]);
  const [isEditName, setEditName] = useState(false);
  const [nickname, setNickName] = useState(liveConversationNickName);
  const input = useRef(null);

  const self = useMemo(() => participants.find(p => p.userId === userId), [participants]);
  const selfPermissionKey = calcPermissionKey(self);

  const {
    getParticipantsOnline,
    getLiveParticipantsOnline,
    removeLiveGroupParticipants,
    setParticipantMuteTime,
    updateGroupParticipant,
  } = useParticipant();

  const sortParticipants = sortMember(participants, managerParticipants, userId);

  const handleMemberDelete = async userId => {
    await removeLiveGroupParticipants(currentConversation, [userId]);

    getList();
  };

  const handleMemberMute = async () => {
    const participant = sortParticipants[muteSettingIndex];

    await setParticipantMuteTime({
      memberIds: participant.userId,
      blockTime: muteTime,
      block: true,
    });

    setMuteSettingIndex(-1);

    getList();
  };

  const updateNickName = () => {
    setLiveConversationNickName(nickname);
    setEditName(false);
  };

  const { run: getList, loading } = useRequest(
    async () => {
      try {
        let hasMore = true;
        let cursor;
        let list = [];
        while (hasMore) {
          const result = await getLiveParticipantsOnline(50, cursor);
          hasMore = result.hasMore;
          cursor = result.cursor;
          list = list.concat(result.participants);
        }
        setParticipants(list);
        const managerResult = await getParticipantsOnline(50, 0);
        setManagerParticipants(managerResult.participants);
      } catch (err) {}
    },
    {
      refreshOnWindowFocus: true,
    }
  );

  const [inputId, setInputId] = useState('');
  const handleAdd = (userId: string) => {
    if (!userId) {
      return;
    }
    updateGroupParticipant(currentConversation.id, userId, {
      role: ROLE.Manager,
    }).then(() => getList());
    return true;
  };
  return (
    <GroupSearchModalBox>
      <div className="form-item">
        {selfPermissionKey === 'owner' && (
          <Input
            className="input-wrapper"
            type="text"
            placeholder="输入用户ID添加管理员"
            showWordLimit
            value={inputId}
            onChange={value => {
              setInputId(value.replace(/\D/g, ''));
            }}
          />
        )}

        {selfPermissionKey === 'owner' && (
          <Button className="btn" type="primary" size="small" onClick={() => handleAdd(inputId) && setInputId('')}>
            添加
          </Button>
        )}
        <Button className="btn" size="small" loading={loading} onClick={() => getList()}>
          刷新
        </Button>
      </div>

      {sortParticipants.map((item, index) => {
        const itemUid = item.userId;

        let isOfflineParticipant = !participants.find(i => i.userId === item.userId);
        let isItemSelf = itemUid === userId;
        let itemPermissionKey = calcPermissionKey(item);
        let allows = OperatePermissionMap[selfPermissionKey][itemPermissionKey];
        return (
          <div className="member-item-wrapper" key={itemUid}>
            <div className="group-auth-item">
              <div className="group-auth-avatar">
                {ACCOUNTS_INFO[item.userId]?.url ? (
                  <Avatar size={32} url={ACCOUNTS_INFO[item.userId]?.url} />
                ) : (
                  <i>无头像</i>
                )}
              </div>

              <div className="group-auth-item-info">
                {isEditName && itemUid === userId ? (
                  <Input
                    ref={ref => (input.current = ref)}
                    style={{ width: 150 }}
                    allowClear
                    placeholder="请输入昵称"
                    size="small"
                    onChange={value => setNickName(value)}
                    onPressEnter={updateNickName}
                    onBlur={updateNickName}
                  />
                ) : (
                  <div className="group-auth-username">
                    {itemUid === userId && liveConversationNickName
                      ? liveConversationNickName
                      : ACCOUNTS_INFO[item.userId]?.name || item.userId}
                  </div>
                )}

                {itemUid === userId && <div className="group-title-tag group-my-title">我</div>}
                {item.role === ROLE.Owner && (
                  <>
                    <div className="group-title-tag group-owner-title">群主</div>
                    {!isOfflineParticipant && <div className="group-title-tag group-online-title">在线</div>}
                  </>
                )}
                {item.role === ROLE.Manager && (
                  <>
                    <div className="group-title-tag group-manager-title">群管理员</div>
                    {!isOfflineParticipant && <div className="group-title-tag group-online-title">在线</div>}
                  </>
                )}
                {isOfflineParticipant && <div className="group-title-tag group-offline-title">离线</div>}
              </div>

              {!isItemSelf && (
                <div className="group-auth-options">
                  {itemUid === userId && (
                    <Tooltip content="修改昵称 (发消息时生效)" position="top">
                      <span
                        className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                        onClick={() => {
                          setEditName(true);
                        }}
                      >
                        <IconEdit />
                      </span>
                    </Tooltip>
                  )}

                  {item.blocked ? (
                    <Tooltip
                      content={Number(item.leftBlockTime) === -1 ? '永久禁言' : `已被禁言, 剩余${item.leftBlockTime}s`}
                      position="top"
                    >
                      <span className={classNames('group-option-icon', 'group-option-icon-humanSet')}>
                        <IconStop style={{ color: '#f00' }} />
                      </span>
                    </Tooltip>
                  ) : (
                    allows.includes('mute') && (
                      <Tooltip content="禁言" position="top">
                        <span
                          className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                          onClick={() => {
                            setMuteSettingIndex(muteSettingIndex === index ? -1 : index);
                          }}
                        >
                          <IconStop />
                        </span>
                      </Tooltip>
                    )
                  )}

                  {allows.includes('setManager') && (
                    <>
                      {item.role !== ROLE.Manager ? (
                        <Tooltip content="设为群管理员" position="top">
                          <span
                            className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                            onClick={() => {
                              updateGroupParticipant(currentConversation.id, item.userId, {
                                role: ROLE.Manager,
                              }).then(() => getList());
                            }}
                          >
                            <IconHumanSet />
                          </span>
                        </Tooltip>
                      ) : (
                        <Tooltip content="取消群管理员" position="top">
                          <span
                            className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                            onClick={() => {
                              updateGroupParticipant(currentConversation.id, item.userId, {
                                role: ROLE.Normal,
                              }).then(() => getList());
                            }}
                          >
                            <IconHumanSet />
                          </span>
                        </Tooltip>
                      )}
                    </>
                  )}

                  {allows.includes('delete') && !isOfflineParticipant && (
                    <Tooltip content="删除群成员" position="top">
                      <span
                        className={classNames('group-option-icon', 'group-option-icon-delete')}
                        onClick={() => {
                          handleMemberDelete(item.userId);
                        }}
                      >
                        <IconDelete />
                      </span>
                    </Tooltip>
                  )}
                </div>
              )}
            </div>

            {muteSettingIndex > -1 && index === muteSettingIndex && (
              <div className="mute-wrapper">
                <Select
                  style={{ width: 154 }}
                  size="small"
                  defaultValue="永久禁言"
                  onChange={value => setMuteTime(value)}
                >
                  {muteTimeOptions.map((option, index) => (
                    <Option key={option.label} value={option.value}>
                      {option.label}
                    </Option>
                  ))}
                </Select>

                <div className="btn-wrapper" onClick={handleMemberMute}>
                  <Button type="primary" size="small">
                    确定
                  </Button>
                </div>
              </div>
            )}
          </div>
        );
      })}
    </GroupSearchModalBox>
  );
};
