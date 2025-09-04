export class Constants {
  /**
   * 海外环境配置
   */
  public static readonly APP_ID_I18N = 889260; //海外appID
  public static readonly APP_ENV = -1; //海外需要配置为 ENV_i18n //国内配置为 ENV_RELEASE


  public static readonly ENV_RELEASE = 0;
  /**
   * ppe环境
   */
  public static readonly ENV_PPE = 2;
  /**
   * boe环境
   */
  public static readonly ENV_BOE = 3;
  /**
   * boe环境，不带泳道，跟 boe 的域名不同
   */
  public static readonly ENV_BOEi18n = 4;

  public static readonly ENV_i18n = 5

  public static readonly ENV_DEFAULT = 0;
}