import { useCallback, useState } from 'react';
import { View } from '@tarojs/components';

import ConversationItem from '../conversation-item';
import { AtActionSheet, AtActionSheetItem } from 'taro-ui';
import { useAppSelector } from '../../store/hooks';
import { selectIm } from '../../store/imReducers';

import './index.scss';
import { Conversation } from '@volcengine/im-mp-sdk';

interface ConversationListProps {
  conversationList: any[];
  onItemClick: (id) => void;
}

const ConversationList: React.FC<ConversationListProps> = ({ conversationList, onItemClick }) => {
  const instance = useAppSelector(selectIm);
  const [curConversation, setCurConversation] = useState(null);

  const selectConversation = useCallback((conversation: Conversation | null) => {
    console.log('selectConversation', curConversation);
    setCurConversation(conversation);
  }, []);

  return (
    <View className="conversation-list-wrapper">
      {conversationList?.map(item => (
        <ConversationItem
          key={item.id}
          conversation={item}
          onItemClick={onItemClick}
          selectConversation={selectConversation}
        />
      ))}
      <AtActionSheet isOpened={curConversation} onClose={() => selectConversation(null)} cancelText={'取消'}>
        <AtActionSheetItem
          onClick={() => {
            instance.deleteConversation({ conversation: curConversation });
            setCurConversation(null);
          }}
        >
          删除
        </AtActionSheetItem>
      </AtActionSheet>
    </View>
  );
};

export default ConversationList;
