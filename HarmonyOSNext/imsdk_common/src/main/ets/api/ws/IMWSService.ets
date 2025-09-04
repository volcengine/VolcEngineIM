import { IMEnvService } from '../env/IMEnvService';
import { ExpandService } from '../ExpandService';
import { IMLogService } from '../log/IMLogService';
import { IMWSConnectListener } from './IMWSConnectListener';
import { IMWSMsgInfo } from './IMWSMsgInfo';
import { WSParameter } from './WSParameter';

export interface IMWSService extends ExpandService {
  initWs(env: IMEnvService,logger:IMLogService):void

  connect(wsParameter: WSParameter): Promise<boolean>

  setConnectChangedListener(statusListener: IMWSConnectListener): void

  setOnReceiveListener(listener:(data:IMWSMsgInfo)=>void):void

  isConnect(): boolean

  geConnectStatus(): number

  sendMsg(data: IMWSMsgInfo): void

  disConnect(): Promise<boolean>

  onAppForegroundChang(isForeground: boolean):void

}