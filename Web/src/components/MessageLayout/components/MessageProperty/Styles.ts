import styled from 'styled-components';

const PropertyContainer = styled.div`
  display: flex;
  padding: 0 12px 0;
  flex-wrap: wrap;
  .message-property-item {
    border-radius: 11px;
    padding: 2px 6px;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #e5e5e5;
    margin-right: 8px;
    margin-bottom: 10px;
    &.self-message {
      background-color: #c0bfe4;
    }
    .message-property-emoji {
      display: flex;
      cursor: pointer;
      .emoji-img {
        width: 18px;
        height: 18px;
      }
    }
    .message-property-separate {
      width: 0;
      height: 12px;
      margin: 3px 6px 0 0;
      position: relative;
      &::after {
        content: ' ';
        display: block;
        width: 1px;
        height: 100%;
        overflow: hidden;
        top: -2px;
        left: 2px;
        background-color: #92969d;
        position: absolute;
        transform-origin: left top;
      }
    }
    .message-property-name {
      color: #646a73;
      font-size: 12px;
    }
  }
`;
export default PropertyContainer;
