import styled from 'styled-components';

export default styled.div`
  .form-item {
    display: flex;
    align-items: center;

    .btn {
      margin-left: 12px;
    }
  }

  .member-list-wrapper {
    margin-top: 15px;
  }

  .member-item-wrapper {
    display: flex;
    padding: 10px 0;

    &:hover {
      background-color: #dee0e3;
    }

    .group-auth-item {
      flex: 1;
      display: flex;
      align-items: center;
      padding: 0 15px;
    }

    .group-auth-avatar {
      flex-shrink: 0;
      margin-right: 10px;
      cursor: pointer;
    }

    .group-auth-item-info {
      flex: 1;
      width: 0;
      font-size: 14px;
      height: 20px;
      line-height: 20px;
      overflow: hidden;
      display: flex;
      .group-auth-username {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
    }

    .group-auth-options {
      padding: 0 15px;
      margin-left: 10px;
    }

    .group-option-icon {
      font-size: 14px;
      cursor: pointer;

      &:not(:last-of-type) {
        margin-right: 16px;
      }

      &.group-option-icon-delete {
        color: #f54a45;
      }

      &.group-option-icon-switch {
        color: #3370ff;
      }
    }

    .group-owner-title {
      background-color: #d0defc;
      color: #255cdb;
    }

    .group-manager-title {
      background-color: #f1d3f3;
      color: #c14bbf;
    }
    .group-my-title {
      color: #2e981a;
      background-color: #daf7a6;
    }

    .group-online-title {
      color: #2e981a;
      background-color: #daf7a6;
    }

    .group-with-alias {
      color: #1a9898;
      background-color: #a6f7eb;
    }
    .group-title-tag {
      text-align: center;
      height: 20px;
      line-height: 20px;
      font-size: 12px;
      margin-left: 5px;
      padding: 0 4px;
      border-radius: 4px;
    }
  }
`;
