import { ExpandService } from '../ExpandService';
import { IMResponse } from './IMResponse';
import { IMRequest } from './IMRequest';

export interface IMNetService extends ExpandService {
  postHttp(request: IMRequest): Promise<IMResponse>
}