import { InnerService } from './InnerService';

export interface ExpandService extends InnerService {
  onConfigReady(json: string): void
}