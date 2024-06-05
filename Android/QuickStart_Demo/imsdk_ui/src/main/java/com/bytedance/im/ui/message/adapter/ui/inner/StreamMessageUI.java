package com.bytedance.im.ui.message.adapter.ui.inner;

import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.bytedance.im.core.api.enums.BIMStreamStatus;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMTextStreamElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;

@CustomUIType(contentCls = BIMTextStreamElement.class)
public class StreamMessageUI extends BaseCustomElementUI {
    private static final String TAG = "StreamMessageUI";

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_text_stream;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView textView = v.findViewById(R.id.tv_msg_text_stream_content);
        BIMMessage message = messageWrapper.getBimMessage();
        String streamId = message.getStreamId();
        BIMStreamStatus streamStatus = message.getStreamStatus();
        int streamOffset = message.getStreamOffset();
        BIMTextStreamElement streamElement = (BIMTextStreamElement) message.getElement();
        Log.i(TAG, "bind() streamId: " + streamId + " streamStatus: " + streamStatus
                + " streamOffset:" + streamOffset + " message.getUuid(): "
                + message.getUuid() + " msgId:" + message.getServerMsgId()
                + " content:" + message.getContentData()
                + " message.getExtStr(): " + message.getExtStr()
                + " sender: " + message.getSenderUID());
        String answerStr = streamElement.getText();
        if (streamStatus == BIMStreamStatus.BIM_STREAM_STATUS_INTERRUPT) {
            answerStr += "(回复已中断)";
        } else if (streamStatus == BIMStreamStatus.BIM_STREAM_STATUS_FAILED) {
            answerStr += "(回复失败)";
        } else if (streamStatus == BIMStreamStatus.BIM_STREAM_STATUS_APPENDING) {
            answerStr += "...";
        } else if (streamStatus == BIMStreamStatus.BIM_STREAM_STATUS_COMPLETE) {
            //已完成
            answerStr += "(回复完成)";
        } else {
            answerStr += "(未知错误)";
        }
        textView.setText(answerStr);
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }
}
