import styled, { createGlobalStyle, keyframes } from 'styled-components';

const FadeIn = keyframes`
  0% {
    opacity: 0;
  }

  100% {
    opacity: 1;
  }
`;

export const GlobalStyle = createGlobalStyle`
  .im-quick-popover {
    opacity: 1;

    .rc-tooltip-arrow {
      display: none;
    }

    .rc-tooltip-inner {
      padding: 0;
      background-color: unset;
      border-radius: unset;
      box-shadow: unset
    }
  }

  .quick-jump-wrapper {
    background: #fff;
    z-index: 10;
  }

  .quick-jump-menu {
    background-color: rgba(31,35,41,.9);
    border-radius: 5px;
    animation: ${FadeIn} .2s both;
    box-sizing: border-box;
  }

  .quick-jump-menu__item {
    display: flex;
    align-items: center;
    color: #fff;
    padding: 15px 20px;
    cursor: pointer;
    white-space: nowrap;
    transition: background-color .2s ease-in;

    &:hover {
      background-color: hsla(0,0%,100%,.1);
    }

    .im-icon {
      font-size: 20px;
      margin-right: 12px;
      fill: currentColor;
    }
  }
`;

export default styled.div`
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  min-height: 64px;
  font-weight: 500;
  font-size: 14px;
  line-height: 20px;
  text-align: left;
  color: #12141a;
  background-color: #ffffff;
  border-bottom: 1px solid #f0f0f0;
  box-sizing: border-box;

  .search-wrapper {
    display: flex;
    align-items: center;
    width: 100%;

    .input-wrapper {
      flex: 1;
    }

    .text {
      margin-left: 10px;
      word-break: keep-all;
      cursor: pointer;
    }
  }
`;
