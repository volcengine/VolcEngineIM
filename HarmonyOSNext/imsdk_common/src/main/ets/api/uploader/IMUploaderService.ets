import { ExpandService } from '../ExpandService';
import { IMAccessor } from '../IMAccessor';
import { IMImageUploadResult } from './IMImageUploadResult';
import { IMUploadListener } from './IMUploadListener';
import { IMUploadTokenInfo } from './IMUploadTokenInfo';
import { IMVideoUploadResult } from './IMVideoUploadResult';

export abstract class IMUploaderService implements  ExpandService{
  constructor() {
  }

  onConfigReady(json: string): void {
  }

  init(context: Context, imAccessor: IMAccessor): void {
  }

  unInit(context: Context): void {
  }

  onLogin(context: Context, uid: bigint): void {
  }

  onLogout(): void {
  }
  public static readonly TYPE_FILE = 0;
  public static readonly TYPE_IMAGE = 1;
  public static readonly TYPE_VIDEO = 2;
  public static readonly TYPE_AUDIO = 3;

  public abstract uploadImage(path: string, type: number, isEncrpty: boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMImageUploadResult>): void

  public abstract uploadVideo(path: string, type: number, isEncrpty: Boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMVideoUploadResult>): void
}