import React, { FC, useEffect, useMemo, useRef, useState } from 'react';
import classNames from 'classnames';
import { Button, Input, Popover, Radio, Select, Space, Tooltip } from '@arco-design/web-react';
import { IconDelete, IconEdit, IconStop, IconSync } from '@arco-design/web-react/icon';
import { useRecoilState, useRecoilValue } from 'recoil';

import { Avatar, ProfilePopover } from '../../../../../components';
import { ROLE } from '../../../../../constant';
import { BytedIMInstance, CurrentConversation, UserId } from '../../../../../store';

import GroupSearchModalBox from './Styles';
import { useAccountsInfo, useParticipant } from '../../../../../hooks';
import { IconHumanSet } from '../../../../../components/Icon';
import { uniqBy } from 'lodash';
import { Participant } from '@volcengine/im-web-sdk';
import { useRequest } from 'ahooks';
import LiveParticipantInfoModel from '../../../../../components/ConversationModal/LiveParticipantInfo';

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
    admin: ['mute', 'delete', 'setManager'], // 屏蔽 'setAlias'
    normal: ['mute', 'delete', 'setManager'], // 屏蔽 'setAlias'
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

export function MemberNameDisplay({
  offlineParticipant,
  participant,
  markFilter,
}: {
  participant: Participant;
  offlineParticipant: boolean;
  markFilter?: string;
}) {
  const ACCOUNTS_INFO = useAccountsInfo();
  const userId = useRecoilValue(UserId);
  let isItemSelf = participant.userId === userId;
  let avatarUrl = participant.avatarUrl || ACCOUNTS_INFO[participant.userId]?.url;

  let realName = ACCOUNTS_INFO[participant.userId]?.realName;
  let displayName = ACCOUNTS_INFO[participant.userId]?.hasFriendAlias
    ? ACCOUNTS_INFO[participant.userId]?.name
    : participant.alias || realName;

  return (
    <>
      <div className="group-auth-avatar">
        <ProfilePopover userId={participant.userId}>
          {avatarUrl ? <Avatar size={32} url={avatarUrl} /> : <i>无头像</i>}
        </ProfilePopover>
      </div>
      <div className="group-auth-item-info">
        <div className="group-auth-username">{displayName}</div>

        {isItemSelf && <div className="group-title-tag group-my-title">我</div>}
        {participant.alias && (
          <Tooltip content={realName}>
            <div className="group-title-tag group-with-alias">昵称</div>
          </Tooltip>
        )}
        {participant.role === ROLE.Owner && (
          <>
            <div className="group-title-tag group-owner-title">群主</div>
            {!offlineParticipant && <div className="group-title-tag group-online-title">在线</div>}
          </>
        )}
        {participant.role === ROLE.Manager && (
          <>
            <div className="group-title-tag group-manager-title">群管理员</div>
            {!offlineParticipant && <div className="group-title-tag group-online-title">在线</div>}
          </>
        )}
        {offlineParticipant && <div className="group-title-tag group-offline-title">离线</div>}
        {participant.marks?.length ? (
          <Tooltip content={participant.marks.join(',')}>
            <div className="group-title-tag group-offline-title">
              {participant.marks.includes(markFilter) ? markFilter : participant.marks[0]}
            </div>
          </Tooltip>
        ) : null}
      </div>
    </>
  );
}

export const GroupMemberListModal: FC<GroupSearchModalProps> = props => {
  const currentConversation = useRecoilValue(CurrentConversation);
  const userId = useRecoilValue(UserId);

  const [participants, setParticipants] = useState<Participant[]>([]);
  const [managerParticipants, setManagerParticipants] = useState<Participant[]>([]);

  const [muteSettingIndex, setMuteSettingIndex] = useState(-1);
  const [muteTime, setMuteTime] = useState(muteTimeOptions[0]);
  const [isEditInfo, setIsEditInfo] = useState<Participant>(null);
  const input = useRef(null);

  const self = useMemo(() => participants.find(p => p.userId === userId), [participants]);
  const selfPermissionKey = calcPermissionKey(self);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

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
      loadingDelay: 200,
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

  const { data } = useRequest(
    async () => {
      return bytedIMInstance.getLiveConversationMarksOnline({ conversation: currentConversation });
    },
    {
      refreshOnWindowFocus: true,
    }
  );
  const [markFilter, setMarkFilter] = useState('');
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
      <Radio.Group
        options={[
          {
            value: '',
            label: '全部',
          },
          ...(data?.markTypes?.sort()?.map(i => ({
            value: i,
            label: i,
          })) ?? []),
        ]}
        size="mini"
        type="button"
        value={markFilter}
        onChange={setMarkFilter}
        style={{ marginBottom: 20 }}
      />
      {sortParticipants
        .filter(i => !markFilter || i.marks?.includes(markFilter))
        .map((item, index) => {
          const itemUid = item.userId;

          let isOfflineParticipant = !participants.find(i => i.userId === item.userId);
          let isItemSelf = itemUid === userId;
          let itemPermissionKey = calcPermissionKey(item);
          let allows = OperatePermissionMap[selfPermissionKey][itemPermissionKey];

          let isInSettingMute = muteSettingIndex === index;

          return (
            <div className="member-item-wrapper" key={itemUid}>
              <div className="group-auth-item">
                <MemberNameDisplay
                  participant={item}
                  offlineParticipant={isOfflineParticipant}
                  markFilter={markFilter}
                />

                <div className="group-auth-options">
                  {isItemSelf && (
                    <Tooltip content="修改成员资料" position="top">
                      <span
                        className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                        onClick={() => {
                          setIsEditInfo(item);
                        }}
                      >
                        <IconEdit />
                      </span>
                    </Tooltip>
                  )}

                  {!isItemSelf && (
                    <>
                      {allows.includes('setAlias') && (
                        <Tooltip content="修改成员资料" position="top">
                          <span
                            className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                            onClick={() => {
                              setIsEditInfo(item);
                            }}
                          >
                            <IconEdit />
                          </span>
                        </Tooltip>
                      )}

                      {item.blocked ? (
                        <Popover
                          content={
                            <>
                              {Number(item.leftBlockTime) === -1 ? '永久禁言' : `已被禁言, 剩余${item.leftBlockTime}s`}
                              {allows.includes('mute') && (
                                <Button
                                  size={'mini'}
                                  onClick={async () => {
                                    await setParticipantMuteTime({
                                      memberIds: item.userId,
                                      block: false,
                                    });
                                    getList();
                                  }}
                                >
                                  解除
                                </Button>
                              )}
                            </>
                          }
                          position="top"
                        >
                          <span className={classNames('group-option-icon', 'group-option-icon-humanSet')}>
                            <IconStop style={{ color: '#f00' }} />
                          </span>
                        </Popover>
                      ) : (
                        allows.includes('mute') && (
                          <Popover
                            content={
                              <div className="mute-wrapper">
                                <Select
                                  style={{ width: 120 }}
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

                                <Button type="primary" size="small" onClick={handleMemberMute}>
                                  确定
                                </Button>
                                <Button
                                  size="small"
                                  onClick={() => {
                                    setMuteSettingIndex(-1);
                                  }}
                                >
                                  取消
                                </Button>
                              </div>
                            }
                            popupVisible={isInSettingMute}
                            position="top"
                          >
                            <span
                              className={classNames('group-option-icon', 'group-option-icon-humanSet')}
                              onClick={() => {
                                setMuteSettingIndex(isInSettingMute ? -1 : index);
                              }}
                            >
                              <IconStop />
                            </span>
                          </Popover>
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
                    </>
                  )}
                </div>

                {muteSettingIndex > -1 && isInSettingMute && <></>}
              </div>
            </div>
          );
        })}
      {isEditInfo && (
        <LiveParticipantInfoModel
          userId={isEditInfo.userId}
          initAlias={isEditInfo.alias}
          initAvatarUrl={isEditInfo.avatarUrl}
          onClose={() => setIsEditInfo(null)}
          onSubmit={async value => {
            await updateGroupParticipant(currentConversation.id, isEditInfo.userId, {
              ...value,
            });
            await getList();
            return true;
          }}
        ></LiveParticipantInfoModel>
      )}
    </GroupSearchModalBox>
  );
};
