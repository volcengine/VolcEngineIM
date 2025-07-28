package com.bytedance.im.ui.conversation.adapter.viewhodler;

import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPushStatus;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.conversation.adapter.VEViewHolder;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.member.BIMGroupMemberProvider;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.core.service.manager.BIMMessageManager;
import com.bytedance.im.ui.utils.BIMUINameUtils;
import com.bytedance.im.ui.utils.BIMUtils;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMBaseElement;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Locale;
import java.util.Map;

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
    private RecyclerView recyclerView;

    public VEConversationViewHolder(@NonNull View itemView,RecyclerView recyclerView) {
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
    public void bind(VEConvBaseWrapper<BIMConversation> conversationVEConversationWrapper) {
        super.bind(conversationVEConversationWrapper);
        BIMConversation bimConversation = conversationVEConversationWrapper.getInfo();
        String name = "";
        if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
            long oppositeUID = bimConversation.getOppositeUserID();
            BIMUIUser user = getBIMUIUSerOrAsyncRefresh(oppositeUID);
            if (user == null) {
                checkDefault(bimConversation);
                return;
            }
            name = BIMUINameUtils.getShowName(user);
            if (!TextUtils.isEmpty(user.getPortraitUrl())) {
                Glide.with(userHeadImg.getContext()).load(user.getPortraitUrl())
                        .placeholder(R.drawable.icon_recommend_user_default)
                        .error(R.drawable.icon_recommend_user_default)
                        .into(userHeadImg);
            } else {
                userHeadImg.setImageResource(R.drawable.icon_recommend_user_default);
            }
        } else {
            if (!TextUtils.isEmpty(bimConversation.getName())) {
                name = bimConversation.getName();
            } else {
                name = "未命名群聊";
            }
            if (TextUtils.isEmpty(bimConversation.getPortraitURL())) {
                userHeadImg.setImageResource(R.drawable.default_icon_group);
            } else {
                Glide.with(userHeadImg.getContext()).load(bimConversation.getPortraitURL())
                        .placeholder(R.drawable.default_icon_group)
                        .error(R.drawable.default_icon_group)
                        .into(userHeadImg);
            }
        }
        nickName.setText(name);
        int textColor = R.color.business_im_222;
        if (bimConversation.isDissolved()) {
            textColor = R.color.business_im_999;
        }
        nickName.setTextColor(itemView.getContext().getResources().getColor(textColor));
        //会话未读数
        long realCount = 0;
        if (bimConversation.isMute()) { //免打扰
            unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_mute_unread_num_bg));
            realCount = bimConversation.getUnReadCount();

        } else if (bimConversation.getPushStatus() == BIMPushStatus.BIM_PUSH_STATUS_PART_ALLOW) { //部分免打扰【tob无此功能】
            if (bimConversation.getUnreadCountWL() == 0) {
                realCount = bimConversation.getUnReadCount() - bimConversation.getUnreadCountWL();
                unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_mute_unread_num_bg));
            } else {
                realCount = bimConversation.getUnreadCountWL();
                unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_unread_num_bg));
            }
        } else {
            unReadIcon.setBackground(itemView.getResources().getDrawable(R.drawable.shape_im_conversation_unread_num_bg));
            realCount = bimConversation.getUnReadCount();
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

        setHint(bimConversation);
    }

    private void checkDefault(BIMConversation bimConversation) {
        if (bimConversation != null && bimConversation.getConversationShortID() <= 0) {
            userHeadImg.setImageResource(R.drawable.icon_recommend_user_default);
            nickName.setText("用户" + bimConversation.getOppositeUserID());
            setHint(bimConversation);
        }
    }

    private void setHint(BIMConversation bimConversation) {
        //会话最新时间
        lastTime.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimConversation.getUpdatedTime()));
        //会话类型 - 轻直播
        conversationType.setVisibility(View.GONE);
        lastMsg.setVisibility(View.VISIBLE);
        //会话消息 - 草稿
        if (!TextUtils.isEmpty(bimConversation.getDraftText())) {
            SpannableString str = new SpannableString("[草稿]" + bimConversation.getDraftText());
            str.setSpan(new ForegroundColorSpan(Color.RED), 0, 3, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
            lastMsg.setText(str);
        } else {
            //会话最后一条消息
            BIMMessage lastMessage = bimConversation.getLastMessage();
            if (lastMessage != null) {
                BIMUIUser user = getBIMUIUSerOrAsyncRefresh(lastMessage.getSenderUID());
                if (user == null) {
                    return;
                }

                BIMMember member = getBIMMemberAsyncRefresh(lastMessage.getSenderUID(), lastMessage.getConversationID());
                if (lastMessage.isRecalled()) {
                    lastMsg.setText(BIMUtils.generateRecallHint(lastMessage, user, member));
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
                    String prefix = BIMUINameUtils.getShowNameInGroup(member, user) + ": ";
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

    private BIMMember getBIMMemberAsyncRefresh(long uid, String conversationId) {
        BIMGroupMemberProvider groupMemberProvider = BIMUIClient.getInstance().getBimGroupMemberProvider();
        BIMMember member = groupMemberProvider.getMember(conversationId, uid);

        if (member == null) {
            groupMemberProvider.getMemberAsync(conversationId, uid, new BIMResultCallback<BIMMember>() {
                @Override
                public void onSuccess(BIMMember member) {
                    recyclerView.getAdapter().notifyItemChanged(getAdapterPosition());
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
        return member;
    }
}
