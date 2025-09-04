import { Message } from '../../api/model/Message';
import { BIMBaseElement } from '../api/model/element/BIMBaseElement';
export declare class ContentGsonUtils {
    private TAG;
    static fromJson(message: Message): BIMBaseElement;
}
