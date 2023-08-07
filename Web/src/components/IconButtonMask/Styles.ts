import styled from 'styled-components';

export default styled.div`
  position: relative;
  display: inline-block;

  .button-hover-mask {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0px;
    left: 0px;
    border-radius: 4px;
    pointer-events: none;

    &.button-focus {
      background-color: rgba(37, 35, 41, 0.1);
    }

    &.button-active {
      background-color: rgba(37, 35, 41, 0.15);
    }
  }
`;
