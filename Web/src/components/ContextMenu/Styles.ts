import styled, { createGlobalStyle } from 'styled-components';

export const GlobalStyle = createGlobalStyle`
  .im-menu-portal {
    position: fixed;
    left: 0;
    top: 0;
    right: 0;
    bottom: 0;
    z-index: 110;
    pointer-events: none;

    .im-menu-wrapper {
      position: absolute;
      pointer-events: auto;
      padding: 10px 0;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 2px 8px 0 rgb(0 0 0 / 16%);
    }


    .context-menu_item-icon {
      width: 20px;
      height: 20px;
      margin-right: 10px;
    }

    .im-menu-label {
      color: rgb(43, 47, 54);
      font-size: 14px;
    }

    .im-menu-item {
      padding: 10px 20px;
      line-height: 20px;
      display: flex;
      align-items: center;
      cursor: pointer;

      &:hover {
        background-color: #eff0f1;
      }
    }
  }
`;
