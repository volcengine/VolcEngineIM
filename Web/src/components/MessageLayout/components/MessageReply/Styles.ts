import styled from 'styled-components';

export default styled.div`
  position: relative;
  color: #646a73;
  font-size: 12px;
  cursor: pointer;

  .reply-title {
    display: flex;
    padding: 10px 18px 0;
    word-break: keep-all;
    white-space: nowrap;

    overflow: hidden;
    text-overflow: ellipsis;
    align-items: center;
    line-height: normal;
    &::before {
      content: '';
      position: absolute;
      left: 12px;
      top: 12px;
      width: 2px;
      height: 14px;
      color: rgba(143, 149, 158, 0.5);
      border-radius: 50px;
      background-color: #bbbfc4;
    }
  }

  .reply-person {
    padding-right: 4px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .reply-content {
    display: flex;
    align-items: center;
    flex: 1;

    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
`;
