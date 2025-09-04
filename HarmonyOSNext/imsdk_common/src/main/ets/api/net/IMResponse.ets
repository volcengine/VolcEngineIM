import { IMNetError } from './IMNetError'

export class IMResponse {
  private _url: string

  private _body: ArrayBuffer
  private _imNetError: IMNetError

  public get imNetError(): IMNetError {
    return this._imNetError
  }


  public get url(): string {
    return this._url
  }

  public get body(): ArrayBuffer {
    return this._body
  }

  private _code: number

  public get code(): number {
    return this._code
  }

  constructor(url: string, body: ArrayBuffer, imNetError: IMNetError, code: number) {
    this._url = url
    this._body = body
    this._imNetError = imNetError
    this._code = code
  }


}