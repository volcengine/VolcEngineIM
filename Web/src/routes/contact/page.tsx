import React, { useCallback, useEffect, useRef, useState } from 'react';
import classNames from 'classnames';

import { ContactHeader, ContactMenuList, ContactPanel } from './components';

import MainContainer from '../Style';

const Contact = () => {
  const [selectedPanel, setSelectedPanel] = useState('');
  return (
    <MainContainer>
      <div className="chat-conversation-wrap">
        <ContactHeader />

        <ContactMenuList selectedPanel={selectedPanel} setSelectedPanel={setSelectedPanel} />
      </div>

      <div
        className={classNames({
          'chat-panel-wrap': true,
        })}
      >
        <ContactPanel selectedPanel={selectedPanel} />
      </div>
    </MainContainer>
  );
};

export default Contact;
