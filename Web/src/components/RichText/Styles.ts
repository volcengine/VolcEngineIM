import styled from 'styled-components';

export default styled.div`
  .im-rich-emoji {
    display: inline-block;
    padding: 2px;
    vertical-align: -9px;
    height: 28px;
    width: 28px;
    overflow: hidden;

    .im-rich-emoji_img {
      height: 100%;
      width: 100%;
    }
  }

  .im-mention {
    display: inline-block;
    color: #fff;
    padding: 0 4px;
    margin: 0 2px;
    line-height: 18px;
    background-color: #3370ff;
    border-radius: 20px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    vertical-align: -4px;
  }
`;
