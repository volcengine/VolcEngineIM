import { IMAccessor } from '../IMAccessor';
import { IMCommonCallback } from '../interfaces/IMCommonCallback';
import { IMDeviceInfo } from './IMDeviceInfo';
import { IMLogService } from './IMLogService';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class IMDefaultLog extends IMLogService {
  private imAccessor: IMAccessor | undefined;

  init(context: Context, imAccessor: IMAccessor): void {
    this.imAccessor = imAccessor;
  }

  async getDeviceInfo(): Promise<IMDeviceInfo> {
    let uid = this.imAccessor?.uid ?? 0
    let uidStr = uid.toString();
    return new IMDeviceInfo(uidStr, uidStr);
  }

  onEvent(event: string, data: Record<string, string>): void {
    hilog.info(0xFF00, `[imsdk]`, `IMDefaultLog -> onEvent event:${event} data:\n ${JSON.stringify(data, undefined, 2)}`)
  }

  log(level: number, tag: string, content: string): void {
    hilog.info(0xFF00, `[imsdk]`, `${tag} -> ${content}`)
  }
}