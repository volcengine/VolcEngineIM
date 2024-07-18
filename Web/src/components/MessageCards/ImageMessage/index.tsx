import React, { FC, useState, useEffect } from 'react';
import { FileExtKey, Message } from '@volcengine/im-web-sdk';
import { Image } from '../..';
import { IconDownload } from '../../Icon';
import { download, debounce, parseMessageContent } from '../../../utils';
import ImgBox from './Styles';
import FileProgress from '../../FileProgress';

interface ImageMessagePropsTypes {
  message: Message;
}

const debounceDownLoad = debounce(download, 1000);

const WidthKey = 'file_ext_key_original_width';
const HeightKey = 'file_ext_key_original_height';

const ImageMessage: FC<ImageMessagePropsTypes> = props => {
  const { message } = props;
  let thumbUrl = '';
  const [previewUrl, setPreviewUrl] = useState('');
  const [remoteURL, setRemoteURL] = useState('');
  const [height, setHeight] = useState(100);
  const [width, setWidth] = useState(100);

  const content = message.content && parseMessageContent(message);

  const files = content?.__files;
  const url = content?.url;

  useEffect(() => {
    const getImg = async () => {
      if (files) {
        const keys = Object.keys(files);
        const msgContent = files?.[keys?.[0]];
        thumbUrl = msgContent?.ext?.[FileExtKey.ImgThumbUrl];
        setPreviewUrl(msgContent?.ext?.[FileExtKey.ImgPreviewUrl]);
        setRemoteURL(msgContent?.remoteURL);
        const originWidth = Number(msgContent.ext['s:file_ext_key_original_width']);
        const originHeight = Number(msgContent.ext['s:file_ext_key_original_height']);

        setWidth(Math.min(originWidth, 240) || 100);
        setHeight((originWidth <= 240 ? originHeight : (240 / originWidth) * originHeight) || 100);
      } else if (url) {
        const ext = message.ext || {};

        const originWidth = Number(ext[WidthKey]);
        const originHeight = Number(ext[HeightKey]);

        setWidth(Math.min(originWidth, 240) || 100);
        setHeight((originWidth <= 240 ? originHeight : (240 / originWidth) * originHeight) || 100);

        setPreviewUrl(url);
        setRemoteURL(url);
      }
    };
    getImg();
  }, [content?.__files]);

  return remoteURL ? (
    <ImgBox style={{ width, height }}>
      <Image
        src={previewUrl}
        width={width}
        height={height}
        remoteURL={remoteURL}
        previewProps={{
          actions: [
            {
              key: 'download',
              content: <IconDownload />,
              onClick: () => {
                debounceDownLoad(remoteURL);
              },
            },
          ],
          actionsLayout: ['fullScreen', 'rotateRight', 'zoomIn', 'zoomOut', 'extra'],
        }}
      />
    </ImgBox>
  ) : (
    <FileProgress message={message} />
  );
};

export default ImageMessage;
