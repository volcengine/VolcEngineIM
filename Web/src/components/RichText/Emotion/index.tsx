import React, { FC, useMemo } from 'react';

import { name2icon } from '../../../assets/emotion/map';
import { IRichTextElement, IRichTextElements } from '../interface';

interface EmotionProps {
  richTextElement?: IRichTextElement;
  richTextElements?: IRichTextElements;
  elementId?: string;
  className?: string;
}

const Emotion: FC<EmotionProps> = props => {
  const { richTextElement, elementId } = props;

  const { property } = richTextElement;
  const key = property?.emotion?.key;

  const icon = useMemo(() => {
    return name2icon(key);
  }, [key]);

  return (
    <span className="im-rich-emoji">{Boolean(icon) && <img className="im-rich-emoji_img" src={icon} alt={key} />}</span>
  );
};

export default Emotion;
