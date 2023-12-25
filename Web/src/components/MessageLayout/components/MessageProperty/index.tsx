import React from 'react';
import PropertyContainer from './Styles';
import classNames from 'classnames';
import { name2icon } from '../../../../assets/emotion/map';
import { Message } from '@volcengine/im-web-sdk';
import { useAccountsInfo } from '../../../../hooks';
import { min, sortBy } from 'lodash';

interface IMessageProperty {
  property?: Message['property'];
  isFromMe?: boolean;
  modifyProperty?: (key: string, value: string) => void;
}

const getNameString = (stringArr: string[], accountsInfo: any) => {
  const len = stringArr.length;
  let retStr = '';
  if (len <= 5) {
    stringArr.forEach((item, index) => {
      retStr = retStr + accountsInfo[item]?.name;
      index !== len - 1 && (retStr += ',');
    });
  } else {
    for (let i = 0; i < 5; i++) {
      let item = stringArr[i];
      retStr = `${retStr + accountsInfo[item]?.name},`;
    }
    retStr = `${retStr}+${len - 5}人`;
  }
  return retStr;
};

const MessageProperty: React.FC<IMessageProperty> = ({ property, isFromMe, modifyProperty }) => {
  // 根据每一组最早的发起时间，确定表情顺序
  const propertyNames = sortBy(
    Object.keys(property).map(i => ({
      key: i,
      minTime: min(property[i].map(i => i.createTime)),
    })),
    'minTime'
  ).map(i => i.key);

  const propertyList = [];
  const ACCOUNTS_INFO = useAccountsInfo();
  for (let item of propertyNames) {
    const oneProperty = property[item];
    const emojiName = oneProperty[0]?.key;
    const emojiSrc = name2icon(emojiName);
    const nameList = [];
    sortBy(oneProperty, 'createTime').forEach(item => nameList.push(item.userId));
    const nameString = getNameString(nameList, ACCOUNTS_INFO);
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
