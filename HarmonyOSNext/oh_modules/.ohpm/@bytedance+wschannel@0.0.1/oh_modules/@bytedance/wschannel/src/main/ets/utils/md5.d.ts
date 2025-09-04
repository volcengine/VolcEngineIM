interface HasherState {
    buffer: string;
    buflen: number;
    length: number;
    state: number[];
}
export declare class Md5 {
    /**
     * Hash a UTF-8 string on the spot
     * @param str String to hash
     * @param raw Whether to return the value as an `Int32Array`
     */
    static hashStr(o11: string, p11?: false): string;
    static hashStr(o11: string, p11: true): Int32Array;
    /**
     * Hash a Uint8Array on the spot
     * @param arr Uint8Array to hash
     * @param raw Whether to return the value as an `Int32Array`
     * @returns
     */
    static hashArray(m11: Uint8Array, n11?: false): string;
    static hashArray(m11: Uint8Array, n11: true): Int32Array;
    /**
     * Hash a ASCII string on the spot
     * @param str String to hash
     * @param raw Whether to return the value as an `Int32Array`
     */
    static hashAsciiStr(k11: string, l11?: false): string;
    static hashAsciiStr(k11: string, l11: true): Int32Array;
    private static stateIdentity;
    private static buffer32Identity;
    private static hexChars;
    private static hexOut;
    private static onePassHasher;
    private static _hex;
    private static _md5cycle;
    private _dataLength;
    private _bufferLength;
    private _state;
    private _buffer;
    private _buffer8;
    private _buffer32;
    constructor();
    /**
     * Initialise buffer to be hashed
     */
    start(): this;
    /**
     * Append a UTF-8 string to the hash buffer
     * @param str String to append
     */
    appendStr(r10: string): this;
    /**
     * Append an ASCII string to the hash buffer
     * @param str String to append
     */
    appendAsciiStr(l10: string): this;
    /**
     * Append a byte array to the hash buffer
     * @param input array to append
     */
    appendByteArray(f10: Uint8Array): this;
    /**
     * Get the state of the hash buffer
     */
    getState(): HasherState;
    /**
     * Override the current state of the hash buffer
     * @param state New hash buffer state
     */
    setState(z9: HasherState): void;
    /**
     * Hash the current state of the hash buffer and return the result
     * @param raw Whether to return the value as an `Int32Array`
     */
    end(q9?: boolean): string | Int32Array;
}
export {};
