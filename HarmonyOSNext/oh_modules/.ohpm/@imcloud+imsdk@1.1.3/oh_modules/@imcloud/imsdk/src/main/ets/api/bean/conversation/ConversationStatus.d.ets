declare class ConversationStatus {
    static get(status: number, mask: number): number;
    static set(status: number, mask: number, s: number): number;
}
/**
 * status低1位表示群聊是否解散，默认为0，未解散
 */
export declare class Dissolve extends ConversationStatus {
    static MASK: number;
    static DISSOLVED: number;
    static NOT_DISSOLVED: number;
    static get(status: number): number;
    static set(status: number, dissolved: number): number;
}
/**
 * status低2位表示会话是否展示，默认为0，显示
 */
export declare class Display extends ConversationStatus {
    static MASK: number;
    static DISPLAYED: number;
    static NOT_DISPLAYED: number;
    static get(status: number): number;
    static set(status: number, displayed: number): number;
}
export {};
