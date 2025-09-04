import { ExpandService } from '../ExpandService';
import { IMAccessor } from '../IMAccessor';
import { IMCommonCallback } from '../interfaces/IMCommonCallback';
import { IMDeviceInfo } from './IMDeviceInfo';
import { ValueType } from '@kit.ArkData';

export abstract class IMLogService implements ExpandService {
  static level_debug = 1;
  static level_info = 2;
  static level_warn = 3;
  static level_error = 4;

  abstract getDeviceInfo(callback: (deviceInfo: IMDeviceInfo) => void)

  abstract onEvent(event: string, data: Record<string, ValueType>): void

  abstract log(level: number, tag: string, content: string): void

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
}