import { Message } from '../../../../api/model/Message';
import { BIMBaseElement } from './BIMBaseElement';
/**
 * @detail keytype
 * @brief 文件消息内容 Element。
 */
export declare class BIMFileElement extends BIMBaseElement {
    /**
     * @brief 文件名称。
     */
    fileName: string;
    /**
     * @brief 文件本地路径(可能为空)。
     */
    localURI: string;
    /**
     * @brief 文件大小(单位: B)。
     */
    fileSize: number;
    /**
     * @brief 文件远端 URL。
     */
    url: string;
    /**
     * @hidden
     */
    constructor(message: Message);
}
