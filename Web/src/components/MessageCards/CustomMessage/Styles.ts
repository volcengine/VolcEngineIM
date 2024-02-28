import styled from 'styled-components';

export default styled.div`
  position: relative;
  min-height: 20px;
  max-height: 324px;
  line-height: 20px;
  padding: 10px;
  overflow: hidden;
  word-break: break-all;
  white-space: pre-wrap;
  word-wrap: break-word;
  box-sizing: border-box;

  &.is-expand {
    max-height: none;
  }

  img {
    height: 24px;
    width: 24px;
    display: inline-block;
    padding: 2px;
    vertical-align: middle;
  }

  .img-error-text {
    padding: 10px;
  }

  .height-limit-cut-modal {
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%;
    height: 80px;
    background: linear-gradient(183.02deg, rgba(255, 255, 255, 0) -4.63%, #ffffff 62.51%);
    z-index: 9;

    &.is-me {
      background: linear-gradient(183.02deg, rgba(214, 213, 254, 0) -4.63%, #d6d5fe 62.51%);
    }
  }

  .height-limit-btn {
    position: absolute;
    left: 50%;
    bottom: 20px;
    width: 74px;
    height: 32px;
    line-height: 32px;
    font-size: 14px;
    text-align: center;
    color: #252931;
    background: #ffffff;
    border-radius: 16px;
    transform: translateX(-50%);
    cursor: pointer;
    filter: drop-shadow(0px 2px 8px rgba(18, 20, 26, 0.06));
  }
`;
