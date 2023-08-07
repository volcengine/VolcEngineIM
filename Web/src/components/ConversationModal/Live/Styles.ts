import styled from 'styled-components';

export default styled.div`
  position: fixed;
  z-index: 9999;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;

  .modal-mask {
    position: fixed;
    top: 0;
    left: 0;
    background-color: rgba(0, 0, 0, 0.5);
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .modal-container {
    background-color: #fff;
    border-radius: 2px;
    .modal-head {
      padding: 16px 24px;
      display: flex;
      justify-content: space-between;
      padding-bottom: 10px;
      border-bottom: 1px solid #f0f0f0;
      .modal-close {
        cursor: pointer;
      }
    }
    .modal-body {
      width: 300px;
      padding: 15px;
      display: flex;
      .body-input {
        position: relative;
        height: 32px;
        padding: 0 36px;
        border-radius: 4px;
        border: 1px solid #dee0e3;
        box-sizing: border-box;
        .input {
          width: 100%;
          height: 100%;
          padding-left: 4px;
          color: #000;
          font-size: 14px;
          border-radius: 4px;
          box-sizing: border-box;
          z-index: 1;
          border: none;
          outline: none;
        }
        .search-icon {
          position: absolute;
          line-height: 32px;
          font-size: 16px;
          cursor: pointer;
          color: rgb(143, 149, 158);

          &.input-search-icon {
            left: 13px;
          }

          &.input-clear-icon {
            right: 13px;
            &:hover {
              color: #3370ff;
            }
          }
        }
      }
      .foot-button {
        position: relative;
        display: inline-block;
        text-align: center;
        height: 32px;
        line-height: 1.5715;
        padding: 4px 15px;
        font-size: 14px;
        font-weight: 400;
        border-radius: 2px;
        color: #000000d9;
        white-space: nowrap;
        background: #fff;
        border-color: #d9d9d9;
        border-width: 1px;
        border-style: solid;
        box-shadow: 0 2px #00000004;
        cursor: pointer;
        user-select: none;
        touch-action: manipulation;
        transition: all 0.3s cubic-bezier(0.645, 0.045, 0.355, 1);

        &:hover {
          color: rgb(64, 169, 255);
          border-color: rgb(64, 169, 255);
        }

        &.create-button {
          color: #fff;
          border-color: rgb(24, 144, 255);
          background: rgb(24, 144, 255);
          text-shadow: 0 -1px 0 rgb(0 0 0 / 12%);
          box-shadow: 0 2px #0000000b;
          margin-left: 5px;
          &:hover {
            border-color: rgb(64, 169, 255);
            background: rgb(64, 169, 255);
          }
        }
      }
    }
  }
`;
