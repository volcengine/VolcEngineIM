import styled from 'styled-components';

const prefixCls = 'im-bubble';
export default styled.div`
  position: relative;
  min-height: 20px;
  //max-height: 324px;
  line-height: 20px;
  padding: 10px;
  overflow: hidden;
  word-break: break-all;
  white-space: pre-wrap;
  word-wrap: break-word;
  box-sizing: border-box;

  .${prefixCls}-foldBox {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    z-index: 50;
  }

  .${prefixCls}-mask {
    width: 100%;
    height: 60px;
    background: linear-gradient(183.02deg, rgba(214, 213, 254, 0) -4.63%, #d6d5fe 62.51%);
  }

  .${prefixCls}-actionBox {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 42px;
    background: #d6d5fe;
  }

  .im-bubble-action-btn {
    display: flex;
    align-items: center;
    color: rgba(0, 0, 0, 0.85);
    font-size: 14px;
    line-height: 20px;
  }
`;
