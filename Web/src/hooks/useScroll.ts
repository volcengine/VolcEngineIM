import { useRef, useState, RefObject } from 'react';
import { useThrottleFn } from 'ahooks';
import { IScrollViewRef } from '../components/ScrollView/interface';

export default function (scrollRef: RefObject<IScrollViewRef>) {
  const lockRef = useRef(false);
  const [showBackBottomBtn, setShowBackBottomBtn] = useState(false);

  const handleScrollToBottom = () => {
    scrollRef.current?.instance?.scrollTo(0, scrollRef.current?.instance?.maxScrollY, 0);
  };

  const autoScrollToBottom = () => {
    if (lockRef.current) {
      return;
    }
    handleScrollToBottom();
  };

  const { run: onScroll } = useThrottleFn(
    (position, bScroll) => {
      const maxScrollY = bScroll?.maxScrollY;
      const positionY = position?.y;

      if (positionY - maxScrollY > 200) {
        // 展示滚动到底部
        lockRef.current = true;
        setShowBackBottomBtn(true);
      } else {
        // 隐藏展示到底部
        lockRef.current = false;
        setShowBackBottomBtn(false);
      }
    },
    { wait: 200 }
  );

  return {
    onScroll,
    showBackBottomBtn,
    autoScrollToBottom,
    handleScrollToBottom,
  };
}
