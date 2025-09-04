import { BIMAccountProvider } from '@imcloud/im_sdk_ui';
import { BIMSMSAccountProvider } from '@imcloud/im_sms_login';
import { VEDefaultAccountProvider } from '../pages/login/VEDefaultAccountProvider';

export class VEIMAppConst {
  public static APP_ID: number = 666675
  public static uid: string = "6767";
  public static token: string = "KOF73IooSthvYwiKbF38huwoZ81g8iiKzPc5b4iU2XaR1ktMRsagLG"
  public static provider: BIMAccountProvider = new VEDefaultAccountProvider()
}