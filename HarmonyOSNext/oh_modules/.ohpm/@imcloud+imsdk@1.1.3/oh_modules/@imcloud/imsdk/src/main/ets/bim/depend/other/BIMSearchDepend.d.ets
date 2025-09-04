import { Message } from '@imcloud/imsdk/../../Index';
import { IIMSearchDepend } from '../../../api/depend/IIMSearchDepend';
export declare class BIMSearchDepend implements IIMSearchDepend {
    getSearchContent(message: Message): string;
    getSearchMsgType(): number[];
}
