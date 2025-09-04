/**
 * @madewei
 * @date 2023/11/17
 */
export declare class FileUtils {
    static write(o17: string, p17: string, q17?: boolean): boolean;
    static copyFile(k17: string | number, l17: string | number, m17?: number): void;
    static readWriteFileWithStream(x16: string, y16: string): void;
    static deleteDir(v16: string): void;
    static deleteFile(t16: string): void;
    static read(s16: string): string;
    static trimFile(l16: string, m16: number, n16: (a: string, b: string) => number): Promise<void>;
    static trimDir(e16: string, f16: number, g16: (a: string, b: string) => number): void;
}
