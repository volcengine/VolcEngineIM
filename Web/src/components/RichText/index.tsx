import React, { FC, useCallback } from 'react';
import { IRichText, IRichTextElement } from './interface';
import { RichComponentMap } from './const';
import RichConainer from './Styles';

interface RichTextProps {
  richText?: IRichText;
  parseStyleKeys?(styleKeys: string[], element: IRichTextElement): string; // 解析element内的StyleKeys, 最终返回需要插入的classname
}

const parseClassName = (
  element: IRichTextElement,
  parseStyleKeys: RichTextProps['parseStyleKeys'],
): string => {
  const { styleKeys } = element;
  if (!parseStyleKeys || !styleKeys || !styleKeys.length) {
    return '';
  }
  return parseStyleKeys(styleKeys, element);
};

const maxElementsEachRender = 200;
const timeoutEachRender = 2000; // ms

const RichText: FC<RichTextProps> = props => {
  const { richText, parseStyleKeys } = props;
  const { elementIds, elements } = richText || {};

  const renderContent = useCallback(() => {
    if (elementIds.length < maxElementsEachRender) {
      return elementIds.map(id => {
        const element = elements[id];
        if (!element) return null;

        const Cmp = RichComponentMap[element.tag];
        const className = parseClassName(element, parseStyleKeys);

        if (!Cmp) {
          return null;
        }

        return (
          <Cmp
            key={id}
            className={className}
            richTextElement={element}
            richTextElements={elements}
            elementId={id}
          />
        );
      });
    }
    // 200以上的 需要分批渲染，防止渲染过多导致卡顿
    return null;
  }, [elementIds, parseStyleKeys]);

  return (
    <RichConainer className="richText-container">
      {renderContent()}
    </RichConainer>
  );
};

export default RichText;
