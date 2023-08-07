import styled from 'styled-components';

const prefixCls = 'system-message';
export default styled.div`
  font-size: 12px;
  color: #8f959e;
  padding: 5px 10px;
  user-select: none;
  max-width: 100%;
  line-height: normal;
  box-sizing: border-box;
  word-break: break-word;

  &.is-weakHint {
    display: flex;
    align-content: center;
    justify-content: center;
  }

  .${prefixCls}-content {
    display: inline-block;
  }

  .im-divider {
    display: flex;
    justify-content: center;
    align-items: center;
    color: rgba(0, 0, 0, 0.4);
    font-size: 12px;
    line-height: 18px;
    font-weight: 400;

    &::before,
    &::after {
      flex: 1 1;
      content: ' ';
      display: block;
      border-width: 0;
      border-color: rgba(0, 0, 0, 0.06);
      border-style: solid;
      box-sizing: border-box;
      border-bottom-width: 1px;
    }

    &::before {
      margin-right: 8px;
    }

    &::after {
      margin-left: 8px;
    }
  }
`;
