import styled from 'styled-components';

export default styled.div`
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: #f8f9fa;

  .chat-search-header {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;

    height: 64px;
    min-height: 64px;
    padding: 0 18px;
    font-size: 16px;
    line-height: 1.375;
    color: #1f2329;
    font-weight: 600;
    border-bottom: 1px solid #dee0e3;
    background-color: #fff;
  }

  .chat-search-input-wrap {
    margin: 20px 20px 10px;
    background-color: #fff;
  }

  .chat-search-list {
  }

  .chat-message-empty {
    margin-top: 82px;

    .im-result-image {
      width: 115px;

      img {
        width: 100%;
      }
    }

    .im-result-subtitle {
      font-size: 12px;
      color: rgba(31, 35, 41, 0.5);
    }
  }
`;
