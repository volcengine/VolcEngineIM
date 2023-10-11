import { View } from '@tarojs/components';

import ConversationItem from '../conversation-item';

import './index.scss';

interface ConversationListProps {
  conversationList: any[];
  onItemClick: (id) => void;
}

const ConversationList: React.FC<ConversationListProps> = ({
  conversationList,
  onItemClick,
}) => {
  return (
    <View className='conversation-list-wrapper'>
      {conversationList?.map((item) => (
        <ConversationItem
          key={item.id}
          conversation={item}
          onItemClick={onItemClick}
        />
      ))}
    </View>
  );
};

export default ConversationList;
