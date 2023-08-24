import styled from 'styled-components';

export default styled.div`
  box-sizing: border-box;
  height: 64px;
  flex-shrink: 0;
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
    }
  }
`;
