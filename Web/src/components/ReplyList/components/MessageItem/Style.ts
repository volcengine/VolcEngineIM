import styled from 'styled-components';

export default styled.div`
  padding: 10px 5px;
  &.divider {
    border-bottom: 1px solid #dee0e3;
  }
  .message-main-container {
    &.hover {
      background-color: #e6e8e9;
      border-radius: 5px;
      .toolbar-panel {
        opacity: 1;
      }
    }
    padding: 10px;
    .message-head-container {
      display: flex;
      align-items: center;
      margin-bottom: 10px;
      .message-head-avatar {
        margin-right: 10px;
      }
      .message-head-detail {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        color: #999999;
        font-size: 12px;
        flex: 1;
        .message-detail-name {
          margin-bottom: 5px;
        }
        .message-detail-time {
        }
      }
      .message-head-toolbar {
        position: relative;
        width: 60px;
        height: 36px;
      }
    }
    .message-body-container {
      font-size: 14px;
    }
  }
  .message-extra-container {
    padding: 10px;
    display: flex;
    color: #245ddb;
    font-size: 12px;
    .im-icon {
      fill: #245ddb;
      margin-right: 5px;
    }
  }
`;
