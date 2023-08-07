import { Button, Result } from '@arco-design/web-react';
import React from 'react';

import styles from './index.module.scss';

export interface ErrorBoundaryProps { }
export interface ErrorBoundaryState {
  hasError: boolean;
}

class ErrorBoundary extends React.PureComponent<ErrorBoundaryProps, ErrorBoundaryState> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    // 更新 state 使下一次渲染能够显示降级后的 UI
    return { hasError: true };
  }

  componentDidCatch(error: any, errorInfo: any) {
    // 卡片内容渲染异常
    console.warn('----- errorInfo -----', error, errorInfo);
    // this.setState({
    //   hasError: true,
    // });
  }

  render() {
    const { hasError } = this.state;
    const { children } = this.props;

    const handleClick = () => {
      location.reload();
    };

    if (hasError) {
      // 你可以自定义降级后的 UI 并渲染

      return (
        <div className={styles['error-page-wrapper']}>
          <Result
            status="500"
            subTitle="页面出错了，尝试刷新一下页面"
            extra={
              <Button type="primary" onClick={handleClick}>
                刷新
              </Button>
            }
          ></Result>
        </div>
      );
    }

    return children;
  }
}

export default ErrorBoundary;
