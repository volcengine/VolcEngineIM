import React, { ImgHTMLAttributes, LegacyRef, useRef, useState, useEffect } from 'react';
import classNames from 'classnames';

import { IconLoading, IconImageClose } from '../Icon';
import ImagePreview from './ImagePreview';
import useImageStatus from './useImageStatus';
import { omit } from '../../utils/tools';

import { ImageProps, ImagePreviewProps } from './interface';
import ImageBox from './Styles';

type ImagePropsType = ImageProps & ImgHTMLAttributes<HTMLImageElement>;

const prefixCls = 'im-image';

const Image = (props: ImagePropsType, ref: LegacyRef<HTMLDivElement>) => {
  const {
    style,
    className,
    src,
    width,
    height,
    title,
    description,
    actions,
    footerPosition,
    simple,
    loader = true,
    error,
    preview = true,
    remoteURL = '',
    previewProps = {} as ImagePreviewProps,
    alt,
    onClick,
    ...restProps
  } = props;

  const previewSrc = previewProps.src || src;

  const wrapClass = classNames(prefixCls, className);

  const refImg = useRef<HTMLImageElement>();
  const [previewVisible, setPreviewVisible] = useState(false);
  const { isLoading, isError, isLoaded, setStatus } = useImageStatus('beforeLoad');

  // 可透传的 preview 属性
  const availablePreviewProps = omit(previewProps, ['visible', 'defaultVisible', 'src', 'onVisibleChange']);

  function onImgLoaded() {
    setStatus('loaded');
  }

  function onImgLoadError() {
    setStatus('error');
  }

  function onImgClick(e) {
    if (preview) {
      setPreviewVisible(true);
    }
    onClick?.(e);
  }

  const onPreviewVisibleChange = newVisible => {
    setPreviewVisible(newVisible);
  };

  useEffect(() => {
    if (!refImg.current) return;
    refImg.current.src = src;
    setStatus('loading');
  }, [src]);

  const defaultError = (
    <div className={`${prefixCls}-error`}>
      <div className={`${prefixCls}-error-icon`}>
        <IconImageClose />
      </div>
      <div className={`${prefixCls}-error-alt`}>{alt}</div>
    </div>
  );

  const defaultLoader = (
    <div className={`${prefixCls}-loader`}>
      <div className={`${prefixCls}-loader-spin`}>
        <IconLoading />
      </div>
    </div>
  );

  const renderLoader = () => {
    if (loader === true) return defaultLoader;

    return loader || null;
  };

  return (
    <ImageBox className={wrapClass} ref={ref as any} {...restProps}>
      <img
        ref={refImg}
        className={`${prefixCls}-img`}
        {...restProps}
        onLoad={onImgLoaded}
        onError={onImgLoadError}
        onClick={onImgClick}
        style={{ width, height }}
      />
      {!isLoaded && (
        <div className={`${prefixCls}-overlay`}>
          {isError && (error || defaultError)}
          {isLoading && renderLoader()}
        </div>
      )}
      {isLoaded && preview && (
        <ImagePreview
          visible={previewVisible}
          src={remoteURL || previewSrc}
          {...availablePreviewProps}
          onVisibleChange={onPreviewVisibleChange}
        />
      )}
    </ImageBox>
  );
};

const RefImageComponent = React.forwardRef<HTMLDivElement, ImagePropsType>(Image);

type ImageComponentType = typeof RefImageComponent & {
  // Preview: typeof ImagePreview;
  // PreviewGroup: typeof ImagePreviewGroup;
};

const ImageComponent: ImageComponentType = RefImageComponent as ImageComponentType;

export default ImageComponent;
