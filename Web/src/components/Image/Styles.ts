import styled, { createGlobalStyle, keyframes } from 'styled-components';

const circle = keyframes`
from {
  transform: rotate(360deg);
}
`;

export const GlobalStyle = createGlobalStyle`
.im-image-preview {
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  z-index: 1001;
}

.im-image-preview-hide {
  display: none;
}

.im-image-preview-mask,
.im-image-preview-wrapper {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
}

.im-image-preview-mask {
  background-color: rgba(0, 0, 0, 0.4);
}

.im-image-preview-img-container {
  width: 100%;
  height: 100%;
  text-align: center;
}

.im-image-preview-img-container:before {
  content: '';
  width: 0;
  height: 100%;
  vertical-align: middle;
  display: inline-block;
}

.im-image-preview-img-container .im-image-preview-img {
  max-width: 100%;
  max-height: 100%;
  display: inline-block;
  vertical-align: middle;
  user-select: none;
  cursor: grab;
}

.im-image-preview-img-container .im-image-preview-img.im-image-preview-img-moving {
  cursor: grabbing;
}

.im-image-preview-scale-value {
  padding: 7px 10px;
  box-sizing: border-box;
  font-size: 12px;
  color: #fff;
  background-color: rgba(255, 255, 255, 0.08);
  line-height: initial;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}

.im-image-preview-toolbar {
  background-color: #fff;
  border-radius: 4px;
  display: flex;
  align-items: flex-start;
  padding: 4px 16px;
  position: absolute;
  bottom: 46px;
  left: 50%;
  transform: translateX(-50%);

  .im-buyin-icon {
    stroke: currentColor;
    fill: none;

    display: inline-block;
    color: inherit;
    font-style: normal;
    width: 1em;
    height: 1em;
    vertical-align: -2px;
  }
}

.im-image-preview-toolbar-action {
  font-size: 14px;
  color: rgb(78,89,105);
  border-radius: 2px;
  background-color: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
}

.im-image-preview-toolbar-action:not(:last-of-type) {
  margin-right: 0;
}

.im-image-preview-toolbar-action:hover {
  background-color: rgb(242, 243, 245);
  color: rgb(22, 93, 255);
}

.im-image-preview-toolbar-action-disabled,
.im-image-preview-toolbar-action-disabled:hover {
  color: rgb(95, 95, 96);
  background-color: transparent;
  cursor: not-allowed;
}

.im-image-preview-toolbar-action-content {
  padding: 13px;
  line-height: 1;
}

.im-image-preview-close-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  line-height: 32px;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  text-align: center;
  border-radius: 50%;
  position: absolute;
  right: 36px;
  top: 36px;
  cursor: pointer;
  font-size: 14px;
}

.fadeImage-appear,
.fadeImage-enter {
  opacity: 0;
}
.fadeImage-appear-active,
.fadeImage-enter-active {
  opacity: 1;
  transition: opacity 0.4s cubic-bezier(0.3, 1.3, 0.3, 1);
}
.fadeImage-exit {
  opacity: 1;
}
.fadeImage-exit-active {
  opacity: 0;
  transition: opacity 0.4s cubic-bezier(0.3, 1.3, 0.3, 1);
}
`;

export default styled.div`
  position: relative;
  display: inline-block;
  width: 100%;
  height: 100%;
  border-radius: 8px;
  vertical-align: middle;

  .im-image-img {
    vertical-align: middle;
    border-radius: inherit;
    width: 100%;
    height: auto;
  }

  .im-image-preview {
    position: fixed;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    z-index: 1001;
  }

  .im-image-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;

    .im-buyin-icon-loading {
      animation: ${circle} 1s infinite cubic-bezier(0, 0, 1, 1);
    }
  }

  .im-image-loader {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .im-image-loader-spin {
    position: absolute;
    left: 50%;
    top: 50%;
    color: #999;
    font-size: 20px;
    text-align: center;
    transform: translate(-50%, -50%);
  }

  .im-image-loader-spin-text {
    font-size: 14px;
    color: #999;
  }

  .im-image-error {
    width: 100%;
    height: 100%;
    background-color: rgb(247, 248, 250);
    color: rgb(201, 205, 212);
    padding: 16px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    .im-image-error-icon {
      font-size: 60px;
      line-height: 60px;
    }

    .im-image-error-alt {
      font-size: 12px;
      line-height: 1.6667;
      text-align: center;
    }
  }
`;
