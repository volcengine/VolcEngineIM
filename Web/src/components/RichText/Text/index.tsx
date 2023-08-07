import React, { FC } from 'react';

import { IRichTextElement, IRichTextElements } from '../interface';

interface TextProps {
  richTextElement?: IRichTextElement;
  richTextElements?: IRichTextElements;
  elementId?: string;
  className?: string;
}

const Text: FC<TextProps> = props => {
  const { richTextElement, elementId } = props;
  if (!richTextElement) return null;

  const { property } = richTextElement;
  const piece = property?.text?.content;

  if (!piece) return null;

  return (
    <span className="im-text-only" data-eleid={elementId}>
      {piece}
    </span>
  );
};

export default Text;
