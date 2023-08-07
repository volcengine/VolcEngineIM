import styled from 'styled-components';

export default styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  font-weight: 500;
  font-size: 17px;
  line-height: 24px;
  padding: 0 32px;
  text-align: center;
  color: #161823;

  .im-result-title {
    margin-top: 16px;
  }

  .im-result-subtitle {
    font-size: 14px;
    line-height: 20px;
    margin-top: 8px;
    text-align: center;
    color: rgba(22, 24, 35, 0.5);
  }

  .more-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 112px;
    height: 36px;
    margin: 24px auto 0;
    font-weight: 500;
    font-size: 13px;
    line-height: 18px;
    color: #ffffff;
    background-color: #fe2c55;
    border-radius: 2px;
    outline: none;
    border: none;
  }
`;
