import React from 'react';
import { CSSTransition } from 'react-transition-group';

export interface CSSTransitionClassNames {
  appear?: string;
  appearActive?: string;
  appearDone?: string;
  enter?: string;
  enterActive?: string;
  enterDone?: string;
  exit?: string;
  exitActive?: string;
  exitDone?: string;
}

export interface TransitionProps {
  in?: boolean;
  onEnter?: (e) => void;
  onEntering?: () => void;
  onEntered?: (e) => void;
  onExit?: () => void;
  onExiting?: () => void;
  onExited?: (e) => void;
  addEndListener?: () => void;
  unmountOnExit?: boolean;
  appear?: boolean;
  duration?: number | { appear?: number; enter?: number; exit?: number };
  mountOnEnter?: boolean;
  classNames?: string | CSSTransitionClassNames;
}

const noop = () => {};

const Transition: React.FC<TransitionProps> = props => {
  const {
    in: inProp,
    onEnter = noop,
    onEntering = noop,
    onEntered = noop,
    onExit = noop,
    onExiting = noop,
    onExited = noop,
    addEndListener = noop,
    unmountOnExit,
    appear,
    duration,
    mountOnEnter,
    classNames,
    children,
  } = props;

  return (
    <CSSTransition
      onEnter={onEnter}
      onEntering={onEntering}
      onEntered={onEntered}
      onExit={onExit}
      onExiting={onExiting}
      onExited={onExited}
      addEndListener={addEndListener}
      in={inProp}
      mountOnEnter={mountOnEnter}
      unmountOnExit={unmountOnExit}
      appear={appear}
      classNames={classNames}
      timeout={duration}
    >
      {children}
    </CSSTransition>
  );
};

export default Transition;
