import React, { memo } from 'react';
import { Conversation } from '@volcengine/im-web-sdk';

import Styles from './Styles';
import { contactSublist } from '../utils';

interface ChatInfoPropsTypes {
  selectedPanel: string;
}

export const ContactPanelHeader: React.FC<ChatInfoPropsTypes> = memo(props => {
  return (
    <Styles>
      <div className="chat-info">
        <div className="info">
          <div className="name">{contactSublist.find(i => i.key === props.selectedPanel).title}</div>
        </div>
      </div>
    </Styles>
  );
});
