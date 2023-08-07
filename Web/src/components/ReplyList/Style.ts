import styled from 'styled-components';

export default styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;

  .reply-list-head {
    display: flex;
    height: 64px;
    min-height: 64px;
    padding: 0 18px;
    font-size: 16px;
    line-height: 1.375;
    color: #1f2329;
    font-weight: 600;
    border-bottom: 1px solid #dee0e3;
    background-color: #fff;
    align-items: center;
    justify-content: space-between;
    .title-container {
    }
    .tool-group {
      display: flex;
      .tool-item + .tool-item {
        margin-left: 20px;
      }
      .im-icon {
        width: 20px;
        height: 20px;
        font-size: 20px;
        color: rgba(143, 149, 158, 0.8);
        border-radius: unset;
        fill: currentColor;
        overflow: hidden;
        cursor: pointer;
        flex: none;
      }
    }
  }

  .reply-list-body {
    flex: 1;
    overflow: auto;
  }
`;
