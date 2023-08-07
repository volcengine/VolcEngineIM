import styled from 'styled-components';

export default styled.div`
  position: fixed;
  z-index: 100;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;

  &.fadeIn-appear,
  &.fadeIn-enter {
    opacity: 0;
  }
  &.fadeIn-appear-active,
  &.fadeIn-enter-active {
    opacity: 1;
    transition: opacity 0.3s cubic-bezier(0.3, 1.3, 0.3, 1);
  }
  &.fadeIn-exit {
    opacity: 1;
  }
  &.fadeIn-exit-active {
    opacity: 0;
    transition: opacity 0.3s cubic-bezier(0.3, 1.3, 0.3, 1);
  }

  .im-modal-mask {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.3);
  }

  .im-modal-body {
    position: relative;
    overflow: hidden;
    box-sizing: border-box;
  }

  .quickJump {
    display: flex;
    align-items: center;
    flex-direction: column;
    width: 830px;
    max-height: 510px;
    margin: 40px auto 0;
    border-radius: 4px;
    box-shadow: 0 2px 8px 0 rgb(0 0 0 / 20%);
    background-color: #fff;
  }

  .quickJump_input_box {
    flex: 1;
    padding: 20px 50px 20px 28px;
    width: 100%;
    height: 74px;
    display: flex;
    align-items: center;
    position: relative;
  }

  .quickJump_input {
    width: 100%;
    font-size: 22px;
    color: #1f2329;
    transition: transform 0.2s ease;
    transform: translateZ(0);
    border: none;
    outline: none;
  }

  .search-clear {
    position: absolute;
    right: 30px;
    color: #373c43;
    font-size: 18px;
    cursor: pointer;

    &:hover {
      color: #3370ff;
    }
  }

  .quickJump_result {
    width: 100%;
    overflow: overlay;
    transform: translateZ(0);
    overflow-x: hidden;
  }

  .jumpItem {
    display: flex;
    align-items: center;
    position: relative;
    padding: 0 28px;
    height: 56px;
    cursor: pointer;
    overflow: hidden;

    &:hover {
      background-color: #eaf3fa; // #3370ff
    }

    .jumpItem-avatar {
      position: relative;
      width: 32px;
      height: 32px;

      .im-avatar-img {
        width: 100%;
      }
    }

    .jumpItem_info {
      display: flex;
      align-items: center;
      margin-left: 10px;
    }

    .jumpItem_nameWrapper {
      display: flex;
      align-items: center;
      font-size: 14px;
      color: rgb(31, 35, 41);
      line-height: 20px;
      max-width: 620px;
      overflow: hidden;
    }

    .jumpItem_arrow {
      position: absolute;
      right: 32px;
      font-size: 12px;
      color: #7e838c;
      transform: rotate(-90deg);
    }
  }
`;
