import styled from 'styled-components';

const videoPrefix = 'im-video';
export default styled.div`
  position: relative;
  width: 100%;
  padding: 8px;
  border-radius: inherit;

  .${videoPrefix}-cover, .${videoPrefix} {
    display: block;
    width: 100%;
    max-height: 100%;
    border-radius: inherit;
  }

  .${videoPrefix}-duration {
    position: absolute;
    right: 5px;
    bottom: 5px;
    z-index: 1;
    color: var(--white);

    &:after {
      content: '＂';
    }
  }
  .${videoPrefix}-playBtn {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    border: 0;
    background: transparent;

    &:hover {
      cursor: pointer;
    }
  }

  .${videoPrefix}-playIcon {
    display: inline-block;
    width: 35px;
    height: 35px;
    background: url('//gw.alicdn.com/tfs/TB1p1mkqIbpK1RjSZFyXXX_qFXa-70-70.png') 0 0 no-repeat;
    background-size: cover;
  }

  .is-playing {
    .${videoPrefix}-playBtn {
      display: none;
    }
  }
`;
