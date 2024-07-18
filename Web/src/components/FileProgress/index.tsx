import React, { memo, useMemo } from 'react';
import { Message, FlightStatus } from '@volcengine/im-web-sdk';

import styles from './index.module.scss';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance } from '../../store';
import { Progress } from '@arco-design/web-react';
import { IconCloseCircle } from '@arco-design/web-react/icon';
import { useUploadProcessText } from '../../hooks';

interface IFileProgress {
  message: Message;
}

const FileProgress = (props: IFileProgress) => {
  const { message } = props;
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const { flightStatus } = message;
  const { percent } = useUploadProcessText(message);
  const isSending = flightStatus === FlightStatus.Preparing;
  const cancelMediaFileMessagUpload = () => {
    bytedIMInstance.cancelMediaFileMessagUpload({ message });
  };

  return (
    <div className={styles.processContainer}>
      <Progress className={styles.progress} percent={percent} type="circle" />
      {isSending ? (
        <IconCloseCircle className={styles.closeIcon} onClick={cancelMediaFileMessagUpload}></IconCloseCircle>
      ) : null}
    </div>
  );
};

export default FileProgress;
