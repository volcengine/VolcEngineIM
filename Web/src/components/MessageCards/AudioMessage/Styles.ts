import styled, { css } from 'styled-components';

function generateAudioLevel(lv: number, width: string) {
  return css`
    .message-audio-width-lv${lv} {
      width: ${width};
    }
  `;
}

const audioPrefix = 'im-audio';
export default styled.div`
  position: relative;

  .message--audio__control {
    width: 100%;
    padding: 1px 46.36px 1px 46px;
    height: 42px;
    position: relative;
    box-sizing: border-box;
    user-select: none;
    color: #8f959e;
  }

  ${generateAudioLevel(1, '150px')}
  ${generateAudioLevel(2, '170px')}
  ${generateAudioLevel(3, '190px')}
  ${generateAudioLevel(4, '210px')}
  ${generateAudioLevel(5, '230px')}
  ${generateAudioLevel(6, '250px')}

  .ctrl::before {
    content: '';
    width: 13px;
    height: 12px;
    background: #fff;
    position: absolute;
    top: 6px;
    left: 6px;
  }

  .ctrl {
    position: absolute;
    top: 50%;
    left: 12px;
    width: 24px;
    height: 24px;
    margin-top: -12px;
    cursor: pointer;

    &::before {
      content: '';
      width: 13px;
      height: 12px;
      background: #fff;
      position: absolute;
      top: 6px;
      left: 6px;
    }

    .ctrl--normal__icon {
      font-size: 24px;
      position: relative;

      .im-icon {
        fill: #1c4cba;
      }
    }
  }

  .process {
    width: 0;
    height: 100%;
    left: 0;
  }

  .bar--normal__bg {
    position: absolute;
    left: 0;
    top: 50%;
    height: 1px;
    margin-top: -1px;
    width: 100%;
    background-color: rgba(28, 76, 186, 0.3);
  }

  .audio--normal__time {
    position: absolute;
    right: 12px;
    top: 0;
    font-size: 12px;
    line-height: 42px;
    color: #1c4cba;
  }

  .bar--normal__wrapper {
    position: relative;
    width: 100%;
    height: 6px;
    margin-top: -3px;
    top: 50%;
    cursor: pointer;
  }

  .slider--normal__strip {
    position: absolute;
    top: 50%;
    left: 0;
    width: 16px;
    height: 16px;
    margin-top: -8px;
    margin-left: -8px;
    border-radius: 8px;
    border: 1px solid #dee0e3;
    box-sizing: border-box;
    background-color: #fff;
    box-shadow: 0 0 8px 0 rgb(0 0 0 / 16%);
  }
`;
