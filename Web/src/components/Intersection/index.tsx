import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

export type PropTypesOf<T> = { [K in keyof T]?: any };

interface IIntersectionProps {
  root?: string;
  rootMargin?: string;
  threshold?: number[];
  onIntersection?: (target: Element) => void;
  onUnIntersection?: (target: Element) => void;
  onIntersectionUnmount?: () => void;
}

export default class Intersection extends Component<IIntersectionProps> {
  static defaultProps: Partial<IIntersectionProps>;
  static propTypes: PropTypesOf<IIntersectionProps>;

  private intersectionOberver: IntersectionObserver | null;

  componentDidMount() {
    // eslint-disable-next-line react/no-find-dom-node
    const node = ReactDOM.findDOMNode(this);
    const root = this.props.root
      ? document.querySelector(this.props.root)
      : null;
    this.intersectionOberver = new IntersectionObserver(
      this.handleIntersectionChange,
      {
        root,
        rootMargin: this.props.rootMargin,
        threshold: this.props.threshold,
      },
    );
    this.intersectionOberver.observe(node as Element);
  }

  componentWillUnmount() {
    if (this.intersectionOberver) {
      this.intersectionOberver.disconnect();
      this.intersectionOberver = null;
      if (!this.props.onIntersectionUnmount) return;
      this.props.onIntersectionUnmount();
    }
  }

  handleIntersectionChange = (entries: IntersectionObserverEntry[]) => {
    const { onIntersection, onUnIntersection } = this.props;
    entries.forEach(entry => {
      // electron 3.0.10
      // chrome 66.0.3359.181
      // 1. 当 node 从屏幕内缓慢移出时, 触发 change 事件
      //  isIntersection = true, intersectionRatio = 0, intersectionRect不全是0
      //  @see https://bugs.chromium.org/p/chromium/issues/detail?id=713819
      // 2. 当 node 从屏幕外缓慢移动到屏幕内时，不会有这个问题
      // 可以用 MessageList -> renderListBottomDetector 测试
      // 这里采用 intersectionRatio > 0 的判断逻辑
      const { intersectionRatio } = entry;
      if (intersectionRatio > 0) {
        if (onIntersection) onIntersection(entry.target);
      } else if (onUnIntersection) onUnIntersection(entry.target);
    });
  };

  render() {
    const children = React.Children.only(this.props.children);
    return children;
  }
}

Intersection.defaultProps = {
  rootMargin: '0px',
  threshold: [0.000001],
};

Intersection.propTypes = {
  root: PropTypes.string,
  rootMargin: PropTypes.string,
  threshold: PropTypes.array,
  onIntersection: PropTypes.func,
  onUnIntersection: PropTypes.func,
};
