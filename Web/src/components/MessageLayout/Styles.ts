import styled from 'styled-components';

export default styled.div`
  .message-item {
    position: relative;
    display: flex;
    padding: 2px 16px;
    transition: background 0.2s linear;
    z-index: 1;

    &.has-pin {
      background-color: #fcf9ee;
    }

    &.hover {
      z-index: 3;

      .message-right .message-timestamp,
      .message-left .message-timestamp {
        visibility: visible;
      }

      .toolbar-panel {
        opacity: 1;
      }
    }

    &.has-meta-info {
      padding-bottom: 8px;
    }

    &.message-self {
      flex-direction: row-reverse;
      justify-content: flex-end;

      .message-info {
        justify-content: flex-end;
      }

      .message-section-left {
        background-color: #d6d5fe;
      }

      .message-section {
        flex-direction: row-reverse;
      }

      .message-avatar {
        margin-left: 10px;
      }

      .toolbar-panel,
      .im-message-status {
        left: auto;
        right: 5px;
      }
    }

    .im-bubble {
      padding: 10px 12px;
      font-size: 14px;
      line-height: 20px;
      color: #12141a;
    }
  }

  .message-left {
    position: relative;
    width: 34px;
    box-sizing: border-box;
    z-index: 2;
  }

  .message-avatar {
    padding-top: 16px;
    cursor: pointer;
  }

  .message-right {
    flex: 1;
    width: 0;
    z-index: 1;
  }

  .message-info {
    display: flex;
    white-space: nowrap;
    align-items: center;
    font-size: 12px;
    height: 16px;
    color: #aaabaf;
    box-sizing: border-box;
  }

  .message-timestamp {
    visibility: hidden;
    user-select: none;
    pointer-events: auto;
  }

  .message-section-left {
    position: relative;
    border-radius: 8px;
    max-width: calc(100% - 180px); // 预留 toolbar
    background-color: #fff;
    overflow: hidden;
    box-sizing: border-box;
  }

  .message-section-right {
    position: relative;
  }

  .im-message-status {
    position: absolute;
    left: 5px;
    bottom: -4px;

    .im-tag {
      font-size: 14px;
    }
  }

  .im-message-read-status {
    position: absolute;
    right: 4px;
    bottom: -1px;
    width: 60px;
    display: flex;
    justify-content: end;
    color: #aaabaf;
    font-size: 12px;
  }

  .message-section {
    display: flex;
  }

  .message-meta {
    margin: 5px 0 0 0;
    font-size: 12px;
    color: #3370ff;
    z-index: 1;
    display: flex;
    align-items: center;
    &.message-self {
      justify-content: end;
    }
    .message-meta-nowrap {
      display: flex;
      flex-wrap: wrap;
    }

    .message-meta-reply {
      color: #1c4cba;
    }

    .message-meta-reply,
    .message-meta-pin {
      display: flex;
      max-width: 100%;
      font-size: 12px;
      line-height: 16px;
      margin-right: 4px;
    }

    .replay__count--text {
      color: inherit;
      cursor: pointer;
    }

    .message-meta-pin {
      cursor: default;
      color: #04b49c;
    }

    .message-meta-pin-icon {
      display: flex;
      justify-content: center;
      align-items: center;
      & > svg {
        fill: #04b49c;
      }
    }

    .replay__pin--text {
    }
  }

  .message-err-text-tip-wrapper {
    display: flex;
    align-items: center;
  }

  .message-err-text-tip {
    margin-left: 2px;
    color: #298cff;
    cursor: pointer;
    font-size: 12px;
  }

  .message-read-state {
  }
`;
