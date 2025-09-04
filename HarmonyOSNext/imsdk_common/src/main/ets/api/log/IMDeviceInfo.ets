export class IMDeviceInfo {
  private _did: string

  public get did(): string {
    return this._did
  }

  private _iid: string

  public get iid(): string {
    return this._iid
  }

  constructor(did: string, iid: string) {
    this._did = did
    this._iid = iid
  }

  public platform:string = "openHarmony"

  toString() {
    return `{did:${this._did},iid:${this._iid}`
  }
}