import React, { FC } from 'react';

import { IRichTextElement, IRichTextElements } from '../interface';
import { RichComponentMap } from '../const';

interface ParagraphProps {
  richTextElement?: IRichTextElement;
  richTextElements?: IRichTextElements;
  elementId?: string;
  className?: string;
}

/**
 * 根据childIds渲染解析组件里的children元素
 */
export function parseChildrenContent(props: ParagraphProps) {
  const { richTextElement, richTextElements } = props;
  if (!richTextElement || !richTextElement.childIds) {
    return null;
  }

  const { childIds = [] } = richTextElement;

  return childIds.map(id => {
    const element = richTextElements && richTextElements[id];
    if (!element) {
      // 判断元素不存在逻辑前移, 这样不用在子组件内部进行判空处理
      return null;
    }

    const Cmp = RichComponentMap[element.tag];

    if (!Cmp) {
      return null;
    }

    return (
      <Cmp
        {...props}
        key={id}
        elementId={id}
        richTextElement={element}
        richTextElements={richTextElements}
      />
    );
  });
}

const Paragraph: FC<ParagraphProps> = props => {
  return <>{parseChildrenContent(props)}</>;
};

export default Paragraph;
