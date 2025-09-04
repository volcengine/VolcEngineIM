import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class VEUtils {
  public static startBrowsableAbility(context: common.UIAbilityContext, uri: string): void {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: uri
    };
    context.startAbility(want)
      .then(() => {
        console.error('Start browsableAbility successfully.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
      });
  }
}