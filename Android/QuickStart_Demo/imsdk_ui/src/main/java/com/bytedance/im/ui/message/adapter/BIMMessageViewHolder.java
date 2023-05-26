package com.bytedance.im.ui.message.adapter;

import android.support.annotation.NonNull;
import android.support.constraint.ConstraintLayout;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.ui.utils.BIMUtils;
import com.bytedance.im.core.api.model.BIMMessage;

import java.text.SimpleDateFormat;
import java.util.Locale;

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
    private View msgContainer;
    private TextView recall;
    private View headContainerRight;
    private View headContainerLeft;

    public BIMMessageViewHolder(@NonNull View itemView, BIMMessageAdapter.OnMessageItemClickListener l, BIMMessageAdapter.OnMessageItemLongClickListener longClickListener) {
        super(itemView);
        listener = l;
        onMessageItemLongClickListener = longClickListener;
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
    }

    public void update(BIMMessageWrapper wrapper, BIMMessageWrapper preWrapper) {
        BIMMessage bimMessage = wrapper.getBimMessage();
        BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(bimMessage.getSenderUID());
        int portraitRes = R.drawable.icon_recommend_user_default;
        String portraitUrl = "";
        String userName = "" + wrapper.getBimMessage().getSenderUID();
        if (user != null) {
            portraitRes = user.getHeadImg();
            userName = user.getNickName();
            portraitUrl = user.getUrl();
        }

        //撤回
        if (bimMessage.isRecalled()) {
            recall.setVisibility(View.VISIBLE);
            msgContainer.setVisibility(View.GONE);
            recall.setText(BIMUtils.generateRecallHint(bimMessage));
            headContainerLeft.setVisibility(View.GONE);
            headContainerRight.setVisibility(View.GONE);
            senStatus.setVisibility(View.GONE);
            return;
        }
        recall.setVisibility(View.GONE);
        msgContainer.setVisibility(View.VISIBLE);
        BaseCustomElementUI ui = BIMMessageUIManager.getInstance().getMessageUI(wrapper.getContentClass());
        BIMLog.i(TAG, "update() contentCls: " + wrapper.getContentClass() + "ui: " + ui);
        boolean isSelf = bimMessage.isSelf();
        ConstraintLayout.LayoutParams lp = (ConstraintLayout.LayoutParams) senStatus.getLayoutParams();

        if (ui.needHorizonCenterParent()) {
            lp.horizontalBias = 0.5f;
        } else if (isSelf) {
            lp.horizontalBias = 1;
        } else {
            lp.horizontalBias = 0;
        }
        senStatus.setLayoutParams(lp);
        ImageView curPortraitView;
        TextView curUserNameView;
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
        } else {
            headContainerRight.setVisibility(View.GONE);
            headContainerLeft.setVisibility(View.VISIBLE);
            curPortraitView = portraitLeft;
            curUserNameView = userNameLeft;
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
        if (ui.needHorizonCenterParent())
            ui.onBindView(itemView, wrapper, preWrapper);
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
        if (isSelf) {
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
                    ui.onClick(itemView, wrapper);
                }
            }
        };
        itemView.setOnClickListener(onClickListener);
        msgContainer.setOnClickListener(onClickListener);
        senStatus.setOnClickListener(onClickListener);
        portraitLeft.setOnClickListener(onClickListener);
        portraitRight.setOnClickListener(onClickListener);
        msgContainer.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if (ui.onLongClickListener(v, wrapper)) {
                    return true;
                } else if (onMessageItemLongClickListener != null) {
                    return onMessageItemLongClickListener.onLongMessageItemClick(v, msgContainer, wrapper.getBimMessage());
                }
                return true;
            }
        });
    }
}
