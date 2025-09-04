package com.bytedance.im.live.reporter;

import com.bytedance.im.imcloud.internal.utils.Mob;
import com.bytedance.im.imcloud.metric.TeaEventMonitorBuilder;

public class
BIMLiveReporter {
    public static final String TAG = "LiveReporter";

    private static final class SingleHolder {
        private static final BIMLiveReporter liveReporter = new BIMLiveReporter();
    }

    public static BIMLiveReporter getInstance(){
        return SingleHolder.liveReporter;
    }

    public void reportJoinLive(long startTime, long endTime, boolean isSuccess, int code, String msg, long conversationId) {
        TeaEventMonitorBuilder.newBuilder().event(Mob.EVENT_JOIN_LIVE_GORUP)
                .appendParam("is_success", isSuccess)
                .appendParam("error_code", code)
                .appendParam("sdk_start_time", startTime)
                .appendParam("sdk_end_time", endTime)
                .appendParam("sdk_cost_time", endTime - startTime)
                .appendParam("error_msg", msg)
                .appendParam("conversation_id", conversationId)
                .appendParam("result", isSuccess)
                .monitor();
    }

    public void reportCreateLive(boolean isSuccess, long startTime, long endTime, long conversationShortId, int errorCode, String errorMsg) {
        TeaEventMonitorBuilder.newBuilder().event(Mob.EVENT_CREATE_LIVE_GROUP)
                .appendParam("result", isSuccess)
                .appendParam("error_code", errorCode)
                .appendParam("sdk_start_time", startTime)
                .appendParam("sdk_end_time", endTime)
                .appendParam("sdk_cost_time", endTime - startTime)
                .appendParam("error_msg", errorMsg)
                .appendParam("conversation_id", conversationShortId)
                .monitor();
    }

    public void reportLeaveLive(boolean isSuccess, long startTime, long endTime, long conversationShortId, int errorCode, String errorMsg) {
        TeaEventMonitorBuilder.newBuilder().event(Mob.EVENT_LEAVE_LIVE_GROUP)
                .appendParam("result", isSuccess)
                .appendParam("error_code", errorCode)
                .appendParam("sdk_start_time", startTime)
                .appendParam("sdk_end_time", endTime)
                .appendParam("sdk_cost_time", endTime - startTime)
                .appendParam("error_msg", errorMsg)
                .appendParam("conversation_id", conversationShortId)
                .monitor();
    }
}
