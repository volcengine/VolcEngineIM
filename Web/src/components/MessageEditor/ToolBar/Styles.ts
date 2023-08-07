import styled, { createGlobalStyle } from 'styled-components';

export const GlobalStyle = createGlobalStyle`
  .emoji-container {
    position: absolute;
    top: -200px;
    left: 0;
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    width: 375px;
    height: 188px;
    padding: 6px;
    background-color: #fff;
    box-shadow: 0 3px 16px 0 rgb(31 35 41 / 12%);
    overflow-y: scroll;
    user-select: none;
    box-sizing: border-box;
    z-index: 9999;

    .emoji-item {
      display: inline-block;
      width: 42px;
      height: 42px;
      padding: 6px;
      overflow: hidden;
      cursor: pointer;

      &:hover {
        .emoji-img {
          transform: scale(1.4);
        }
      }
    }

    .emoji-img {
      width: 30px;
      height: 30px;
      transition: transform .3s ease;
    }
  }

  .emoji-mask {
    width: 100vw;
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    z-index: 9998;
    display: block;
    cursor: initial;
  }
`;
