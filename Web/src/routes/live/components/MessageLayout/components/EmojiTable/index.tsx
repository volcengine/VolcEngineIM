import React, { CSSProperties, memo } from 'react';
import { emoticons } from '../../../../../../assets/emotion/map';
import { GlobalStyle } from './Styles';
import { MessageItemType } from '../../../../../../types';
import Portal from '../../../../../../components/Portal/Portal';

export interface EmojiType {
  name: string;
  icon: any;
}

interface EmojiTablePropsType {
  style?: CSSProperties;
  message?: MessageItemType;
  onSelectEmoji?: (key: string, value: string) => void;
  toolbarItemRef: any;
  handleClose?: () => void;
}

const emotionListWidth = 325; // 表情列表 宽度
const emotionListHeight = 188; // 表情列表 高度
const division = 7; // 表情列表 与 表情显示按钮 的间隙

const getListPosition = ref => {
  const div = ref.current;
  if (!div) {
    return;
  }
  const divLeft = div.getBoundingClientRect().left;
  const divTop = div.getBoundingClientRect().top;
  const bodyWidth = document.body.clientWidth;
  let left = divLeft - emotionListWidth / 2;
  let top = divTop - emotionListHeight - division;
  if (left + emotionListWidth > bodyWidth) {
    left = bodyWidth - emotionListWidth - 10;
  }
  if (top < 0) {
    top = divTop + 23 + division;
  }
  return {
    left,
    top,
  };
};

const EmojiTable: React.FC<EmojiTablePropsType> = props => {
  const { style = {}, onSelectEmoji, message, toolbarItemRef, handleClose } = props;
  const containerStyle = getListPosition(toolbarItemRef);

  return (
    <Portal>
      <GlobalStyle />
      <div className="emoji-container" style={containerStyle}>
        {emoticons.map(item => (
          <span
            className="emoji-item"
            key={item.name}
            onClick={() => {
              onSelectEmoji?.(item.name, item.name);
              handleClose();
            }}
          >
            <img className="emoji-img" title={item.name} alt={item.name} src={item.icon} />
          </span>
        ))}
        <div style={{ width: 1, flex: 1 }} />
      </div>
      <div className="emoji-mask" />
    </Portal>
  );
};

export default memo(EmojiTable);
