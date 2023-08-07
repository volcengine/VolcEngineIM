import styled from 'styled-components';

export default styled.div`
  position: absolute;
  top: 0;
  opacity: 0;
  display: flex;
  border: 1px solid #dee0e3;
  transition: opacity 0.1s linear;

  &.trigger-open {
    opacity: 1;
  }
  .toolbar-item-container {
    position: relative;
    .toolbar-item {
      display: flex;
      align-items: center;
      justify-content: center;

      position: relative;
      width: 23px;
      height: 23px;
      font-size: 12px;
      cursor: pointer;
      color: rgb(143, 149, 158);

      &::before {
        content: ' ';
        position: absolute;
        top: 0;
        right: 0;
        display: block;
        width: 1px;
        height: 100%;
        overflow: hidden;
        background-color: #dee0e3;
        transform-origin: left top;
        z-index: 1;

        transform: scaleX(0.5);
      }

      &:hover {
        .im-icon {
          fill: #3370ff;
        }
      }

      .im-icon {
        fill: rgb(143, 149, 158);
      }
    }
  }
`;
