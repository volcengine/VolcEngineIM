import styled from 'styled-components';

export default styled.div`
  .im__editor--toolbar {
    display: inline-block;

    .toolbar-item {
      display: inline-block;
      cursor: pointer;

      &:not(:last-of-type) {
        margin-right: 12px;
      }
    }
  }

  .editor__mention {
    padding: 0 2px;
    color: #1c4cba !important;

    &.editor__mention--outer {
      color: #1f2329 !important;
    }
  }

  .post-edit-zone {
    cursor: text;
  }

  .editor-textarea {
    width: calc(100% - 10px);
    height: 72px;
    border: none;
    resize: none;
  }
`;
