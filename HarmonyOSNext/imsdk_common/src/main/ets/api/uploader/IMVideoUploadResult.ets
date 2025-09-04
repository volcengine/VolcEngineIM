export class IMVideoUploadResult {
  readonly mTosKey: string;
  readonly coverUri: string;
  readonly vid: string;

  constructor(uri: string, coverUri: string, vid: string) {
    this.mTosKey = uri;
    this.coverUri = coverUri;
    this.vid = vid;
  }
}