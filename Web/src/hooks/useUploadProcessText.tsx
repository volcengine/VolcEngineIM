import { useRecoilValue } from 'recoil';
import { Message } from '@volcengine/im-web-sdk';

import { FileUploadProcessStore } from '../store';

export default function useUploadProcessText(message: Message) {
  const fileUploadProcessStore = useRecoilValue(FileUploadProcessStore);
  let processInfo = fileUploadProcessStore[message.clientId];
  let fileSize = processInfo?.fileSize ?? 0;
  let percent = processInfo?.percent ?? 0;

  return {
    fileSize,
    percent,
  };
}
