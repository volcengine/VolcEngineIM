import { CSSProperties, HTMLAttributes, ReactNode } from 'react';

export type PartialImagePreviewProps = Partial<ImagePreviewProps>;

export interface ImageProps {
  style?: CSSProperties;
  className?: string | string[];
  /** 图片获取地址 */
  src: string;
  /** 原图获取地址 */
  remoteURL?: string;
  /** 图片显示宽度 */
  width?: string | number;
  /** 图片显示高度 */
  height?: string | number;
  /** 标题 */
  title?: string;
  /** 描述 */
  description?: string;
  /** 额外操作 */
  actions?: ReactNode[];
  /** 底部显示的位置 */
  footerPosition?: 'inner' | 'outer';
  /** 是否开启简洁模式 */
  simple?: boolean;
  /** 加载过渡效果，为true显示默认加载效果 */
  loader?: boolean | ReactNode;
  /** loader 的样式，将覆盖默认过渡效果 */
  loaderClassName?: string | string[];
  /** error 状态下显示的内容 */
  error?: ReactNode;
  /** 是否开启预览 */
  preview?: boolean;
  /** 预览的配置项 （所有选项都是可选的） [ImagePreviewProps](#imagepreview) */
  previewProps?: PartialImagePreviewProps;
}

export interface ImagePreviewProps {
  style?: CSSProperties;
  className?: string | string[];
  /** 图片获取地址, 在 Image 中 默认是 Image 的 src */
  src: string;
  /** 是否可见，受控属性 */
  visible?: boolean;
  /** 触发 toolbar 切换为 simple 模式的宽度 */
  breakPoint?: number;
  /** 点击 mask 是否触发关闭 */
  maskClosable?: boolean;
  /** 是否显示关闭按钮  */
  closable?: boolean;
  /** 额外操作，[ImagePreviewActionProps](#imagepreviewactionprops) */
  actions?: ImagePreviewActionProps[];
  /** 控制条的布局 */
  actionsLayout?: string[];
  /** 切换可见状态触发的事件 */
  onVisibleChange?: (visible: boolean, preVisible: boolean) => void;
  /** 弹出层挂载的节点 */
  getPopupContainer?: () => HTMLElement;
}

// @ts-ignore
export interface ImagePreviewActionProps extends HTMLAttributes<HTMLDivElement> {
  /** 唯一标识 */
  key: string;
  /** 内容 */
  content: ReactNode;
  /** 因为content只能定义内容，所以提供这个函数用于支持自定义外围元素，需要注意的是设置了 `getContainer`, 显示 `name` 的 `Tooltip`将失效 */
  getContainer?: (actionElement: ReactNode) => ReactNode;
  /** 是否禁用，默认为 `false` */
  disabled?: boolean;
}
