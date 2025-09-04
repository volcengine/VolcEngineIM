import { BIMImage } from './BIMImage';
import { BIMFileElement } from './BIMFileElement';
import { Message } from '../../../../api/model/Message';
/**
 * @detail keytype
 * @brief 图片消息内容。
 */
export declare class BIMImageElement extends BIMFileElement {
    /**
     * @brief 缩略图信息，参看 {@link BIMImage BIMImage}。
     */
    thumbImg: BIMImage | undefined;
    /**
     * @brief 大图(预览图)信息，参看 {@link BIMImage BIMImage}。
     */
    largeImg: BIMImage | undefined;
    /**
     * @brief 原图信息，参看 {@link BIMImage BIMImage}。
     */
    originImg: BIMImage | undefined;
    /**
     * @hidden
     */
    constructor(msg: Message);
}
