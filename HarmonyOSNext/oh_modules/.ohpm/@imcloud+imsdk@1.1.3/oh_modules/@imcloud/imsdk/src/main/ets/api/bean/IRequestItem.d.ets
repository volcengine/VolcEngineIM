export interface IRequestItem {
    getCode(): number;
    getStatus(): number;
    getExtraInfo(): string;
    getCheckCode(): bigint;
    getCheckMsg(): string;
    getResponseLogId(): Nullable<string>;
}
