/**
 * @detail keytype
 * @brief 成员列表数据分页结果
 */
export declare class MemberUpdateInfo {
    /**
     * @hidden
     */
    private avatarUrl;
    /**
     * @hidden
     */
    private alias;
    /**
     * @hidden
     */
    private marks;
    /**
     * @hidden
     */
    private ext;
    /**
     * @hidden
     */
    MemberUpdateInfo(): void;
    /**
     * @detail api
     * @brief 获取用户头像 URL。
     * @return 用户头像 URL。
     */
    getAvatarUrl(): string;
    /**
     * @detail api
     * @brief 获取用户额外信息。
     * @return 用户头额外信息。
     */
    getExt(): Map<string, string>;
    /**
     * @detail api
     * @brief 设置用户头像 URL。
     * @param avatarUrl 用户头像 URL。
     */
    setAvatarUrl(avatarUrl: string): void;
    /**
     * @detail api
     * @brief 设置用户额外信息。
     * @param ext 用户额外信息。
     */
    setExt(ext: Map<string, string>): void;
    /**
     * @detail api
     * @brief 获取用户群昵称。
     */
    getAlias(): string;
    /**
     * @detail api
     * @brief 设置用户群昵称。
     * @param alias 用户群昵称。
     */
    setAlias(alias: string): void;
    /**
     * @detail api
     * @brief 设置用户标记。
     */
    getMarks(): string[];
    /**
     * @detail api
     * @brief 设置用户标记。
     * @param marks 用户标记。
     */
    setMarks(marks: string[]): void;
}
