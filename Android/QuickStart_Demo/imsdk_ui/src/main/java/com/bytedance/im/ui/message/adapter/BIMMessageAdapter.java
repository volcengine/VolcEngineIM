package com.bytedance.im.ui.message.adapter;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.bytedance.im.core.api.interfaces.BIMDownloadCallback;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;

import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.member.BIMGroupMemberProvider;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.user.BIMUserProvider;

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
    private OnRefreshListener onRefreshListener;
    private BIMUserProvider userProvider;
    private RecyclerView recyclerView;
    private BIMConversation bimConversation;
    private OnDownloadListener onDownloadListener;

    private BIMGroupMemberProvider bimMemberProvider;
    public interface OnRefreshListener {
        void refreshMediaMessage(BIMMessage bimMessage, BIMResultCallback<BIMMessage> callback);
    }

    public interface OnDownloadListener {
        void downLoadMessage(BIMMessage bimMessage, String url, boolean needNotify, BIMDownloadCallback callback);
    }

    public BIMMessageAdapter(RecyclerView recyclerView, BIMUserProvider provider,
                             BIMGroupMemberProvider bimMemberProvider,
                             OnMessageItemClickListener listener, OnMessageItemLongClickListener longClickListener,
                             OnRefreshListener onRefreshListener,
                             OnDownloadListener onDownloadListener) {
        this.recyclerView = recyclerView;
        this.userProvider = provider;
        onMessageItemClickListener = listener;
        this.bimMemberProvider = bimMemberProvider;
        onMessageItemLongClickListener = longClickListener;
        this.onRefreshListener = onRefreshListener;
        this.onDownloadListener = onDownloadListener;
    }

    @NonNull
    @Override
    public BIMMessageViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater layoutInflater = LayoutInflater.from(parent.getContext());
        View root = layoutInflater.inflate(R.layout.bim_im_item_base_message, parent, false);
        FrameLayout messageContainer = root.findViewById(R.id.container);
//        messageContainer.setBackground(new DynamicGradientDrawable((RecyclerView) parent, root, messageContainer));
        layoutInflater.inflate(viewType, messageContainer, true);
        return new BIMMessageViewHolder(root, recyclerView, userProvider, bimMemberProvider, onMessageItemClickListener, onMessageItemLongClickListener, onRefreshListener,onDownloadListener);
    }

    @Override
    public void onBindViewHolder(@NonNull BIMMessageViewHolder holder, int position) {
        BIMMessageWrapper wrapper = data.get(position);
        BIMMessageWrapper preWrapper = null;
        if (position + 1 < data.size()) {
            preWrapper = data.get(position + 1);
        }
        holder.update(wrapper, preWrapper, bimConversation);
        BIMMessageUIManager.getInstance().getMessageUI(wrapper.getContentClass()).onBindView(holder, holder.itemView, wrapper, preWrapper);
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

    public BIMMessage getMessage(int position){
        if (position < 0 || position > data.size()) {
            return null;
        }
        return data.get(position).getBimMessage();
    }

    /**
     * 批量添加消息
     *
     * @param messageList
     */
    public void addAllMessageList(List<BIMMessage> messageList) {
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

    public int findIndex(BIMMessage message) {
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
        return insertOrUpdateMessage(message, false);
    }

    public int insertOrUpdateMessage(BIMMessage message, boolean onlyUpdate) {
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
            if (onlyUpdate) {
                return INVALID;
            }

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
                    notifyItemInserted(insertIndex);
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
     * 直接追加到尾部，不排序(直播群用）
     */
    public int appendOrUpdate(BIMMessage bimMessage) {
        int containsIndex = findIndex(bimMessage);
        BIMMessageWrapper curMsgWrap = wrapper(bimMessage);
        if (containsIndex != -1) {
            data.set(containsIndex, curMsgWrap);
            notifyItemChanged(containsIndex);
            return UPDATE;
        } else {
            data.add(0, curMsgWrap);
            notifyItemInserted(0);
            return APPEND;
        }
    }

    /**
     * 直接追加到头部，不排序(直播群用）
     */
    public int inertHeadOrUpdate(BIMMessage bimMessage) {
        BIMMessageWrapper curMsgWrap = wrapper(bimMessage);
        int containsIndex = findIndex(bimMessage);
        if (containsIndex != -1) {
            data.set(containsIndex, curMsgWrap);
            notifyItemChanged(containsIndex);
            return UPDATE;
        } else {
            int pos = data.size();
            data.add(pos, curMsgWrap);
            notifyItemInserted(pos);
            return INSERT;
        }
    }


    private BIMMessageWrapper wrapper(BIMMessage bimMessage) {
        return new BIMMessageWrapper(bimMessage);
    }

    public List<BIMMessage> getVisibleList(int start, int end) {
        List<BIMMessage> ret = new ArrayList<>();

        start = Math.max(start, 0);
        end = Math.min(end, data.size() - 1);
        List<BIMMessageWrapper> subList = data.subList(start, end);

        for (BIMMessageWrapper wrapper: subList) {
            ret.add(wrapper.getBimMessage());
        }

        return ret;
    }

    public void updateConversation(BIMConversation conversation){
        bimConversation = conversation;
        notifyDataSetChanged();
    }

    public void clear() {
        data.clear();
        notifyDataSetChanged();
    }

    public interface OnMessageItemClickListener {
        void onPortraitClick(BIMMessage message);

        void onResentClick(BIMMessage message);

        void onReadReceiptClick(BIMMessage message);
    }

    public interface OnMessageItemLongClickListener {
        boolean onLongMessageItemClick(View v, View msgContainer, BIMMessage message);
    }
}
