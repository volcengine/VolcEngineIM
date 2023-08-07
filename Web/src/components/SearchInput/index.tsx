import React, { FC } from 'react';
import { IconClose } from '@arco-design/web-react/icon';

import IconFillSearch from '../Icon/IconFillSearch';
import SearchInputBox from './Styles';

interface PinSearchProps extends Partial<React.InputHTMLAttributes<HTMLInputElement>> {
  onClear?: () => void;
}

const PinSearch: FC<PinSearchProps> = props => {
  const { value, onClear, ...other } = props;

  return (
    <SearchInputBox className="search-input-wrap">
      <span className="search-icon input-search-icon">
        <IconFillSearch />
      </span>
      <input type="text" value={value} className="search-input" placeholder="搜索" {...other} />
      {value && (
        <span className="search-icon input-close-icon" onClick={onClear}>
          <IconClose />
        </span>
      )}
    </SearchInputBox>
  );
};

export default PinSearch;
