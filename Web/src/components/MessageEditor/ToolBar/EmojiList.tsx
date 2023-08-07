import React, { CSSProperties, memo, useCallback } from 'react';
import { GlobalStyle } from './Styles';
import { emoticons } from '../../../assets/emotion/map';

export interface EmojiType {
  name: string;
  icon: any;
}

interface EmojiListPropsType {
  style?: CSSProperties;
  list?: EmojiType[];
  onSelectEmoji?: (val: EmojiType) => void;
  onMaskClick?: () => void;
}

const EmojiPanel: React.FC<EmojiListPropsType> = props => {
  const { list = [], style = {}, onSelectEmoji, onMaskClick } = props;

  const handleMaskClick = useCallback(() => {
    onMaskClick?.();
  }, [onMaskClick]);

  return (
    <>
      <GlobalStyle />
      <span className="emojis">
        <div
          className="emoji-container"
          style={{
            ...style,
          }}
        >
          {emoticons.map(item => (
            <span
              className="emoji-item"
              key={item.name}
              onClick={() => {
                onSelectEmoji?.(item);
              }}
            >
              <img className="emoji-img" title={item.name} alt={item.name} src={item.icon} />
            </span>
          ))}
          <div style={{ width: 1, flex: 1 }} />
        </div>

        <div className="emoji-mask" onClick={handleMaskClick} />
      </span>
    </>
  );
};

export default memo(EmojiPanel);
