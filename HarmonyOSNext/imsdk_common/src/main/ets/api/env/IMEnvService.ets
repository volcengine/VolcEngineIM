import { ExpandService } from '../ExpandService';
import { WSParameter } from '../ws/WSParameter';

export interface IMEnvService extends ExpandService {

  initEnv(env: number, lane: string, appID: number): void

  getEnv(): number

  getHost(): string

  getHeaderMap(): Map<string, string>;

  getWSParameter(): WSParameter;

  // getWSHost(): string
}