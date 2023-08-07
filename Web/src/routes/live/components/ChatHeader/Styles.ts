import styled from 'styled-components';

export default styled.div`
  height: 64px;
  padding: 14px 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #ffffff;
  border-radius: 2px;
  border-bottom: 1px solid rgba(138, 147, 160, 0.3);
  .chat-info {
    display: flex;
    align-items: center;
    cursor: pointer;
    .info {
      margin-left: 12px;
      .name {
        display: inline-block;
        font-weight: 500;
        font-size: 14px;
        line-height: 20px;
        color: #2e3135;
        text-align: left;
        margin-bottom: 2px;
      }
      .level {
        display: inline-block;
        position: relative;
        top: 3px;
        margin-left: 8px;
        height: 16px;
        width: 36px;
      }
      .tag {
        font-weight: 400;
        font-size: 12px;
        line-height: 16px;
        color: #85878a;
        .split-line {
          display: inline-block;
          width: 1px;
          height: 8px;
          border-right: 1px solid #d4d6d9;
          margin: 0 8px;
        }
      }
    }
  }

  .operate-button-group {
    .text-button {
      color: rgb(100, 106, 115);
    }
    .toolbar-icon {
      display: inline-block;
      font-size: 20px;
      color: rgb(100, 106, 115);
      margin-right: 20px;
      vertical-align: middle;
      cursor: pointer;

      svg {
        fill: rgb(100, 106, 115);
      }
    }
  }
`;
