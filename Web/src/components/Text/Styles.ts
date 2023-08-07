import styled from 'styled-components';

const prefixCls = 'im-text';

export default styled.div`
  user-select: text;
  white-space: pre-wrap;

  &.${prefixCls}--truncate {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &.${prefixCls}--breakWord {
    word-break: break-word !important;
    overflow-wrap: break-word !important;
  }

  &.${prefixCls}--ellipsis {
    overflow: hidden;
    display: -webkit-box;
    /* autoprefixer: ignore next */
    -webkit-box-orient: vertical;
    /* -webkit-line-clamp: 2; */
    text-overflow: ellipsis;
  }
`;
