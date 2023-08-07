import React, { FC } from 'react';

import { IRichTextElement, IRichTextElements } from '../interface';

interface MentionProps {
  richTextElement?: IRichTextElement;
  richTextElements?: IRichTextElements;
  elementId?: string;
  className?: string;
}

const Mention: FC<MentionProps> = props => {
  const { richTextElement } = props;
  const mention = richTextElement?.property?.at;

  if (!mention) return null;

  const { content } = mention;

  return <span className="im-mention">{content}</span>;
};

export default Mention;
