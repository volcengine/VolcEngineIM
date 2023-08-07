import React from 'react';
import PropertyContainer from './Styles';
import classNames from 'classnames';
import { name2icon } from '../../../../assets/emotion/map';

interface IMessageProperty {
  property?: any;
  isFromMe?: boolean;
  modifyProperty?: (key: string, value: string) => void;
}

const getNameString = (stringArr: string[]) => {
  const len = stringArr.length;
  let retStr = '';
  if (len <= 5) {
    stringArr.forEach((item, index) => {
      retStr = retStr + item;
      index !== len - 1 && (retStr += ',');
    });
  } else {
    for (let i = 0; i < 5; i++) {
      retStr = `${retStr + stringArr[i]},`;
    }
    retStr = `${retStr}+${len - 5}人`;
  }
  return retStr;
};

const MessageProperty: React.FC<IMessageProperty> = ({ property, isFromMe, modifyProperty }) => {
  const propertyNames = Object.keys(property);
  const propertyList = [];
  for (let item of propertyNames) {
    const oneProperty = property[item];
    const emojiName = oneProperty[0]?.key;
    const emojiSrc = name2icon(emojiName);
    const nameList = [];
    oneProperty.forEach(item => nameList.push(item.userId));
    const nameString = getNameString(nameList);
    propertyList.push({ emoji: emojiSrc, name: nameString, key: emojiName });
  }
  return (
    <PropertyContainer>
      {propertyList.map(item => (
        <div
          className={classNames({
            'message-property-item': true,
            'self-message': isFromMe,
          })}
          key={item.key}
        >
          <div className="message-property-emoji" onClick={() => modifyProperty(item.key, item.key)}>
            <img className="emoji-img" src={item.emoji} alt="" />
          </div>
          <div className="message-property-separate"></div>
          <div className="message-property-name">
            <div>{item.name}</div>
          </div>
        </div>
      ))}
    </PropertyContainer>
  );
};

export default MessageProperty;
