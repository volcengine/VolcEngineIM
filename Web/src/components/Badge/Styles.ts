import styled from 'styled-components';

export default styled.div`
  display: inline-block;
  position: relative;
  box-sizing: border-box;

  &.im-badge-status {
    line-height: inherit;
  }

  &.im-badge-has-no-child {
    .im-badge-count {
      position: relative;
      top: auto;
      right: auto;
      transform: none;
    }
  }

  .im-badge-dot,
  .im-badge-count {
    position: absolute;
    top: 3px;
    right: 6px;
    transform: translate(50%, -50%) scale(0.4);
  }

  .im-badge-dot {
    width: 6px;
    height: 6px;
    background: #fe2c55;
    border-radius: 100%;
    box-shadow: 0 0 0 1px #fff;
  }

  .im-badge-count {
    min-width: 24px;
    min-height: 24px;
    line-height: 24px;
    padding: 2px 8px;
    font-size: 24px;
    color: #ffffff;
    white-space: nowrap;
    text-align: center;
    background-color: #ff574d;
    border-radius: 24px;
    border: 1px solid #ffffff;
  }

  .im-badge-status-success {
    background-color: #52c41a;
  }

  .im-badge-status-processing {
    background-color: #1890ff;
  }

  .im-badge-status-error {
    background-color: #fe2c55;
  }

  .im-badge-status-default {
    background-color: #d9d9d9;
  }

  .im-badge-status-warning {
    background-color: #faad14;
  }
`;
