import { BIMAccountProvider, BIMLoginListener } from "@imcloud/im_sdk_ui";
import { VEIMAppSP } from "../../sp/VEIMAppSP";
import { buildDefaultLoginFragment } from "./VEDefaultLoginFragment";

export class VEDefaultAccountProvider implements BIMAccountProvider {
  logout(): void {
    VEIMAppSP.getInstance().setAgree(false)
  }

  public static APPID = 0
  public static Env = 0

  init(context: Context, appId: number, env: number): void {
    VEDefaultAccountProvider.APPID = appId
    VEDefaultAccountProvider.Env = env
  }

  createLoginFragment(): WrappedBuilder<[BIMLoginListener]> {
    return wrapBuilder(buildDefaultLoginFragment)
  }
}
