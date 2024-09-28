package com.bytedance.im.ui.message.adapter;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;
import android.text.SpannableString;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;


import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.core.api.interfaces.BIMDownloadCallback;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessagePropertyItem;
import com.bytedance.im.core.internal.utils.IMLog;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiManager;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.ui.utils.BIMUINameUtils;
import com.bytedance.im.ui.utils.BIMUtils;
import com.bytedance.im.core.api.model.BIMMessage;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public final class BIMMessageViewHolder extends RecyclerView.ViewHolder {
    private static final String TAG = "MessageViewHolder";
    protected static final SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
    private static final int MSG_TIME_INTERVAL = 60 * 60 * 1000;

    private ImageView portraitLeft;
    private ImageView portraitRight;
    private TextView userNameLeft;
    private TextView userNameRight;
    private TextView mTime;
    private ImageView senStatus;
    private BIMMessageAdapter.OnMessageItemClickListener listener;
    private BIMMessageAdapter.OnMessageItemLongClickListener onMessageItemLongClickListener;
    private BIMMessageAdapter.OnRefreshListener onRefreshListener;
    private BIMMessageAdapter.OnDownloadListener onDownloadListener;
    private ViewGroup msgContainer;
    private TextView recall;
    private View headContainerRight;
    private View headContainerLeft;
    private BIMUserProvider userProvider;
    private RecyclerView recyclerView;
    private TextView tvPropertyLeft, tvPropertyRight;
    private TextView tvReadReceipt;

    public BIMMessageViewHolder(@NonNull View itemView,RecyclerView recyclerView, BIMUserProvider provider, BIMMessageAdapter.OnMessageItemClickListener l,
                                BIMMessageAdapter.OnMessageItemLongClickListener longClickListener,
                                BIMMessageAdapter.OnRefreshListener mediaMessageLoadListener,
                                BIMMessageAdapter.OnDownloadListener downloadListener) {
        super(itemView);
        this.recyclerView = recyclerView;
        this.userProvider = provider;
        listener = l;
        onMessageItemLongClickListener = longClickListener;
        onRefreshListener = mediaMessageLoadListener;
        onDownloadListener = downloadListener;
        portraitLeft = itemView.findViewById(R.id.iv_msg_head_receive);
        portraitRight = itemView.findViewById(R.id.iv_msg_head_send);
        mTime = itemView.findViewById(R.id.tv_common_msg_time);
        senStatus = itemView.findViewById(R.id.iv_send_status);
        msgContainer = itemView.findViewById(R.id.container);
        recall = itemView.findViewById(R.id.tv_recall);
        headContainerRight = itemView.findViewById(R.id.head_container_send);
        headContainerLeft = itemView.findViewById(R.id.head_container_receive);
        userNameLeft = itemView.findViewById(R.id.tv_msg_head_name_receive);
        userNameRight = itemView.findViewById(R.id.tv_msg_head_name_send);
        tvPropertyLeft = itemView.findViewById(R.id.tv_base_msg_property_left);
        tvPropertyRight = itemView.findViewById(R.id.tv_base_msg_property_right);
        tvReadReceipt = itemView.findViewById(R.id.tv_read_receipt);
    }
    //conversation 是异步设置的因此可能为 null
    public void update(BIMMessageWrapper wrapper, BIMMessageWrapper preWrapper, BIMConversation bimConversation) {
        BIMMessage bimMessage = wrapper.getBimMessage();
        long sendUID = bimMessage.getSenderUID();
        BIMUIUser user = userProvider.getUserInfo(sendUID);
        int portraitRes = R.drawable.icon_recommend_user_default;
        String portraitUrl = "";
        String userName = "";
        if (user != null) {
            portraitUrl = user.getPortraitUrl();
            userName = BIMUINameUtils.getShowNameInGroup(null, user);
        }
        //撤回
        if (bimMessage.isRecalled()) {
            recall.setVisibility(View.VISIBLE);
            msgContainer.setVisibility(View.GONE);
            recall.setText(BIMUtils.generateRecallHint(bimMessage,user));
            headContainerLeft.setVisibility(View.GONE);
            headContainerRight.setVisibility(View.GONE);
            senStatus.setVisibility(View.GONE);
            tvPropertyLeft.setVisibility(View.GONE);
            tvPropertyRight.setVisibility(View.GONE);
            tvReadReceipt.setVisibility(View.GONE);
            return;
        }
        recall.setVisibility(View.GONE);
        msgContainer.setVisibility(View.VISIBLE);
        BaseCustomElementUI ui = BIMMessageUIManager.getInstance().getMessageUI(wrapper.getContentClass());
        BIMLog.i(TAG, "update() contentCls: " + wrapper.getContentClass() + "ui: " + ui);
        boolean isSelf = bimMessage.isSelf();
        if (getAdapterPosition() == 0) {
            BIMLog.i(TAG, "last msg uuid:" + bimMessage.getUuid() + " status: " + bimMessage.getMsgStatus());
        }
        //已读/未读
        boolean isMemberOutLimit = bimConversation != null && bimConversation.isEnableReadReceipt();
        if (isMemberOutLimit && ui.isEnableReceipt(bimMessage) && (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS
                || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL)) {
            tvReadReceipt.setVisibility(View.VISIBLE);
            if (bimMessage.getSenderUID() != bimMessage.getTargetUID() && bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                if (isSelf && (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL)) {
                    if (bimMessage.isReadAck()) {
                        tvReadReceipt.setText("已读");
                    } else {
                        tvReadReceipt.setText("未读");
                    }
                } else {
                    tvReadReceipt.setVisibility(View.GONE);
                }
            } else if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                int readCount = bimMessage.getReadCount();
                int unReadCount = bimMessage.getUnReadCount();
                if (readCount == 0 && unReadCount == 0) {
                    tvReadReceipt.setText("未读");
                } else {
                    tvReadReceipt.setText("[" + readCount + "/" + unReadCount + "]");
                }
            } else {
                tvReadReceipt.setVisibility(View.GONE);
            }
        } else {
            tvReadReceipt.setVisibility(View.GONE);
        }
        ConstraintLayout.LayoutParams lp = (ConstraintLayout.LayoutParams) senStatus.getLayoutParams();
        if (ui.needHorizonCenterParent()) {
            lp.horizontalBias = 0.5f;
        } else if (isSelf) {
            lp.horizontalBias = 1;
        } else {
            lp.horizontalBias = 0;
        }
        senStatus.setLayoutParams(lp);
        tvPropertyLeft.setVisibility(View.GONE);
        tvPropertyRight.setVisibility(View.GONE);
        ImageView curPortraitView;
        TextView curUserNameView;
        TextView curPropertyView = null;
        if (ui.needPortraitGone()) {
            curPortraitView = null;
            curUserNameView = null;
            headContainerLeft.setVisibility(View.GONE);
            headContainerRight.setVisibility(View.GONE);
        } else if (isSelf) {
            headContainerLeft.setVisibility(View.GONE);
            headContainerRight.setVisibility(View.VISIBLE);
            curPortraitView = portraitRight;
            curUserNameView = userNameRight;
            curPropertyView = tvPropertyRight;
        } else {
            headContainerRight.setVisibility(View.GONE);
            headContainerLeft.setVisibility(View.VISIBLE);
            curPortraitView = portraitLeft;
            curUserNameView = userNameLeft;
            curPropertyView = tvPropertyLeft;
        }
        if (curPortraitView != null) {
            if (TextUtils.isEmpty(portraitUrl)) {
                curPortraitView.setImageResource(portraitRes);
            } else {
                Glide.with(curPortraitView.getContext()).load(portraitUrl)
                        .placeholder(R.drawable.icon_recommend_user_default)
                        .error(R.drawable.icon_recommend_user_default)
                        .into(curPortraitView);
            }
        }
        if (curUserNameView != null) {
            curUserNameView.setText(userName);
        }
        if (preWrapper != null) {
            if (Math.abs(wrapper.getBimMessage().getCreatedTime() - preWrapper.getBimMessage().getCreatedTime()) > MSG_TIME_INTERVAL) {
                mTime.setVisibility(View.VISIBLE);
                mTime.setText(format.format(wrapper.getBimMessage().getCreatedTime()));
            } else {
                mTime.setVisibility(View.GONE);
            }
        } else {
            mTime.setVisibility(View.GONE);
        }
        if (ui.isForceStatusGone()) {
            senStatus.setVisibility(View.GONE);
        } else if (isSelf) {
            if (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS) {
                senStatus.setVisibility(View.GONE);
            } else {
                switch (bimMessage.getMsgStatus()) {
                    case BIM_MESSAGE_STATUS_PENDING:
                    case BIM_MESSAGE_STATUS_SENDING:
                        senStatus.setVisibility(View.GONE);
                        break;
                    case BIM_MESSAGE_STATUS_FAILED:
                        senStatus.setVisibility(View.VISIBLE);
                        break;
                    default:
                        senStatus.setVisibility(View.GONE);
                        break;
                }
            }
        } else {
            senStatus.setVisibility(View.GONE);
        }
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int id = v.getId();
                if (id == R.id.iv_msg_head_receive || id == R.id.iv_msg_head_send) {
                    if (listener != null) {
                        listener.onPortraitClick(wrapper.getBimMessage());
                    }
                } else if (id == R.id.iv_send_status) {
                    if (listener != null) {
                        listener.onResentClick(wrapper.getBimMessage());
                    }
                } else if (id == R.id.container) {
                    ui.onClick(BIMMessageViewHolder.this,itemView, wrapper);
                } else if (id == R.id.tv_read_receipt) {
                    if (listener != null) {
                        listener.onReadReceiptClick(wrapper.getBimMessage());
                    }
                }
            }
        };
        itemView.setOnClickListener(onClickListener);
        msgContainer.setOnClickListener(onClickListener);
        senStatus.setOnClickListener(onClickListener);
        portraitLeft.setOnClickListener(onClickListener);
        portraitRight.setOnClickListener(onClickListener);
        tvReadReceipt.setOnClickListener(onClickListener);
        msgContainer.setOnLongClickListener(v -> {
            performLongClick(v, wrapper);
            return true;
        });
        if (user == null) {
            //异步刷新
            userProvider.getUserInfoAsync(sendUID, new BIMResultCallback<BIMUIUser>() {
                @Override
                public void onSuccess(BIMUIUser bimuiUser) {
                    recyclerView.getAdapter().notifyItemChanged(getAdapterPosition());
                }
                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
        bindProperty(bimMessage, curPropertyView);
    }
    /**
     * 展示点赞等property元素
     * @param bimMessage
     * @param propertyView
     */
    public void bindProperty(BIMMessage bimMessage, TextView propertyView) {
        Map<String, List<BIMMessagePropertyItem>> properties = bimMessage.getProperties();
        if (propertyView != null) {
            if (properties != null && !properties.isEmpty() && !bimMessage.isRecalled()) {
                String showText = showProperty(bimMessage);
                if (!TextUtils.isEmpty(showText)) {
                    SpannableString ss = EmojiManager.getInstance().parseEmoJi(propertyView.getContext(), showText);
                    propertyView.setVisibility(View.VISIBLE);
                    propertyView.setText(ss);
                    return;
                }
            }
            propertyView.setText("");
            propertyView.setVisibility(View.GONE);
        }
    }

    /**
     * 生成property展示字符
     * @param bimMessage
     * @return property展示字符
     */
    private String showProperty(BIMMessage bimMessage) {
        Map<String, List<BIMMessagePropertyItem>> map = bimMessage.getProperties();
        StringBuilder ret = new StringBuilder();
        for (Map.Entry<String, List<BIMMessagePropertyItem>> entry : map.entrySet()) {
            boolean needShow = false;
            StringBuilder sb = new StringBuilder();
            sb.append(entry.getKey()).append(" : ");
            List<BIMMessagePropertyItem> itemList = entry.getValue();
            if (itemList == null) {
                sb.append("");
                continue;
            }
            for (BIMMessagePropertyItem item : itemList) {
                if (item != null) {
                    BIMUIUser user = userProvider.getUserInfo(item.getSender());
                    if (user != null) {
                        sb.append(BIMUINameUtils.getShowName(user)).append(",");
                    } else {
                        sb.append("用户").append(item.getSender()).append(",");
                    }
                    needShow = true;
                }
            }
            if (needShow) {
                ret.append(sb);
            }
        }

        if (ret.lastIndexOf(",") > 0 && ret.length() > 0) {
            return ret.deleteCharAt(ret.lastIndexOf(",")).toString();
        } else {
            return ret.toString();
        }
    }

    public BIMMessageAdapter.OnRefreshListener getOnOutListener() {
        if (onRefreshListener == null) {
            return new BIMMessageAdapter.OnRefreshListener() {
                @Override
                public void refreshMediaMessage(BIMMessage bimMessage, BIMResultCallback<BIMMessage> callback) {
                    IMLog.i(TAG, "refreshMediaMessage default do nothing");
                }
            };
        }
        return onRefreshListener;
    }

    public BIMMessageAdapter.OnDownloadListener getDownloadListener(){
        if (onDownloadListener == null) {
            return new BIMMessageAdapter.OnDownloadListener() {
                @Override
                public void downLoadMessage(BIMMessage bimMessage, String url, boolean needNotify, BIMDownloadCallback callback) {
                    //默认啥也不做
                    IMLog.i(TAG, "downLoadMessage default do nothing");
                }
            };
        }
        return onDownloadListener;
    }

    public boolean performLongClick(View v,BIMMessageWrapper bimMessageWrapper){
        if (onMessageItemLongClickListener != null) {
            return onMessageItemLongClickListener.onLongMessageItemClick(v, msgContainer, bimMessageWrapper.getBimMessage());
        }
        return true;
    }
}
