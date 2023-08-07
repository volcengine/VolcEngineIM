import React, { FC, useEffect, useState } from 'react';
import { createPortal } from 'react-dom';

interface PortalProps {
  getContainer?: () => Element;
}

const Portal: FC<PortalProps> = props => {
  const { children, getContainer } = props;
  const [container, setContainer] = useState<Element>();

  useEffect(() => {
    setContainer(getContainer ? getContainer() : document.body);
  }, [getContainer]);

  return container ? createPortal(children, container) : null;
};

export default Portal;
