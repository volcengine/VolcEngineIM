import styled from 'styled-components';

export default styled.div`
  display: flex;
  width: 100%;
  height: 412px;
  border: 1px solid #dee0e3;
  background-color: #fff;
  border-radius: 4px;
  user-select: none;

  .search-picker-left-search-input {
    padding: 16px;
  }

  .search-picker-left,
  .search-picker-right {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .search-picker-left {
    border-right: 1px solid #dee0e3;
  }

  .search-picker-select-list,
  .search-picker-selected-list {
    height: 100%;
    overflow: auto;
  }

  .search-picker-select-item {
    display: flex;
    align-items: center;
    padding: 8px 16px;
    &:hover {
      background-color: rgba(31, 35, 41, 0.1);
    }
  }

  .search-picker-selected-item {
    display: flex;
    align-items: center;
    padding: 8px 16px;
    cursor: pointer;

    &:hover {
      background-color: rgba(31, 35, 41, 0.1);
    }
  }

  .search-picker-hint {
    font-size: 14px;
    line-height: 34px;
    padding: 16px;
    color: #1f2329;
  }

  .chat-avatar {
    margin-right: 8px;
  }

  .search-picker-detail {
    flex: 1;
    width: 0;

    .chat-user-name {
      width: 100%;
      word-break: break-all;
      text-overflow: ellipsis;
      white-space: nowrap;
      overflow: hidden;
    }
  }

  .select-option {
  }

  .select-item-close-icon,
  .search-item-add-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    color: rgb(143, 149, 158);
    border-radius: 4px;
    font-size: 16px;

    &:hover {
      background-color: rgba(31, 35, 41, 0.1);
    }
  }
`;
