package com.bytedance.im.ui.message.adapter;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.convert.manager.BIMMessageManager;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMBaseElement;

import java.util.ArrayList;
import java.util.List;

public class BIMMessageAdapter extends RecyclerView.Adapter<BIMMessageViewHolder> {
    private static final String TAG = "VEMessageAdapter";
    //-1:非法 0:更新 1:插入 2: 追加
    public static final int INVALID = -1;
    public static final int UPDATE = 0;
    public static final int INSERT = 1;
    public static final int APPEND = 2;
    /**
     * 消息列表,由新到旧, orderIndex 由大到小
     */
    private List<BIMMessageWrapper> data = new ArrayList<>();
    private OnMessageItemClickListener onMessageItemClickListener;
    private OnMessageItemLongClickListener onMessageItemLongClickListener;

    public BIMMessageAdapter(OnMessageItemClickListener listener, OnMessageItemLongClickListener longClickListener) {
        onMessageItemClickListener = listener;
        onMessageItemLongClickListener = longClickListener;
    }

    @NonNull
    @Override
    public BIMMessageViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
        View root = layoutInflater.inflate(R.layout.bim_im_item_base_message, parent, false);
        FrameLayout messageContainer = root.findViewById(R.id.container);
        layoutInflater.inflate(viewType, messageContainer, true);
        return new BIMMessageViewHolder(root, onMessageItemClickListener, onMessageItemLongClickListener);
    }

    @Override
    public void onBindViewHolder(@NonNull BIMMessageViewHolder holder, int position) {
        BIMMessageWrapper wrapper = data.get(position);
        BIMMessageWrapper preWrapper = null;
        if (position + 1 < data.size()) {
            preWrapper = data.get(position + 1);
        }
        holder.update(wrapper, preWrapper);
        BIMMessageUIManager.getInstance().getMessageUI(wrapper.getContentClass()).onBindView(holder.itemView, wrapper, preWrapper);
    }

    @Override
    public int getItemViewType(int position) {
        BIMMessageWrapper wrapper = data.get(position);
        return BIMMessageUIManager.getInstance().getMessageUI(wrapper.getContentClass()).getLayoutId();
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    /**
     * 添加到尾部
     *
     * @param messageList
     */
    public void appendMessageList(List<BIMMessage> messageList) {
        if (messageList == null || messageList.isEmpty()) {
            return;
        }
        for (BIMMessage message : messageList) {
            insertOrUpdateMessage(message);
        }
    }

    public void deleteMessage(BIMMessage message) {
        int index = findIndex(message);
        if (index >= 0) {
            data.remove(index);
            notifyItemRemoved(index);
            notifyItemRangeChanged(index, data.size() - index);
        }
    }

    private int findIndex(BIMMessage message) {
        if (message != null && data != null && !data.isEmpty()) {
            for (int i = 0; i < data.size(); i++) {
                BIMMessageWrapper wrapper = data.get(i);
                if (wrapper.getBimMessage().getUuid().equals(message.getUuid())) {
                    return i;
                }
            }
        }
        return -1;
    }

    /**
     * 根据 orderIndex 插入或者更新消息
     *
     * @param message
     * @return -1:非法 0:更新 1:插入 2: 追加
     */
    public int insertOrUpdateMessage(BIMMessage message) {
        if (message == null) {
            BIMLog.i(TAG, "message is null!");
            return INVALID;
        }
        BIMLog.i(TAG, "insertOrUpdateMessage() uuid: " + message.getUuid() + " orderIndex: " + message.getOrderIndex());
        BIMMessageWrapper curMsgWrap = wrapper(message);
        int containsIndex = findIndex(message);
        if (containsIndex != -1) {
            //更新
            BIMLog.i(TAG, "update Message uuid:" + message.getUuid() + " adapterIndex: " + containsIndex);
            data.set(containsIndex, curMsgWrap);
            notifyItemChanged(containsIndex);
            return UPDATE;
        } else {
            //插入
            if (data.isEmpty()) {
                data.add(curMsgWrap);
                BIMLog.i(TAG, "insert Message insertIndex: " + data.size());
                notifyDataSetChanged();
                return APPEND;
            } else {
                int insertIndex = findInsertIndex(message);
                if (insertIndex == data.size()) {
                    data.add(curMsgWrap);
                    notifyItemInserted(data.size());
                    BIMLog.i(TAG, "insertMessage uuid: " + message.getUuid() + " insertIndex: " + insertIndex + " append!");
                    return INSERT;
                } else {
                    BIMLog.i(TAG, "insertMessage uuid: " + message.getUuid() + " insertIndex: " + insertIndex + " insert! ");
                    data.add(insertIndex, curMsgWrap);
                    notifyItemInserted(insertIndex);
                    if (insertIndex == 0) {
                        return APPEND;
                    } else {
                        return INSERT;
                    }
                }
            }
        }
    }

    /**
     * @param bimMessage
     * @return
     */
    private int findInsertIndex(BIMMessage bimMessage) {
        if (data == null || data.size() == 0) {
            return -1;
        }
        long target = bimMessage.getOrderIndex();
        int l = 0;
        int r = data.size();
        while (l < r) {
            int mid = (r - l) / 2 + l;
            long cur = data.get(mid).getBimMessage().getOrderIndex();
            if (cur < target) {
                r = mid;
            } else if (cur > target) {
                l = mid + 1;
            } else {
                return mid;
            }
        }
        return l;
    }

    /**
     * 直接追加到尾部，不排序
     */
    public int appendOrUpdate(BIMMessage bimMessage){
        int containsIndex = findIndex(bimMessage);
        BIMMessageWrapper curMsgWrap = wrapper(bimMessage);
        if(containsIndex!=-1){
            data.set(containsIndex, curMsgWrap);
            notifyItemChanged(containsIndex);
            return UPDATE;
        }else {
            if(data.isEmpty()){
                data.add(curMsgWrap);
                notifyDataSetChanged();
            }else {
                data.add(0,curMsgWrap);
                notifyItemInserted(0);
            }
            return APPEND;
        }
    }

    private BIMMessageWrapper wrapper(BIMMessage bimMessage) {
        if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
            //解析自定义消息
            BIMCustomElement customElement = (BIMCustomElement) bimMessage.getElement();
            BIMBaseElement baseContent = BIMMessageManager.getInstance().decode(customElement.getData());
            if (baseContent == null) {
                baseContent = new BIMBaseElement(); //兜底
            }
            bimMessage.setContent(baseContent);
        }
        return new BIMMessageWrapper(bimMessage);
    }

    public interface OnMessageItemClickListener {
        void onPortraitClick(BIMMessage message);

        void onResentClick(BIMMessage message);
    }

    public interface OnMessageItemLongClickListener {
        boolean onLongMessageItemClick(View v, View msgContainer, BIMMessage message);
    }
}
