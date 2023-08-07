import styled, { createGlobalStyle } from 'styled-components';

export const GlobalStyle = createGlobalStyle`
  .emoji-container {
    position: absolute;
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    width: 325px;
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
      width: 32px;
      height: 32px;
      padding: 3px;
      overflow: hidden;
      cursor: pointer;

      &:hover {
        .emoji-img {
          transform: scale(1.4);
        }
      }
    }

    .emoji-img {
      width: 25px;
      height: 25px;
      transition: transform .3s ease;
    }
    .emoji-mask {
      position: fixed;
      left: 0;
      right: 0;
      top: 0;
      bottom: 0;
      display: block;
      cursor: initial;
    }
  }
`;
