import React, { FC, useEffect, useState } from 'react';
import classNames from 'classnames';
import { Button, Input, Tooltip } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';

import { Avatar } from '../../../../../components';
import { ROLE } from '../../../../../constant';
import { CurrentConversation, LiveConversationOwner, UserId } from '../../../../../store';

import GroupSearchModalBox from './Styles';
import { IconDelete } from '@arco-design/web-react/icon';

import { useParticipant } from '../../../../../hooks';
import { useRequest } from 'ahooks';
import { MemberNameDisplay } from '../GroupMemberListModal';

interface GroupSearchModalProps {}

const sortMember = participants => {
  const groupOwner = participants.filter(item => item.role === ROLE.Owner);
  const groupManager = participants.filter(item => item.role === ROLE.Manager);
  const groupMember = participants.filter(item => ![ROLE.Owner, ROLE.Manager].includes(item.role));
  return [...groupOwner, ...groupManager, ...groupMember];
};

function useBlockList() {
  const { getBlockParticipantsOnline, setParticipantBlockTime } = useParticipant();
  const [participants, setParticipants] = useState([]);

  const requestHook = useRequest(
    async () => {
      let hasMore = true;
      let cursor;
      let list = [];
      while (hasMore) {
        const result = await getBlockParticipantsOnline(10, cursor);
        hasMore = result.hasMore ?? false;
        cursor = result.cursor;
        list = list.concat(result.participants);
      }
      setParticipants(list);
    },
    {
      refreshOnWindowFocus: true,
    }
  );
  const handleAddBlockUser = async (blockId: string, useString?: boolean) => {
    if (!blockId) {
      return;
    }
    const result = await setParticipantBlockTime({
      memberIds: blockId,
      blockTime: 3600,
      block: true,
      useString: useString,
    });
    void requestHook.run();
    return true;
  };

  const handleRemoveBlockUser = async (blockId, useString) => {
    console.log('handleRemoveBlockUser', blockId, useString);
    const result = await setParticipantBlockTime({
      memberIds: blockId,
      block: false,
      useString: useString,
    });
    requestHook.run();
  };

  return {
    handleAdd: handleAddBlockUser,
    handleRemove: handleRemoveBlockUser,
    participants,
    requestHook,
  };
}

function useMuteList() {
  const { getMuteParticipantsOnline, setParticipantMuteTime } = useParticipant();
  const [participants, setParticipants] = useState([]);

  const handleMemberAdd = async (userId: string, useStringId?: boolean) => {
    if (!userId) {
      return;
    }
    console.log('handleMemberAdd', useStringId);
    const result = await setParticipantMuteTime({
      memberIds: userId,
      blockTime: 3600,
      block: true,
      useString: useStringId,
    });
    void requestHook.run();
    return true;
  };

  const handleMemberDelete = async (userId, useStringId?: boolean) => {
    await setParticipantMuteTime({
      memberIds: userId,
      block: false,
      useStringId: useStringId,
    });
    requestHook.run();
  };

  const requestHook = useRequest(
    async () => {
      let hasMore = true;
      let cursor;
      let list = [];
      while (hasMore) {
        const result = await getMuteParticipantsOnline(10, cursor);
        hasMore = result.hasMore ?? false;
        cursor = result.cursor;
        list = list.concat(result.participants);
      }
      setParticipants(list);
    },
    {
      refreshOnWindowFocus: true,
    }
  );

  return {
    handleAdd: handleMemberAdd,
    handleRemove: handleMemberDelete,
    participants,
    requestHook,
  };
}

function useMuteWhiteList() {
  const { getLiveParticipantMuteWhiteListOnline, addLiveParticipantMuteWhiteList, removeLiveParticipantMuteWhiteList } =
    useParticipant();
  const [participants, setParticipants] = useState([]);

  const handleMemberAdd = async (userId, useString) => {
    if (!userId) {
      return;
    }
    const result = await addLiveParticipantMuteWhiteList([userId], useString);
    void requestHook.run();
    return true;
  };

  const handleMemberDelete = async (userId, useString) => {
    await removeLiveParticipantMuteWhiteList([userId], useString);
    requestHook.run();
  };

  const requestHook = useRequest(
    async () => {
      let hasMore = true;
      let cursor;
      let list = [];
      while (hasMore) {
        const result = await getLiveParticipantMuteWhiteListOnline(10, cursor);
        hasMore = result.hasMore ?? false;
        cursor = result.cursor;
        list = list.concat(result.participants);
      }
      setParticipants(list);
    },
    {
      refreshOnWindowFocus: true,
    }
  );

  return {
    handleAdd: handleMemberAdd,
    handleRemove: handleMemberDelete,
    participants,
    requestHook,
  };
}

const GroupSubListModalHoc =
  (x: {
    useListHook: () => {
      handleAdd: (memberId: string, useInt64?: boolean) => Promise<boolean>;
      handleRemove: (memberId: any, useInt64?: boolean) => Promise<void>;
      participants: any[];
      requestHook: ReturnType<typeof useRequest>;
    };
  }) =>
  props => {
    const currentConversation = useRecoilValue(CurrentConversation);
    const { id, coreInfo, userInfo } = currentConversation;
    const { owner } = coreInfo;
    const userId = useRecoilValue(UserId);
    const liveConversationOwner = useRecoilValue(LiveConversationOwner);
    const isManageable = userInfo.role === ROLE.Owner || userInfo.role === ROLE.Manager;

    const [inputId, setInputId] = useState('');

    const { participants, handleAdd, handleRemove, requestHook } = x.useListHook();

    let removeTooltip = '移除黑名单';

    return (
      <GroupSearchModalBox>
        {isManageable && (
          <div className="form-item">
            <Input
              className="input-wrapper"
              type="text"
              placeholder="请输入用户ID"
              showWordLimit
              value={inputId}
              onChange={value => {
                // setInputId(value.replace(/\D/g, ''));
                setInputId(value);
              }}
            />

            <Button className="btn" type="primary" size="small" onClick={() => handleAdd(inputId) && setInputId('')}>
              添加
            </Button>
            <Button
              className="btn"
              type="primary"
              size="small"
              onClick={() => handleAdd(inputId, true) && setInputId('')}
            >
              添加 stringUid
            </Button>
            <Button
              className="btn"
              size="small"
              loading={requestHook.loading}
              onClick={() => handleAdd(inputId) && setInputId('')}
            >
              刷新
            </Button>
          </div>
        )}

        {participants.length > 0 && (
          <div className="member-list-wrapper">
            {sortMember(participants).map((item, index) => {
              return (
                <div className="member-item-wrapper" key={item.userId.toString()}>
                  <div className="group-auth-item">
                    <MemberNameDisplay participant={item} offlineParticipant={false}></MemberNameDisplay>
                  </div>

                  {isManageable && (
                    <div className="group-auth-options">
                      <Tooltip content={removeTooltip} position="top">
                        <span
                          className={classNames('group-option-icon', 'group-option-icon-delete')}
                          onClick={() => {
                            console.log('11112233', handleRemove);
                            handleRemove(item.userId.toString());
                          }}
                          data-id={id}
                        >
                          <IconDelete />
                        </span>
                      </Tooltip>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </GroupSearchModalBox>
    );
  };

export const GroupBlockListModal = GroupSubListModalHoc({ useListHook: useBlockList });
export const GroupMuteListModal = GroupSubListModalHoc({ useListHook: useMuteList });
export const GroupMuteWhiteListModal = GroupSubListModalHoc({ useListHook: useMuteWhiteList });
