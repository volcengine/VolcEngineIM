export interface IIMLogDepend {
    debug(...args: string[]): void;
    info(...args: string[]): void;
    warn(...args: string[]): void;
    error(...args: string[]): void;
}
