import styled from 'styled-components';

export default styled.div`
  height: 60px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  position: relative;
  padding: 12px 16px 10px;
  transition: background-color 0.3s ease-in-out;
  cursor: pointer;

  &.is-active {
    background-color: #f5f6fa;
  }

  &:hover {
    background-color: #fafafa;

    .convesation-user {
      font-weight: 500;
    }
  }

  .baged-number-gray {
    background: #e5e6eb;
    color: #86909c;
  }

  .conversation-right {
    flex: 1;
    margin-left: 15px;
    height: 100%;
    overflow: hidden; /* 容器限定，子元素才能省略，否则设置 width:0 */
  }

  .convesation-header {
    display: flex;
    align-items: center;
    margin-top: -4px;
    height: 22px;
  }

  .convesation-user {
    font-weight: 400;
    font-size: 14px;
    color: rgba(0, 0, 0, 0.85);

    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .convesation-time {
    font-size: 22px;
    color: #aaabaf;
    transform: scale(0.5);
    transform-origin: center right;
  }

  .message-preview-container {
    display: flex;
    align-items: center;
    font-size: 12px;
    line-height: 16px;
    color: #85878a;
    overflow: hidden;
  }

  .message-preview-content {
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
`;
