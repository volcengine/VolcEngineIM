package com.bytedance.im.app.live.chatRoom.operation;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.PopupWindow;

import com.bytedance.im.app.R;
import com.bytedance.im.app.live.chatRoom.VELiveGroupMessageListFragment;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;

import java.util.ArrayList;
import java.util.List;

public class VELiveMessageOptionPopWindow extends PopupWindow {
    private Context mContext;
    private RecyclerView operaRecyclerView;
    private VELiveOperationAdapter operationAdapter;
    private VELiveGroupMessageListFragment mLiveMessageListFragment;
    private BIMMessage mBimMessage;

    public VELiveMessageOptionPopWindow(Context context, VELiveGroupMessageListFragment fragment) {
        super(context);
        mContext = context;
        mLiveMessageListFragment = fragment;
        View contentView = LayoutInflater.from(context).inflate(R.layout.ve_im_live_layout_msg_optional_menu, null, false);
        setContentView(contentView);
        operaRecyclerView = contentView.findViewById(com.bytedance.im.ui.R.id.rv_operation);
        setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        setOutsideTouchable(true);
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
            data.add(VELivePriorityInfo.create(bimMessage));

            if (ui.isEnableCopy(mBimMessage)) {
                data.add(new VELiveCopyOperationInfo());
            }
//            if (ui.isEnableDelete(mBimMessage)) {
//                data.add(new VELiveDeleteOperationInfo());
//            }
            //撤回和引用暂时屏蔽掉，后续支持
//            if (ui.isEnableRecall(mBimMessage)) {
//                data.add(new LiveRecallOperation());
//            }
//            if (ui.isEnableRef(mBimMessage)) {
//                data.add(new RefOperationInfo() {
//                    @Override
//                    public void onClick(View v, BIMMessage bimMessage) {
//                        super.onClick(v, bimMessage);
//                        //todo ref
//                        mLiveMessageListFragment.onRefMessage(bimMessage);
//                    }
//                });
//            }
        }
        for (BIMMessageOperation info : data) {
            info.setVeMessageListFragment(mLiveMessageListFragment);
        }
        operationAdapter = new VELiveOperationAdapter(data, mBimMessage, () -> dismiss());
        operaRecyclerView.setLayoutManager(new GridLayoutManager(mContext, 5));
        operaRecyclerView.setAdapter(operationAdapter);
        showAsDropDown(anchor);
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        operationAdapter.onActivityResult(requestCode, resultCode, data);
    }
}
