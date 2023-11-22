package com.bytedance.im.ui.message.adapter.ui.inner;

import android.graphics.Color;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiManager;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.utils.BIMUtils;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMTextElement;
import com.bytedance.im.core.proto.MessageStatus;

import java.util.List;


@CustomUIType(contentCls = BIMTextElement.class)
public class TextMessageUI extends BaseCustomElementUI {
    private static final String TAG = "TextMsgViewHolder";

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_text;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView msgContent = v.findViewById(R.id.tv_msg_text_content);
        TextView replayTxt = v.findViewById(R.id.tv_msg_replay_text_content);
        TextView msgReadInfo = v.findViewById(R.id.tv_read_info);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        BIMTextElement content = (BIMTextElement) bimMessage.getElement();
        LinearLayout.LayoutParams replayParam = (LinearLayout.LayoutParams) replayTxt.getLayoutParams();
        LinearLayout.LayoutParams textParam = (LinearLayout.LayoutParams) msgContent.getLayoutParams();

        if (bimMessage.isSelf()) {
            msgContent.setBackgroundResource(R.drawable.shape_im_conversation_msg_send_bg);
            msgContent.setTextColor(msgContent.getContext().getResources().getColor(R.color.business_base_white));
            replayParam.gravity = Gravity.END;
            textParam.gravity = Gravity.END;
        } else {
            msgContent.setBackgroundResource(R.drawable.shape_im_conversation_msg_receive_bg);
            msgContent.setTextColor(msgContent.getContext().getResources().getColor(R.color.business_im_222));
            replayParam.gravity = Gravity.START;
            textParam.gravity = Gravity.START;
        }
        replayTxt.setLayoutParams(replayParam);
        msgContent.setLayoutParams(textParam);
        String msgStr = BIMUtils.fixWebContent(bimMessage.getContentData());
        if (TextUtils.isEmpty(msgStr)) {
            msgStr = content.getText();
        }
        replayTxt.setVisibility(View.GONE);
        if (bimMessage.getReferenceInfo() != null) {
            replayTxt.setVisibility(View.VISIBLE);
            String replay = "引用:";
            if (bimMessage.getReferenceInfo().getStatus() == MessageStatus.AVAILABLE) {
                String fixHint = BIMUtils.fixWebHint(bimMessage.getReferenceInfo().getHint());
                if (TextUtils.isEmpty(fixHint)) {
                    fixHint = bimMessage.getReferenceInfo().getHint();
                }
                replay += fixHint;
            } else if (bimMessage.getReferenceInfo().getStatus() == MessageStatus.DELETED) {
                replay += "消息已被删除";
            } else if (bimMessage.getReferenceInfo().getStatus() == MessageStatus.RECALLED) {
                replay += "消息已被撤回";
            } else if (bimMessage.getReferenceInfo().getStatus() == MessageStatus.INVISIBLE) {
                replay += "消息不可见";
            }
            replayTxt.setText(replay);
        } else {
            replayTxt.setVisibility(View.GONE);
        }
        msgContent.setText(EmojiManager.getInstance().parseEmoJi(v.getContext(), msgStr));
    }

    @Override
    public boolean onLongClickListener(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        List<Long> mentionList = messageWrapper.getBimMessage().getMentionUIDList();
        StringBuilder builder = new StringBuilder("提醒的用户:");
        if (mentionList != null && !mentionList.isEmpty()) {
            for (Long uid : mentionList) {
                builder.append(uid).append(",");
            }
            Toast.makeText(v.getContext(), builder.substring(0, builder.length() - 1), Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public boolean isEnableCopy(BIMMessage bimMessage) {
        return true;
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return bimMessage.isSelf() && bimMessage.getServerMsgId() > 0;
    }

    @Override
    public CharSequence getCopy(BIMMessage bimMessage) {
        BIMTextElement element = (BIMTextElement) bimMessage.getElement();
        String msgStr = BIMUtils.fixWebContent(bimMessage.getContentData());
        if (TextUtils.isEmpty(msgStr)) {
            msgStr = element.getText();
        }
        return msgStr;
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return bimMessage.getServerMsgId() > 0;
    }
}
