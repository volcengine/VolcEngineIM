import styled from 'styled-components';

export default styled.div`
  position: relative;
  background: #ffffff;
  border: 1px solid #f0f0f0;
  border-radius: 4px;
  box-sizing: border-box;
  margin: 6px 8px 8px;
  padding: 10px 8px 45px 10px;

  .im__editor--default {
    .post-edit-zone {
      min-height: 72px;
      max-height: 120px;
      word-break: break-all;
      overflow-y: auto;
    }
  }

  .text-area {
    width: 100%;
    font-size: 14px;
    line-height: 20px;
    letter-spacing: 0.1px;
    color: rgba(0, 0, 0, 0.85);
    resize: none;
    border: none;
    outline: none;

    &::placeholder {
      color: rgba(0, 0, 0, 0.4);
    }

    ::-webkit-scrollbar {
      width: 4px;
    }

    ::-webkit-scrollbar-thumb {
      border-radius: 3px;
      background: #e1e3e8;
    }
  }

  .input-header {
    display: flex;

    .input-icon {
      font-size: 16px;
      width: 28px;
      height: 28px;
      cursor: pointer;
      border-radius: 4px;
      display: flex;
      justify-content: center;
      align-items: center;
      &:hover {
        background: #f3f4f6;
      }

      &:not(:last-of-type) {
        margin-right: 8px;
      }

      &.image-icon {
        position: relative;
        top: -1px;
      }

      &.video-icon {
        position: relative;
        top: -1px;
        font-size: 21px;
      }
    }
  }
  .input-footer {
    position: absolute;
    right: 16px;
    bottom: 12px;
    height: 26px;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    z-index: 9;

    .text-count {
      position: relative;
      right: -6px;
      font-size: 22px;
      transform: scale(0.5);
      text-align: right;
      color: #999;

      .is-exceed {
        color: #ff574d;
      }
    }

    .send-button {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 60px;
      height: 26px;
      line-height: 1;
      text-align: center;
      background: #6647ff;
      border-radius: 4px;
      border: none;
      font-size: 12px;
      font-weight: 400;
      color: #ffffff;
      cursor: pointer;
    }
    .send-button + .send-button {
      margin-left: 10px;
      width: 100px;
    }
  }

  .im__editor--toolbar {
    font-size: 16px;
    color: rgb(85, 88, 92);

    .toolbar-item {
      .button-hover-box {
        width: 28px;
        height: 28px;
        border-radius: 4px;

        display: flex;
        justify-content: center;
        align-items: center;
      }

      &.mention-item {
        font-size: 22px;
      }

      &.more-item {
        font-size: 20px;

        .im-icon {
          fill: rgb(85, 88, 92);
        }
      }
    }
  }

  .reply-title {
    width: 100%;
    height: 22px;
    line-height: 22px;
    background-color: #f5f6f7;
    border-radius: 3px;
    color: #8f959e;
    color: rgb(143, 149, 158);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    animation: scaleIn 0.2s linear;
    margin-bottom: 10px;
    box-sizing: border-box;

    .im-icon-cross {
      font-size: 12px;
      padding: 5px 0 5px 5px;

      margin-right: 5px;
      cursor: pointer;

      &::after {
        content: '';
        padding-left: 5px;
        height: 10px;
        display: inline-block;
        border-right: 1px solid #dee0e3;
      }
    }
    .reply-text {
      font-size: 14px;
      line-height: 22px;
      color: #8f959e;
    }
  }
`;
