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

  .im-operation__icon {
    width: 32px;
    height: 32px;
    color: rgb(100, 106, 115);
    border: 1px solid rgb(222, 224, 227);
    border-radius: 50%;
    box-sizing: border-box;
    flex: 0 0 auto;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    position: relative;
    transition: border-color 0.2s ease-in;

    &:hover {
      border-color: #3370ff;

      .im-icon {
        fill: #3370ff;
      }
    }
  }

  .search-input-wrap {
    display: flex;
    justify-content: start;
    align-items: center;
    position: relative;
    width: 100%;
    height: 32px;
    padding: 0 8px;
    margin-right: 12px;
    color: #8f959e;
    font-size: 12px;
    font-weight: 500;
    border: 1px solid #dee0e3;
    background-color: #fff;
    border-radius: 16px;
    user-select: none;
    box-sizing: border-box;
    cursor: pointer;
    transition: color 0.2s ease-in, border-color 0.2s ease-in;

    .im-icon {
      font-size: 16px;
    }

    &:hover {
      color: #3370ff;
      border-color: #3370ff;
    }

    .search-input-placeholder {
      margin-left: 5px;
    }
  }
`;
