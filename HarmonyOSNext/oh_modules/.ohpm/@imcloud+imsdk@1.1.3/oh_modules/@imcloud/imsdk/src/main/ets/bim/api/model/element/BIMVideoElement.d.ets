import { Message } from '../../../../api/model/Message';
import { BIMFileElement } from './BIMFileElement';
import { BIMImage } from './BIMImage';
/**
 * @detail keytype
 * @brief 视频 Element。
 */
export declare class BIMVideoElement extends BIMFileElement {
    /**
     * @brief 文件远端 URL。
     */
    url: string;
    /**
     * @brief 视频封面图(视频首帧）。
     */
    coverImg: BIMImage;
    /**
     * @hidden
     */
    constructor(msg: Message);
}
