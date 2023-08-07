import React, { FC, ReactNode, useMemo, useRef, useState } from 'react';
import classNames from 'classnames';
import { Tooltip } from '@arco-design/web-react';

import ToolbarBox from './Styles';

interface IItem {
  name?: string;
  onClick?: () => void;
  icon?: ReactNode;
  table?: any;
  tableProps?: any;
}

interface ToolbarProps {
  items: IItem[];
  setToolBarVisible?: (boolean) => void;
  isFromMe?: boolean;
}

const Toolbar: FC<ToolbarProps> = props => {
  const { items, setToolBarVisible, isFromMe } = props;
  const [visible, setVisible] = useState(false);
  const timer = useRef<number>();
  const [activeCmp, setActiveCmp] = useState('');
  const toolbarItemRef = useRef<HTMLDivElement>();

  const cmpMap = useMemo(() => {
    const map = {};
    items.forEach(item => {
      map[item.name] = item.table;
    });
    return map;
  }, [items]);

  const propsMap = useMemo(() => {
    const map = {};
    items.forEach(item => {
      map[item.name] = item.tableProps;
    });
    return map;
  }, [items]);

  return (
    <ToolbarBox
      className={classNames('toolbar-panel')}
      style={
        isFromMe
          ? {
              right: '5px',
            }
          : {
              left: '5px',
            }
      }
    >
      {items.map(item => {
        const Cmp = visible && item.name === activeCmp ? cmpMap[activeCmp] : null;

        return (
          <div
            key={item.name}
            className="toolbar-item-container"
            onMouseEnter={() => {
              window.clearTimeout(timer.current);
              setVisible(true);
              setActiveCmp(item.name);
              setToolBarVisible(true);
            }}
            onMouseLeave={() => {
              clearTimeout(timer.current);
              timer.current = window.setTimeout(() => {
                setVisible(false);
              }, 100);
            }}
          >
            {Cmp && (
              <Cmp {...propsMap[activeCmp]} toolbarItemRef={toolbarItemRef} handleClose={() => setVisible(false)} />
            )}
            {item.name ? (
              <Tooltip key={item.name} content={item.name} position="top">
                <div className="toolbar-item" onClick={item.onClick}>
                  {item.icon}
                </div>
              </Tooltip>
            ) : (
              <div className="toolbar-item super-div" onClick={item.onClick} ref={toolbarItemRef}>
                {item.icon}
              </div>
            )}
          </div>
        );
      })}
    </ToolbarBox>
  );
};

export default Toolbar;
