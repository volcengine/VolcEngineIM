package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.PopupWindow;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiInfo;
import com.bytedance.im.ui.emoji.EmojiManager;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.ui.message.adapter.ui.widget.EmojiGroupView;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.EditOperationInfo;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.CopyOperationInfo;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.DeleteOperationInfo;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.RecallOperationInfo;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.RefOperationInfo;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.utils.BIMUIUtils;

import java.util.ArrayList;
import java.util.List;

public class BIMMessageOptionPopupWindow extends PopupWindow {

    private Context mContext;
    private RecyclerView operaRecyclerView;
    private OperationAdapter operationAdapter;
    private BIMMessageListFragment mMessageListFragment;
    private BIMMessage mBimMessage;
    private EmojiAdapter emojiAdapter;
    private RecyclerView rvOptionEmoji;
    private EmojiGroupView emojiGroupView;
    private static List<BIMMessageOperation> customOperationList = new ArrayList<>();

    public BIMMessageOptionPopupWindow(Context context, BIMMessageListFragment fragment) {
        super(context);
        mContext = context;
        mMessageListFragment = fragment;
        View contentView = LayoutInflater.from(context).inflate(R.layout.bim_layout_msg_optional_menu, null, false);
        setContentView(contentView);
        operaRecyclerView = contentView.findViewById(R.id.rv_operation);
        emojiGroupView = contentView.findViewById(R.id.view_emoji_group);
        rvOptionEmoji = contentView.findViewById(R.id.flex_box_emoji);
        setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        setOutsideTouchable(true);
        emojiAdapter = new EmojiAdapter();
        rvOptionEmoji.setAdapter(emojiAdapter);
        rvOptionEmoji.setVisibility(View.VISIBLE);
        rvOptionEmoji.setLayoutManager(new LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false) {
            @Override
            public boolean canScrollHorizontally() {
                return false;
            }
        });
        emojiGroupView.setEmojiClickListener(info -> {
            if (info == null || info.code == EmojiGroupView.EMPTY_CODE) {
                return;
            }
            if (info.code == EmojiGroupView.DELETE_CODE) {
                switchPanel(false);
                return;
            }
            if (mMessageListFragment != null) {
                mMessageListFragment.onClickEmoji(info, mBimMessage);
            }
            dismiss();
        });
        addEmojiView();
    }

    /**
     * 设置 Message
     *
     * @param bimMessage
     */
    public void setBimMessageAndShow(View anchor, BIMMessage bimMessage) {
        mBimMessage = bimMessage;
        List<BIMMessageOperation> data = new ArrayList<>();
        BaseCustomElementUI ui = BIMMessageUIManager.getInstance().getMessageUI(mBimMessage.getElement().getClass());
        if (ui != null) {
            if (ui.isEnableCopy(mBimMessage)) {
                data.add(new CopyOperationInfo());
            }
            if (ui.isEnableDelete(mBimMessage)) {
                data.add(new DeleteOperationInfo());
            }
            if (ui.isEnableRecall(mBimMessage)) {
                data.add(new RecallOperationInfo());
            }
            if (ui.isEnableRef(mBimMessage)) {
                data.add(new RefOperationInfo() {
                    @Override
                    public void onClick(View v, BIMMessage bimMessage) {
                        mMessageListFragment.onRefMessage(bimMessage);
                    }
                });
            }
            if (ui.isEnableEdit(mBimMessage)) {
                data.add(new EditOperationInfo() {
                    @Override
                    public void onClick(View v, BIMMessage bimMessage) {
                        mMessageListFragment.onEditMessage(bimMessage);
                    }
                });
            }
            //自定义的部分
            data.addAll(customOperationList);
        }
        for (BIMMessageOperation info : data) {
            info.setVeMessageListFragment(mMessageListFragment);
        }
        operationAdapter = new OperationAdapter(data, mBimMessage, new OperationAdapter.OnItemOperationClickListener() {
            @Override
            public void onOperationClick() {
                dismiss();
            }
        });
        operaRecyclerView.setLayoutManager(new GridLayoutManager(mContext, data.size()));
        operaRecyclerView.setAdapter(operationAdapter);

        if (bimMessage.getServerMsgId() > 0) {
            switchPanel(false);
            emojiGroupView.reset();
            int offsetY = getOffsetY(anchor);
            showAsDropDown(anchor, 0, offsetY);
        }
    }

    public int getOffsetY(View anchor) {
        try {
            getContentView().measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);

            Rect r = new Rect();
            int[] location = new int[2];
            anchor.getLocationInWindow(location);
            anchor.getWindowVisibleDisplayFrame(r);
            int anchorHeight = anchor.getMeasuredHeight();
            int height = getContentView().getMeasuredHeight();

            if ((r.bottom - anchorHeight - location[1]) > BIMUIUtils.dpToPx(anchor.getContext(), 200)) {
                return 0;
            } else {
                return -(height + anchorHeight);
            }
        } catch (Exception e) {
            // ignore
        }
        return 0;
    }

    private void addEmojiView() {
        List<EmojiInfo> emojiInfoList = new ArrayList<>();
        emojiInfoList.addAll(EmojiManager.getInstance().getEmojis(mContext).subList(0, 5));
        EmojiInfo openEmoji = new EmojiInfo();
        openEmoji.code = EmojiInfo.CODE_OPEN;
        openEmoji.resId = R.drawable.icon_msg_option_menu_open_emoji;
        emojiInfoList.add(openEmoji);
        emojiAdapter.updateData(emojiInfoList);
        emojiAdapter.setOnClickListener((v, emojiInfo) -> {
            if (emojiInfo.code == EmojiInfo.CODE_OPEN) {
                switchPanel(true);
                return;
            }
            if (mMessageListFragment != null) {
                mMessageListFragment.onClickEmoji(emojiInfo, mBimMessage);
            }
            dismiss();
        });
    }

    private void switchPanel(boolean switchToEmojiPanel) {
        if (switchToEmojiPanel) {
            emojiGroupView.setVisibility(View.VISIBLE);
            operaRecyclerView.setVisibility(View.GONE);
            rvOptionEmoji.setVisibility(View.GONE);
        } else {
            operaRecyclerView.setVisibility(View.VISIBLE);
            rvOptionEmoji.setVisibility(View.VISIBLE);
            emojiGroupView.setVisibility(View.GONE);
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        operationAdapter.onActivityResult(requestCode, resultCode, data);
    }

    public static void registerOperation(BIMMessageOperation operation) {
        customOperationList.add(operation);
    }
}
