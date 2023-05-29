package com.bytedance.im.ui.conversation.adapter.viewhodler;

import android.graphics.Color;
import android.support.annotation.NonNull;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.conversation.adapter.VEViewHolder;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.message.convert.manager.BIMMessageManager;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.ui.utils.BIMUtils;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMBaseElement;

import java.text.SimpleDateFormat;
import java.util.Locale;

public class VEConversationViewHolder extends VEViewHolder<VEConvBaseWrapper<BIMConversation>> {
    private ImageView userHeadImg;
    private TextView nickName;
    private TextView unReadIcon;
    private ImageView conversationType;
    private TextView lastTime;
    private TextView lastMsg;
    private ImageView conversationMute;
    private ImageView conversationTop;
    private View root;

    public VEConversationViewHolder(@NonNull View itemView) {
        super(itemView);
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
    public void bind(VEConvBaseWrapper<BIMConversation> conversationVEConversationWrapper) {
        BIMConversation bimConversation = conversationVEConversationWrapper.getInfo();
        String name = "";
        int img = R.drawable.icon_recommend_user_default;
        if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
            BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(bimConversation.getOppositeUserID());
            if (user == null) {
                name = String.valueOf(bimConversation.getOppositeUserID());
                userHeadImg.setImageResource(R.drawable.icon_recommend_user_default);
            } else {
                img = user.getHeadImg();
                name = user.getNickName();
                if (TextUtils.isEmpty(user.getUrl())) {
                    userHeadImg.setImageResource(img);
                } else {
                    Glide.with(userHeadImg.getContext()).load(user.getUrl())
                            .placeholder(R.drawable.icon_recommend_user_default)
                            .error(R.drawable.icon_recommend_user_default)
                            .into(userHeadImg);
                }
            }
        } else {
            //todo 组件化
            if (!TextUtils.isEmpty(bimConversation.getName())) {
                name = bimConversation.getName();
            } else {
                name = "未命名群聊";
            }
            img = R.drawable.default_icon_group;
            userHeadImg.setImageResource(img);
        }
        nickName.setText(name);
        int textColor = R.color.business_im_222;
        if (bimConversation.isDissolved()) {
            textColor = R.color.business_im_999;
        }
        nickName.setTextColor(itemView.getContext().getResources().getColor(textColor));
        //会话未读数
        if (bimConversation.getUnReadCount() > 0) {
            long realCount = bimConversation.getUnReadCount();
            //会话静音但有未读
            if (bimConversation.isMute()) {//免打扰
                unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_mute_unread_num_bg));
            } else { //正常
                unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_unread_num_bg));
            }
            if (realCount > 99) {
                unReadIcon.setText("99+");
            } else {
                unReadIcon.setText("" + realCount);
            }
            if (realCount > 0) {
                unReadIcon.setVisibility(View.VISIBLE);
            } else {
                unReadIcon.setVisibility(View.GONE);
            }
        } else {
            unReadIcon.setVisibility(View.GONE);
        }
        //会话静音
        if (bimConversation.isMute()) {
            conversationMute.setVisibility(View.VISIBLE);
        } else {
            conversationMute.setVisibility(View.GONE);
        }
        //会话置顶
        if (bimConversation.isStickTop()) {
            conversationTop.setVisibility(View.VISIBLE);
        } else {
            conversationTop.setVisibility(View.GONE);
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
            return;
        }
        //会话最后一条消息
        BIMMessage lastMessage = bimConversation.getLastMessage();
        if (lastMessage != null) {
            if (lastMessage.isRecalled()) {
                lastMsg.setText(BIMUtils.generateRecallHint(lastMessage));
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
                String userName = "";
                BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(lastMessage.getSenderUID());
                if (user == null) {
                    userName = lastMessage.getSenderUID()+"";
                }else {
                    userName = user.getNickName();
                }
                String prefix = userName+": ";
                if(content instanceof BIMGroupNotifyElement){
                    prefix = "";
                }
                if (content != null) {
                    lastMsg.setText(prefix+content.getMsgHint());
                }
                //兼容web 临时逻辑,后续删除
                if(lastMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_TEXT){
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
        }
    }
}
