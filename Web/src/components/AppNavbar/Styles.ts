import styled from 'styled-components';

export default styled.div`
  position: relative;
  width: 64px;
  height: 100%;
  flex-shrink: 0;
  background: linear-gradient(0deg, #ffffff, #ffffff), linear-gradient(0deg, #8e58fa 0%, #6557fa 100%);
  user-select: none;

  .app-navbar-avatar-container {
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
    position: relative;
    width: 100%;
    margin: 16px 0 16px;
    z-index: 2;
    cursor: pointer;
  }

  .navbar-items {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding-bottom: 12px;
  }

  .navbar-item {
    display: flex;
    justify-content: center;
    align-items: center;

    width: 40px;
    height: 40px;
    font-size: 24px;
    border-radius: 8px;
    cursor: pointer;

    &.is-active {
      background-color: #f4f2ff;

      .im-icon {
        color: #165dff;
      }
    }

    .im-badge {
      display: flex;
    }
  }
`;
