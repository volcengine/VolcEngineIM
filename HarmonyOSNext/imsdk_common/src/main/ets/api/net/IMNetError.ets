export class IMNetError{
  private _stack: string

  public get stack(): string {
    return this._stack
  }

  private _code: number

  public get code(): number {
    return this._code
  }

  private _logId: string

  public get logId(): string {
    return this._logId
  }

  private _message: string

  public get message(): string {
    return this._message
  }

  constructor(stack: string, code: number, logId: string, message: string) {
    this._stack = stack
    this._code = code
    this._logId = logId
    this._message = message
  }



}