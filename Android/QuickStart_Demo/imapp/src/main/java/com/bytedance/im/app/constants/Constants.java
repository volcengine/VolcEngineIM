package com.bytedance.im.app.constants;

public class Constants {

    public static final int APP_ID = 0;

    public static final String token = "";

    public static final long uid = -1;

    /**
     * 线上环境
     */
    public static final int ENV_RELEASE = 0;
    /**
     * ppe环境
     */
    public static final int ENV_PPE = 2;
    /**
     * boe环境
     */
    public static final int ENV_BOE = 3;
    /**
     * boe环境，不带泳道，跟 boe 的域名不同
     */
    public static final int ENV_BOEi18n = 4;
    /**
     * 默认环境
     */
    public static final int ENV_DEFAULT = ENV_RELEASE;
}
