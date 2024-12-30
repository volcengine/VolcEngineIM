import styled from 'styled-components';

export default styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;

  .chat-setting-header {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    height: 64px;
    min-height: 64px;
    padding: 0 18px;
    font-size: 16px;
    line-height: 1.375;
    color: #1f2329;
    font-weight: 600;
    border-bottom: 1px solid #dee0e3;
    background-color: #fff;
  }

  .chat-setting-main {
    flex: 1;
    padding: 0 20px;
  }

  .chat-setting-info {
    position: relative;
    display: flex;
    align-items: center;
    padding: 20px 0;
    border-bottom: 1px solid #dee0e3;
    cursor: pointer;
  }

  .select-item-wrapper {
    display: flex;
    align-items: center;
    padding: 8px 0;
    cursor: pointer;

    .item-name-wrapper {
      flex: 1;
    }
  }

  .chat-user-detail {
    margin-left: 8px;

    .chat-edit-icon {
      display: flex;
      align-items: center;
      justify-content: center;
      margin-left: 6px;
      width: 24px;
      height: 24px;
      font-size: 14px;
      color: rgba(100, 106, 115);
      border-radius: 4px;

      &:hover {
        background-color: rgba(31, 35, 41, 0.1);
      }
    }
  }

  .chat-user-desc {
    margin-top: 3px;
    font-size: 12px;
    color: #8f959e;
    cursor: pointer;
  }

  .chat-user-name {
    display: flex;
    align-items: center;

    font-size: 16px;
    color: #373c43;
    line-height: 24px;
    font-weight: 600;
  }

  .setting-button-list {
  }

  .setting-button {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 60px;
    border-bottom: 1px solid #dee0e3;
    box-sizing: border-box;
    user-select: none;
    cursor: pointer;

    .im-icon {
      color: rgb(43, 47, 54);
    }
  }

  .setting-button-text,
  .group-name-text {
    font-size: 14px;
    line-height: 20px;
    color: #1f2329;
    font-weight: 500;
  }

  .group-name-container {
    margin-top: 20px;
  }
  .group-name-input {
    outline: none;
    margin-top: 8px;
    align-items: center;
    width: 100%;
    height: 32px;
    padding: 0 18px;
    font-size: 14px;
    border: 1px solid #dee0e3;
    background-color: #fff;
    border-radius: 16px;
    user-select: none;
    box-sizing: border-box;
    cursor: pointer;
    transition: color 0.2s ease-in, border-color 0.2s ease-in;

    &:focus,
    &:hover {
      border-color: #3370ff;
    }
  }

  .setting-content {
    margin-top: 20px;

    .im-checkbox {
      display: flex;
      line-height: 20px;

      .im-checkbox__label {
        flex: 1;
        width: 0;
      }
    }

    .setting-item-title {
      width: 100%;
      color: rgb(43, 47, 54);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin: 8px 0;
    }

    .setting-item-desc {
      font-size: 12px;
      color: #8f959e;
      margin-top: 3px;
    }
  }

  .group-member-wrap {
    border-bottom: 1px solid #dee0e3;
    cursor: pointer;

    .group-member-header {
      display: flex;
      align-items: center;
      margin: 0 auto 8px;
      padding-top: 16px;
      justify-content: space-between;
    }

    .group-member-header-left {
      flex-shrink: 0;
      font-size: 14px;
      font-weight: 500;
      height: 25px;
      line-height: 25px;
    }

    .group-member-header-right {
      .reduce-group-member-icon {
        margin-left: 8px;
      }
    }

    .add-group-member-icon {
      display: flex;
      align-items: center;
      justify-content: center;

      position: relative;
      width: 32px;
      height: 32px;
      color: rgb(100, 106, 115);
      border: 1px solid rgb(222, 224, 227);
      border-radius: 50%;
      box-sizing: border-box;
      flex: 0 0 auto;
      cursor: pointer;
      transition: border-color 0.2s ease-in, color 0.2s ease-in;

      &:hover {
        border-color: #3370ff;
        color: #3370ff;
      }
    }
  }

  .group-member-list-wrap {
    .group-member-search-wrap {
      display: flex;
      align-items: center;
      position: relative;
      width: 100%;
      height: 32px;
      padding: 0 8px;
      color: #8f959e;
      font-size: 12px;
      font-weight: 500;
      border: 1px solid #dee0e3;
      background-color: #fff;
      border-radius: 16px;
      user-select: none;
      box-sizing: border-box;
      cursor: pointer;
      transition: color 0.2s ease-in, border-color 0.2s ease-in;

      &:hover {
        color: #3370ff;
        border-color: #3370ff;
      }

      .im-icon {
        font-size: 16px;
      }
    }

    .input-placeholder {
      margin-left: 5px;
    }

    .group-member-list {
    }
  }

  .chat-setting-footer {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 72px;
  }

  .chat-setting-btn {
    &:not(:first-of-type) {
      margin-left: 32px;
    }
  }
`;
