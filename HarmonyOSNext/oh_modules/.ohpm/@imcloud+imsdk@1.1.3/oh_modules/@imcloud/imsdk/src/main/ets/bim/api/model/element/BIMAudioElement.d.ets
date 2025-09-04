import { Message } from '../../../../api/model/Message';
import { BIMFileElement } from './BIMFileElement';
/**
 * @detail keytype
 * @brief 语音消息内容 Element。
 */
export declare class BIMAudioElement extends BIMFileElement {
    /**
     * @brief 录音时长(单位 秒)。
     */
    duration: number;
    /**
     * @brief 文件远端 URL。
     */
    url: string;
    /**
     * @brief 文件本地路径(可能为 null )
     */
    localURI: string;
    /**
     * @hidden
     */
    constructor(message: Message);
}
