import React, { FC, useState, useEffect, useCallback, useRef } from 'react';

import { Transition } from '..';
import { IconClose } from '@arco-design/web-react/icon';
import SearchModelBox from './Styles';
import { useThrottleFn } from 'ahooks';

interface SearchModelProps {
  getMore?: () => void;
  doSearch?: (value: any) => void;
  onMaskClick?: () => void;
  onClose?: () => void;
  query?: string;
}

let timer: any;
const THROTTLE_TIME = 200;
const SearchModel: FC<SearchModelProps> = props => {
  const { onMaskClick, onClose, doSearch, query } = props;

  const [show, setShow] = useState(false);
  const [activeIndex, setActiveIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const isComposing = useRef(false);

  useEffect(() => {
    setShow(true);

    return () => {
      clearTimeout(timer);
    };
  }, []);

  const handleMaskClick = useCallback(() => {
    setShow(false);

    timer && clearTimeout(timer);
    timer = setTimeout(() => {
      onMaskClick();
      timer = null;
    }, 300);
  }, [onMaskClick]);

  const handleClose = useCallback(() => {
    setShow(false);

    timer && clearTimeout(timer);
    timer = setTimeout(() => {
      onClose?.();
      timer = null;
    }, 300);
  }, []);

  const { run: handleScroll } = useThrottleFn(() => {
    // if (!this.scrollContainer) return;
    // const { getMoreSearch, getAdvancedFormResult, currentCmd } = this.props;
    // const { scrollTop, scrollHeight, clientHeight } = this.scrollContainer;
    // if (scrollHeight - scrollTop - clientHeight > 150) return;
    // const options = getAdvancedFormResult();
    // getMoreSearch(options);
  }, { wait: 300 });

  const { run: fetchSearchQuery } = useThrottleFn(
    (inputValue, compositionInfo?: any) => {
      const inputDom = inputRef.current;
      let value = inputDom && inputDom.value.trim();
      let options;
      if (!inputDom) {
        value = inputValue;
      }
      if (isComposing.current) {
        value = value.replace(/'/g, '');
      }

      doSearch(value);
      setActiveIndex(0);
    },
    {
      wait: THROTTLE_TIME
    },
  );

  const handleInputChange = useCallback(() => {
    fetchSearchQuery('');
  }, [fetchSearchQuery]);

  // 监听中文的变化
  const handleCompositionStart = useCallback(() => {
    isComposing.current = true;
  }, []);

  const handleCompositionEnd = useCallback(() => {
    isComposing.current = false;
  }, []);

  const handleItemMouseEnter = () => { };

  const topResultItemClick = () => { };

  return (
    <Transition in={show} duration={300} classNames="fadeIn" mountOnEnter>
      <SearchModelBox className="im-modal-wrapper">
        <div className="im-modal-mask" onClick={handleMaskClick} />
        <div className="im-modal-body">
          <div className="quickJump">
            <div className="quickJump_input_box">
              <input
                type="text"
                placeholder="查找会话、消息"
                autoFocus={true}
                ref={inputRef}
                defaultValue={query}
                className="quickJump_input"
                onChange={handleInputChange}
                onCompositionStart={handleCompositionStart}
                onCompositionEnd={handleCompositionEnd}
              />
              <div className="search-clear" onClick={handleClose}>
                <IconClose />
              </div>
            </div>
            <div className="quickJump_result">
              <div
                className="jumpItem is-active"
                data-index=""
                onMouseEnter={handleItemMouseEnter}
                onClick={topResultItemClick}>
                <div className="jumpItem-avatar">
                  <img
                    className="im-avatar-img"
                    alt="Avatar"
                    src="data:image/png;base64,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"
                  />
                </div>
                <div className="jumpItem_info">
                  <div className="jumpItem_nameWrapper">
                    <p className="jumpItem_name">搜索消息、文档、表格...</p>
                  </div>
                </div>
                <div className="jumpItem_arrow">
                  <i className="lark-icon-expand msgItem_extraMsg-arrow"></i>
                </div>
              </div>
            </div>
            {/* {searchResult && Boolean(searchResult.size) && hasMore &&
              <ObserverItem onObserve={this.handleScroll} />
            } */}
          </div>
        </div>
      </SearchModelBox>
    </Transition>
  );
};

export default SearchModel;
