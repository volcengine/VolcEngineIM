import React, { FC } from 'react';

import { ContactMenuListItem } from '../ContactMenuListItem';

import Styles from './Styles';
import { contactSublist } from '../utils';

interface ConversationListProps {
  selectedPanel: string;
  setSelectedPanel: (value: string) => void;
}

export const ContactMenuList: FC<ConversationListProps> = ({ selectedPanel, setSelectedPanel }) => {
  return (
    <Styles>
      {contactSublist.map(item => {
        return (
          <ContactMenuListItem
            key={item.key}
            onClick={() => {
              setSelectedPanel(item.key);
            }}
            title={item?.menuRender ? item?.menuRender() : item.title}
            isActive={selectedPanel === item.key}
            description={''}
          />
        );
      })}
    </Styles>
  );
};
