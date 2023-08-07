import React, {
  useEffect,
  useRef,
  useState,
  forwardRef,
  useImperativeHandle,
} from 'react';
import ReactDOM from 'react-dom';

export type PortalRef = {};

export interface PortalProps {
  getContainer: () => any;
  children?: React.ReactNode;
  [key: string]: any;
}

const Portal = forwardRef<PortalRef, PortalProps>((props, ref) => {
  const { getContainer, children } = props;

  const [container, setContainer] = useState<HTMLElement>();

  useEffect(() => {
    setContainer(getContainer ? getContainer() : document.body);
  }, [getContainer]);

  useImperativeHandle(ref, () => ({}), []);

  return container ? ReactDOM.createPortal(children, container) : null;
});

export default Portal;
