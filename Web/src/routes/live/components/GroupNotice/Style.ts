import styled from 'styled-components';

export default styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;

  .group-notice-head {
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
      .title-time {
        margin-left: 5px;
        font-size: 12px;
        font-weight: 400;
        color: #8f959e;
      }
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
  .group-notice-body {
    flex: 1;
    padding: 5px;
    .group-notice-input {
      width: 100%;
      height: 100%;
      border: none;
      outline: none;
      resize: none;
    }

    .notice-btn-wrapper {
      display: flex;
      justify-content: flex-end;
      margin-top: 10px;
    }
  }
`;
