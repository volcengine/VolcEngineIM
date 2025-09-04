/**
 * @detail keytype
 * @brief 消息编辑信息。
 */
export declare class BIMEditInfo {
    /**
     * @hidden
     */
    private content_is_edited;
    /**
     * @hidden
     */
    private content_edit_time;
    /**
     * @hidden
     */
    private content_editor;
    /**
     * @detail api
     * @brief 获取消息是否被编辑过
     * @return 获取消息是否被编辑过
     */
    isEdit(): boolean;
    /**
     * @detail api
     * @brief 获取消息编辑时间
     * @return 获取消息编辑时间
     */
    getEditTime(): number;
    /**
     * @detail api
     * @brief 获取消息编辑用户 uid
     * @return 获取消息编辑用户 uid
     */
    getEditorUid(): string;
    /** @hidden */
    constructor(content_is_edited: boolean, content_edit_time: number, content_editor: string);
}
