package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.PopupWindow;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.CopyOperationInfo;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.DeleteOperationInfo;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.OperationInfo;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.RecallOperationInfo;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.RefOperationInfo;
import com.bytedance.im.core.api.model.BIMMessage;

import java.util.ArrayList;
import java.util.List;

public class BIMMessageOptionPopupWindow extends PopupWindow {

    private Context mContext;
    private RecyclerView operaRecyclerView;
    private OperationAdapter operationAdapter;
    private BIMMessageListFragment mMessageListFragment;
    private BIMMessage mBimMessage;

    public BIMMessageOptionPopupWindow(Context context, BIMMessageListFragment fragment) {
        super(context);
        mContext = context;
        mMessageListFragment = fragment;
        View contentView = LayoutInflater.from(context).inflate(R.layout.bim_layout_msg_optional_menu, null, false);
        setContentView(contentView);
        operaRecyclerView = contentView.findViewById(R.id.rv_operation);
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
        List<OperationInfo> data = new ArrayList<>();
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
                data.add(new RefOperationInfo(){
                    @Override
                    public void onClick(View v, BIMMessage bimMessage) {
                        mMessageListFragment.onRefMessage(bimMessage);
                    }
                });
            }
        }
        for (OperationInfo info : data) {
            info.setVeMessageListFragment(mMessageListFragment);
        }
        operationAdapter = new OperationAdapter(data, mBimMessage, new OperationAdapter.OnItemOperationClickListener() {
            @Override
            public void onOperationClick() {
                dismiss();
            }
        });
        operaRecyclerView.setLayoutManager(new GridLayoutManager(mContext, 5));
        operaRecyclerView.setAdapter(operationAdapter);
        showAsDropDown(anchor);
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        operationAdapter.onActivityResult(requestCode, resultCode, data);
    }
}
