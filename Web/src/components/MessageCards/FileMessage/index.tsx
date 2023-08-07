import React, { memo, useMemo } from 'react';
import { FileExtKey, Message } from '@volcengine/im-web-sdk';
import { Progress } from '@arco-design/web-react';

import { useUploadProcessText } from '../../../hooks';
interface IObjectMessage {
  message: Message;
}

function parseContent(message: Message) {
  const { content } = message;
  let temp1, temp2;
  try {
    temp1 = JSON.parse(content);
    if (temp1 === '') {
      return null;
    }
    temp2 = temp1[Object.keys(temp1)[0]];
    temp1 = temp2[Object.keys(temp2)[0]];
    return temp1;
  } catch (e) {}
}

const ObjectMessage = memo((props: IObjectMessage) => {
  const { message } = props;
  const { percent } = useUploadProcessText(message);
  const content = parseContent(message);

  const fileName = content?.fileName || content?.ext?.[FileExtKey.FileName] || `file.${content?.type}`;

  const handleFileClick = async () => {
    const res = await fetch(content.remoteURL);
    const blob = await res.blob();
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = fileName;
    a.click();
  };

  return (
    <div style={{ padding: 10 }}>
      {content ? (
        <span style={{ cursor: 'pointer', color: 'blue' }} onClick={handleFileClick}>
          {fileName}
        </span>
      ) : (
        <Progress percent={percent} type="circle" />
      )}
    </div>
  );
});

export default ObjectMessage;
