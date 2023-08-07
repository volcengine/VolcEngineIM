import styled from 'styled-components';

export const PageLoading = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
`;

export default styled.main`
  flex: 1;
  position: relative;
  height: 100vh;
  width: 100%;
  display: flex;
  overflow: hidden;

  .empty {
    width: 100%;
    height: 100%;
    background-color: #fff;
    border-radius: 2px;
    display: flex;
    align-content: center;
    justify-content: center;

    & > img {
      width: 433px;
    }
  }

  .chat-conversation-wrap {
    display: flex;
    flex-direction: column;
    width: 320px;
    height: 100%;
    border-left: 1px solid rgba(0, 0, 0, 0.06);
    border-right: 1px solid rgba(0, 0, 0, 0.06);
    background-color: #fff;

    .conversation-list {
      flex: 1;
      overflow-y: auto;
    }

    .empty-conversation-wrap {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      font-size: 14px;
      line-height: 20px;
      color: rgba(0, 0, 0, 0.4);
    }
  }

  .im-list-header {
    padding: 0;
  }

  .im-list-item {
    cursor: pointer;
  }

  .chat-panel-wrap {
    flex: 1;
    //overflow: scroll;
    display: flex;
    &.full-side-bar {
      .chat-panel-container {
        width: 0;
      }
      .slide-content-wrapper {
        width: 100%;
      }
    }
    &.half-side-bar {
      .chat-panel-container {
      }
      .slide-content-wrapper {
        min-width: 260px;
      }
    }

    .slide-content-wrapper {
      display: flex;
      height: 100%;
      border-left: 1px solid #dee0e3;
      background: #fff;
      z-index: 13;
      transition: width 300ms ease-in-out;
      overflow: scroll;
    }

    .im-sidebar-mask {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      z-index: 12;
      -webkit-app-region: no-drag;
    }
  }

  .chat-menu-wrap {
    display: flex;
  }

  .sideBar-menu {
    display: flex;
    flex-direction: column;
    align-items: center;

    width: 48px;
    height: 100%;
    background: #fff;
    border-left: 1px solid #f5f6f7;
  }

  .sidebar-menu-item {
    font-size: 20px;
    margin-top: 24px;
    cursor: pointer;

    &.is-selected {
      .im-icon {
        color: #3370ff;
      }
    }

    &:hover {
      .im-icon {
        color: #3370ff;
      }
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
`;
