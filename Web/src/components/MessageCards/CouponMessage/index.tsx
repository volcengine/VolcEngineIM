import React, { memo, useMemo } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import { Bubble } from '../..';
import styles from './index.module.scss';
import { useRequest } from 'ahooks';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance } from '../../../store';
import { Spin } from '@arco-design/web-react';
import { EXT_COUPON_STATUS } from '../../../constant';

interface ITextMessage {
  message: Message;
}

function parseContent(message: string) {
  let content: any;
  try {
    content = JSON.parse(message);
  } catch (error) {
    content = message;
  }

  return content;
}

const CouponMessage = memo((props: ITextMessage) => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const { message } = props;

  const {
    detail = '',
    start,
    end,
  } = useMemo(() => {
    return parseContent(message.content);
  }, [message.content]);

  let rStart = typeof start === 'number' ? start : 0;
  let rEnd = typeof end === 'number' ? end : detail.length;

  const { run, loading } = useRequest(
    async () => {
      return bytedIMInstance.modifyMessage({
        message: message,
        ext: { [EXT_COUPON_STATUS]: '1' },
      });
    },
    {
      manual: true,
    }
  );

  return (
    <Bubble className={styles.container}>
      {message.ext[EXT_COUPON_STATUS] === '1' ? (
        '这是一张优惠券，已领取'
      ) : (
        <>
          {detail.slice(0, rStart)}
          <a
            href={'#'}
            target="_blank"
            rel="noreferrer"
            onClick={e => {
              e.preventDefault();
              run();
            }}
          >
            {detail.slice(rStart, rEnd)}
          </a>
          {detail.slice(rEnd, detail.length)}
          {loading && <Spin size={12}></Spin>}
        </>
      )}
    </Bubble>
  );
});

export default CouponMessage;
