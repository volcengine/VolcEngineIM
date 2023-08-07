import styled, { keyframes } from 'styled-components';

const circle = keyframes`
from {
  transform: rotate(360deg);
}
`;

export default styled.div`
  height: 100%;
  overflow: auto;

  .chat-scrollView-content {
    position: relative;
    backface-visibility: hidden;
    transform-style: flat;
  }

  .infinity-item {
    display: flex;
    left: 0;
    padding: 10px 0;
    width: 100%;
    contain: layout;
    will-change: transform;
    list-style: none;
    p {
      margin: 0;
      word-wrap: break-word;
      font-size: 13px;
    }

    &.tombstone {
      p {
        width: 100%;
        height: 0.5em;
        background-color: #ccc;
        margin: 0.5em 0;
      }
    }
  }

  .infinity-bubble {
    padding: 7px 10px;
    color: #333;
    background: #fff;
    /*box-shadow: 0 3px 2px rgba(0, 0, 0, 0.1)*/
    position: relative;
    max-width: 420px;
    min-width: 80px;
    margin: 0 5px;

    img {
      max-width: 100%;
      height: auto;
    }

    &::before {
      content: '';
      border-style: solid;
      border-width: 0 10px 10px 0;
      border-color: transparent #fff transparent transparent;
      position: absolute;
      top: 0;
      left: -10px;
    }
  }

  .infinity-meta {
    font-size: 0.8rem;
    color: #999;
    margin-top: 3px;
  }

  .infinity-avatar {
    margin-left: 20px;
    margin-right: 6px;
    display: inline-block;
    color: #fff;
    width: 36px;
    height: 36px;
    line-height: 36px;
    text-align: center;
    border-radius: 50%;
    background-color: #f8f9fa;
    white-space: nowrap;
    overflow: hidden;
    vertical-align: middle;

    .infinity-avatar-img {
      position: relative;
      width: 100%;
      height: 100%;
      border-radius: inherit;
      object-fit: cover;

      &::after {
        content: ' ';
        position: absolute;
        top: 0;
        left: 0;
        bottom: 0;
        right: 0;
        background-color: #f3f4f6;
      }
    }
  }

  .im-message-loader {
    position: relative;
    color: #999;
    font-size: 20px;
    text-align: center;
    z-index: 9;
  }

  .im-buyin-icon-loading {
    animation: ${circle} 1s infinite cubic-bezier(0, 0, 1, 1);
  }

  .no-more-message {
    color: rgba(0, 0, 0, 0.25);
    font-size: 14px;
    text-align: center;
    margin: 16px 0 0;
  }

  .new-message-notice {
    padding: 5px 16px;
    display: flex;
    align-items: center;
    color: #255bda;

    &::before,
    &::after {
      content: '';
      flex: 1;
      height: 1px;
      background-color: #255bda;
      font-size: 12px;
    }
    &::before {
      margin-right: 0.25rem;
    }
    &::after {
      margin-left: 0.25rem;
    }
  }
`;
