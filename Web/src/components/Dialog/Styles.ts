import styled, { createGlobalStyle } from 'styled-components';

export const GlobalStyle = createGlobalStyle`
  .zoomModal-enter,
  .zoomModal-appear {
    opacity: 0;
    transform: scale(0.5, 0.5);
  }

  .zoomModal-enter-active,
  .zoomModal-appear-active {
    opacity: 1;
    transform: scale(1, 1);
    transition: opacity .4s cubic-bezier(0.3, 1.3, 0.3, 1),
      transform .4s cubic-bezier(0.3, 1.3, 0.3, 1);
  }

  .zoomModal-exit {
    opacity: 1;
    transform: scale(1, 1);
  }

  .zoomModal-exit-active {
    opacity: 0;
    transform: scale(0.5, 0.5);
    transition: opacity .4s cubic-bezier(0.3, 1.3, 0.3, 1),
      transform .4s cubic-bezier(0.3, 1.3, 0.3, 1);
  }

  .fadeModal-enter,
  .fadeModal-appear {
    opacity: 0;
  }

  .fadeModal-enter-active,
  .fadeModal-appear-active {
    opacity: 1;
    transition: opacity .4s cubic-bezier(0.3, 1.3, 0.3, 1);
  }

  .fadeModal-exit {
    opacity: 1;
  }

  .fadeModal-exit-active {
    opacity: 0;
    transition: opacity .4s cubic-bezier(0.3, 1.3, 0.3, 1);
  }
`;

const prefixCls = 'im-dialog';

export default styled.div`
  .${prefixCls}-mask {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 1000;
    height: 100%;
    background-color: #00000073;
  }

  .${prefixCls}-wrap {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    overflow: auto;
    z-index: 1000;
  }

  .mask-placehoder {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .${prefixCls} {
    position: relative;
    top: 100px;
    width: auto;
    max-width: calc(100vw - 32px);
    margin: 0 auto;
    color: #000000d9;
    font-size: 14px;
    line-height: 1.5715;

    background-color: #fff;
    background-clip: padding-box;
    border-radius: 2px;
    box-shadow: 0 3px 6px -4px #0000001f, 0 6px 16px #00000014, 0 9px 28px 8px #0000000d;
    pointer-events: auto;
    box-sizing: border-box;
  }

  .${prefixCls}-close-icon {
    position: absolute;
    top: 0;
    right: 0;
    padding: 0;
    color: #00000073;
    font-weight: 700;
    line-height: 1;
    text-decoration: none;
    background: 0 0;
    border: 0;
    outline: 0;
    cursor: pointer;
    transition: color 0.3s;
    z-index: 10;

    &:hover {
      color: #000000;
    }

    .close-icon-wrap {
      display: inline-flex;
      align-items: center;
      justify-content: center;

      width: 56px;
      height: 56px;
      font-size: 16px;
      line-height: 56px;
    }
  }

  .${prefixCls}-header {
    padding: 16px 24px;
    color: #000000d9;
    background: #fff;
    border-bottom: 1px solid #f0f0f0;
    border-radius: 2px 2px 0 0;
    text-align: center;
  }

  .${prefixCls}-title {
    color: #000000d9;
    font-weight: 500;
    font-size: 16px;
    line-height: 22px;
    word-wrap: break-word;
  }

  .${prefixCls}-content {
    padding: 24px;
    font-size: 14px;
    line-height: 1.5715;
    word-wrap: break-word;
  }

  .${prefixCls}-footer {
    padding: 10px 16px;
    text-align: right;
    border-top: 1px solid #f0f0f0;
    border-radius: 0 0 2px 2px;
  }

  .im-button {
    margin-left: 15px;
  }
`;
