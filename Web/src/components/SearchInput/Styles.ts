import styled from 'styled-components';

export default styled.div`
  position: relative;
  height: 32px;
  padding: 0 36px;
  border-radius: 4px;
  border: 1px solid #dee0e3;
  box-sizing: border-box;

  .search-input {
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

    &.input-close-icon {
      right: 13px;

      &:hover {
        color: #3370ff;
      }
    }
  }
`;
