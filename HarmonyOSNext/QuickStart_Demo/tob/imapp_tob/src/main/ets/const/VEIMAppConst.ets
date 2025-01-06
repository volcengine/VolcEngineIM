import { BIMAccountProvider } from '@imcloud/im_sdk_ui';

import { VEDefaultAccountProvider } from '../pages/login/VEDefaultAccountProvider';

export class VEIMAppConst {
  public static APP_ID: number = 666675
  public static uid: string = "1031791415668816";
  public static token: string = "Kv0elRrUSM5v22IYGaUJtfFe1TitISi8WJpONRo1FRGyBk7vt9hMYx"
  public static provider: BIMAccountProvider = new VEDefaultAccountProvider()
}