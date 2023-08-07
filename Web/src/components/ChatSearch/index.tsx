import React, { FC, useCallback, useState, useRef } from 'react';

import { SearchInput, Result } from '..';
import NoMessagePic from '../../assets/images/chat-search-no-message.png';

import ChatSearchBox from './Styles';

interface ChatSearchProps {
  messageItems?: any[];
  shouldRenderLoading?: boolean;
  doSearch?: (query: string) => void;
  clearSearch?: () => void;
  deletePin?: () => void;
  getMoreSearchMessage?: () => void;
  jumpToMessage?: () => void;
}

const ChatSearch: FC<ChatSearchProps> = props => {
  const {
    messageItems = [],
    shouldRenderLoading = false,
    getMoreSearchMessage,
    jumpToMessage,
    doSearch,
    clearSearch,
  } = props;

  const [query, setQuery] = useState('');
  const isComposing = useRef(false);

  
  const handleChange = (event: React.ChangeEvent<any>) => {
    const curQuery = event.target.value;
    setQuery(curQuery);

    let updateQuery = curQuery.trim().toLowerCase();

    if (!curQuery) {
      clearInputSearch();
    }

    if (isComposing.current) {
      updateQuery = updateQuery.replace(/'/g, '');
    }

    doSearch?.(updateQuery);
  };

  const clearInputSearch = useCallback(() => {
    setQuery('');
    clearSearch?.();
  }, [clearSearch]);

  const handleCompositionEnd = useCallback(() => {
    isComposing.current = false;
  }, []);

  const handleCompositionStart = useCallback(() => {
    isComposing.current = true;
  }, []);

  const handleClear = useCallback(() => {
    setQuery('');
  }, []);

  const renderSearchList = () => {
    if (query) {
      if (!messageItems.length) {
        return (
          <Result className="chat-message-empty" icon={<img src={NoMessagePic} alt="" />} subTitle={'未找到匹配结果'} />
        );
      }
    }

    return (
      <Result className="chat-message-empty" icon={<img src={NoMessagePic} alt="" />} subTitle={'搜索会话中的消息'} />
    );
  };

  return (
    <ChatSearchBox className="chat-search">
      <div className="chat-search-header">
        <h2 className="chat-search-title">搜索</h2>
      </div>
      <div className="chat-search-input-wrap">
        <SearchInput
          placeholder="搜索"
          type="text"
          value={query}
          onChange={handleChange}
          onCompositionStart={handleCompositionStart}
          onCompositionEnd={handleCompositionEnd}
          onClear={handleClear}
        />
      </div>
      <div className="chat-search-list">{renderSearchList()}</div>
    </ChatSearchBox>
  );
};

export default ChatSearch;
