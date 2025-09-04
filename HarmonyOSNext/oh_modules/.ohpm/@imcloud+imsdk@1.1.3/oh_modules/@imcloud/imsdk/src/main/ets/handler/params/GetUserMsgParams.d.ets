/**
 * @see GetUserMsgV2Handler
 */
export interface GetUserMsgParams {
    reason: number;
    from: string;
    withAll: boolean;
    withStrange: boolean;
    withRecent: boolean;
    withMarkRead: boolean;
    withCmd: boolean;
    withConsult: boolean;
}
