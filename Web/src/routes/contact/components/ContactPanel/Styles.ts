import styled from 'styled-components';

export default styled.div`
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  transition: width 300ms ease-in-out;
  .input_container {
    background: #f5f6fa;
  }

  .mobile-message-list {
    padding: 40px 12px 0 14px;
  }

  .chat-header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 40px;
    line-height: 40px;
    padding: 0 15px;
    box-shadow: rgb(240, 241, 242) 0px 2px 8px;
    z-index: 10;
    background: rgb(255, 255, 255);

    .back-icon-box {
      position: absolute;
      top: 2px;
      left: 14px;
      font-size: 20px;
      z-index: 2;
    }

    .chat-title {
      color: #333;
      font-size: 18px;
      line-height: 35px;
      text-align: center;
    }
  }

  .chat-status-wrapper {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    z-index: 20;
  }

  .chat-content {
    flex: 1;
    width: 100%;
    overflow: hidden;
    background-color: #f5f6fa;
    display: flex;
    flex-direction: column;
    align-items: center;
    border-radius: 2px;
    position: relative;

    .message-container {
      position: relative;
      flex: 1;
      align-self: stretch;
      overflow: hidden;
    }
  }

  .scroll-bottom-icon-box {
    position: absolute;
    bottom: 80px;
    right: 20px;
    padding: 10px;
    font-size: 15px;
    background-color: #fff;
    border-radius: 25px;
    border: 1px solid #f0f0f0;
    box-shadow: 0 1px 1px -1px rgba(0, 0, 0, 0.2), 0 1px 1px 0 rgba(0, 0, 0, 0.14), 0 1px 2px 0 rgba(0, 0, 0, 0.12);
    display: flex;
    cursor: pointer;
    z-index: 10;
  }

  .scroll-bottom-icon {
    display: flex;
    align-items: center;
  }
  .contact-list-scroll {
    overflow-y: auto;
    width: 100%;
  }
  .contact-list {
    max-width: 600px;
    margin: 0 auto;
    width: 100%;

    .contact-item {
      display: flex;
      flex-direction: row;
      align-content: center;
      padding: 8px;
    }

    .contact-item-name {
      flex-grow: 1;
      padding-left: 8px;
      display: flex;
      align-items: center;
    }

    .contact-item-operation {
      display: flex;
      align-items: center;
    }
    .contact-item-operation-agree {
      color: green;
      padding: 0 15px;
    }

    .contact-item-operation-reject {
      color: gray;
      padding: 0 15px;
    }
  }
`;
