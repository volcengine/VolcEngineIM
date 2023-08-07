import React, { FC, useCallback } from 'react';
import { Transition } from '..';
import classNames from 'classnames';
interface SidebarTransitionProps {
  visible: boolean;
  onMaskClick?: () => void;
  className?: string;
}

const SidebarTransition: FC<SidebarTransitionProps> = props => {
  const { visible, children, onMaskClick, className } = props;
  const containerClassName = classNames(className, 'slide-content-wrapper');
  const handleMaskClick = useCallback(() => {
    onMaskClick?.();
  }, [onMaskClick]);

  return (
    <>
      <Transition classNames="slide" in={visible} duration={300} unmountOnExit>
        <div className={containerClassName}>{children}</div>
      </Transition>
      {visible && <div className="im-sidebar-mask" onClick={handleMaskClick} />}
    </>
  );
};

export default SidebarTransition;
