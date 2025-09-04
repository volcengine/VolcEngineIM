/**
 * @detail keytype
 * @brief 群组信息。
 */
export declare class BIMGroupInfo {
    /**
     * @brief 群聊名称。
     */
    name: string;
    /**
     * @brief 群头像。
     */
    avatarUrl: string;
    /**
     * @brief 群描述。
     */
    desc: string;
    /**
     * @brief 群公告。
     */
    notice: string;
    /**
     * @brief 群组自定义字段。
     */
    map: Map<string, string>;
}
