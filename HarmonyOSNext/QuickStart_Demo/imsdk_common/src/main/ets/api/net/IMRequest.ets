import { HashMap } from '@kit.ArkTS';

export class IMRequest {
  private _host: string;

  public get host(): string {
    return this._host;
  }

  private _path: string;

  public get path(): string {
    return this._path;
  }

  private _body: ArrayBuffer;

  public get body(): ArrayBuffer {
    return this._body;
  }

  private _map: HashMap<string, string>;

  public get map(): HashMap<string, string> {
    return this._map;
  }

  constructor(host: string, path: string, body: ArrayBuffer, map: HashMap<string, string>) {
    this._host = host;
    this._path = path;
    this._body = body;
    this._map = map;
  }
}