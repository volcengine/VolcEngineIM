package com.bytedance.im.ui.conversation.adapter.viewhodler;

import android.graphics.Color;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMStrangeBox;
import com.bytedance.im.core.model.inner.msg.BIMBaseElement;
import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.core.service.manager.BIMMessageManager;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.conversation.adapter.VEViewHolder;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.utils.BIMUINameUtils;
import com.bytedance.im.ui.utils.BIMUtils;

import java.text.SimpleDateFormat;
import java.util.Locale;

public class VEStrangeBoxViewHolder extends VEViewHolder<VEConvBaseWrapper<BIMStrangeBox>> {

    private ImageView userHeadImg;
    private TextView nickName;
    private TextView unReadIcon;
    private ImageView conversationType;
    private TextView lastTime;
    private TextView lastMsg;
    private ImageView conversationMute;
    private ImageView conversationTop;
    private View root;
    private RecyclerView recyclerView;

    public VEStrangeBoxViewHolder(@NonNull View itemView, RecyclerView recyclerView) {
        super(itemView);
        this.recyclerView = recyclerView;
        root = itemView.findViewById(R.id.root);
        userHeadImg = itemView.findViewById(R.id.iv_conversation_user_img);
        nickName = itemView.findViewById(R.id.tv_conversation_user_name);
        unReadIcon = itemView.findViewById(R.id.tv_conversation_unread_num);
        conversationType = itemView.findViewById(R.id.iv_conversation_type);
        lastTime = itemView.findViewById(R.id.tv_conversation_last_time);
        lastMsg = itemView.findViewById(R.id.tv_conversation_last_msg);
        conversationMute = itemView.findViewById(R.id.iv_conversation_mute);
        conversationTop = itemView.findViewById(R.id.iv_conversation_top);
    }


    @Override
    public void bind(VEConvBaseWrapper<BIMStrangeBox> strangeBoxWrapper) {
        super.bind(strangeBoxWrapper);
        BIMStrangeBox strangeBox = strangeBoxWrapper.getInfo();
        BIMConversation bimConversation = strangeBox.getBimConversation();
        int boxUnread = strangeBox.getUnReadCount();

        userHeadImg.setImageResource(R.drawable.default_icon_group);
        nickName.setText("陌生人盒子");
        if (bimConversation != null) {

            //会话未读数
            unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_mute_unread_num_bg));
            if (boxUnread > 99) {
                unReadIcon.setText("99+");
            } else {
                unReadIcon.setText("" + boxUnread);
            }
            if (boxUnread > 0) {
                unReadIcon.setVisibility(View.VISIBLE);
            } else {
                unReadIcon.setVisibility(View.GONE);
            }

            //会话最新时间
            lastTime.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimConversation.getUpdatedTime()));
            //会话类型 - 轻直播
            conversationType.setVisibility(View.GONE);
            //会话消息 - 草稿
            if (!TextUtils.isEmpty(bimConversation.getDraftText())) {
                SpannableString str = new SpannableString("[草稿]" + bimConversation.getDraftText());
                str.setSpan(new ForegroundColorSpan(Color.RED), 0, 3, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                lastMsg.setText(str);
                lastMsg.setVisibility(View.VISIBLE);
            } else {
                //会话最后一条消息
                BIMMessage lastMessage = bimConversation.getLastMessage();
                if (lastMessage != null) {
                    BIMUIUser user = getBIMUIUSerOrAsyncRefresh(lastMessage.getSenderUID());
                    if (user == null) {
                        return;
                    }
                    if (lastMessage.isRecalled()) {
                        lastMsg.setText(BIMUtils.generateRecallHint(lastMessage, user));
                    } else {
                        BIMBaseElement content = null;
                        if (lastMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) { //自定义消息解析
                            BIMCustomElement element = (BIMCustomElement) lastMessage.getElement();
                            content = BIMMessageManager.getInstance().decode(element.getData());
                            if (content == null) {
                                content = new BIMBaseElement();
                            }
                        } else {
                            content = lastMessage.getElement();
                        }
                        String prefix = BIMUINameUtils.getShowName(user) + ": ";
                        if (content instanceof BIMGroupNotifyElement) {
                            prefix = "";
                        }
                        if (content != null) {
                            lastMsg.setText(prefix + content.getMsgHint());
                        }
                        //兼容web 临时逻辑,后续删除
                        if (lastMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
                            String msgStr = BIMUtils.fixWebContent(lastMessage.getContentData());
                            if (!TextUtils.isEmpty(msgStr)) {
                                lastMsg.setText(prefix + msgStr);
                            }
                        }
                    }
                } else {
                    lastMsg.setText("");
                }
                if (lastMsg.getText() == null || lastMsg.getText().toString().isEmpty()) {
                    lastMsg.setVisibility(View.GONE);
                } else {
                    lastMsg.setVisibility(View.VISIBLE);
                }
            }
        } else {
            unReadIcon.setVisibility(View.GONE);
            lastMsg.setVisibility(View.GONE);
        }

    }


    private BIMUIUser getBIMUIUSerOrAsyncRefresh(long uid) {
        BIMUIUser user = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid);
        if (user == null) {
            BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(uid, new BIMResultCallback<BIMUIUser>() {
                @Override
                public void onSuccess(BIMUIUser bimuiUser) {
                    recyclerView.getAdapter().notifyItemChanged(getAdapterPosition());
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
        return user;
    }
}
