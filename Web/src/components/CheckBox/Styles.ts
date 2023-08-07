import styled from 'styled-components';

export default styled.label`
  position: relative;
  display: inline-flex;
  align-items: baseline;
  font-size: 14px;
  line-height: 22px;
  font-weight: 400;

  &:hover {
    .im-checkbox__inner {
      border-color: rgb(78, 131, 253);
    }
  }

  &.is-checked {
    &:hover {
      .im-checkbox__inner {
        background-color: rgb(78, 131, 253);
      }
    }
    .im-checkbox__inner {
      border: none;
      background-color: rgb(51, 112, 255);
    }
  }

  &.is-disabled {
    color: rgb(187, 191, 196);

    .im-checkbox__inner {
      background-color: rgb(187, 191, 196);
    }
  }

  .im-checkbox__input {
    position: relative;
    display: inline-block;
    box-sizing: border-box;

    &::after {
      display: inline-block;
      width: 0;
      visibility: hidden;
      content: '\a0';
      width: 16px;
    }
  }

  .im-checkbox__original {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    left: 0;
    width: 100%;
    height: 16px;
    font-size: inherit;
    line-height: inherit;
    z-index: 1;
    cursor: pointer;
    opacity: 0;
    padding: 0;
    margin: 0;
  }

  .im-checkbox__inner {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    left: 0;
    width: 100%;
    height: 16px;
    font-size: 12px;
    color: #fff;
    background-color: #fff;
    border: 1px solid rgb(143, 149, 158);
    border-radius: 2px;
    transition: background 0.2s cubic-bezier(0.34, 0.69, 0.1, 1),
      border 0.2s cubic-bezier(0.34, 0.69, 0.1, 1);
    box-sizing: border-box;

    .im-icon-checked {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      box-sizing: border-box;
    }
  }

  .im-checkbox__label {
    display: inline-block;
    color: rgb(31, 35, 41);
    margin-left: 8px;
    margin-right: 8px;
    overflow-wrap: break-word;
    cursor: pointer;
    box-sizing: border-box;
  }
`;
