import { BIMAccountProvider } from '@imcloud/im_sdk_ui';

import { VEDefaultAccountProvider } from '../pages/login/VEDefaultAccountProvider';

export class VEIMAppConst {
  public static APP_ID: number = 666675
  public static uid: string = "";
  public static token: string = ""
  public static provider: BIMAccountProvider = new VEDefaultAccountProvider()
}