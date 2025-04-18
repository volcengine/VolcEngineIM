package com.bytedance.im.ui.conversation.adapter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMStrangeBox;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.conversation.adapter.viewhodler.VEConversationDefaultViewHolder;
import com.bytedance.im.ui.conversation.adapter.viewhodler.VEConversationViewHolder;
import com.bytedance.im.ui.conversation.adapter.viewhodler.VEStrangeBoxViewHolder;
import com.bytedance.im.ui.conversation.model.VEConvBaseStickTopWrapper;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.conversation.model.VEConversationWrapper;
import com.bytedance.im.ui.conversation.model.VEStrangeBoxWrapper;
import com.bytedance.im.ui.log.BIMLog;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;


public class VEConversationListAdapter extends RecyclerView.Adapter<VEViewHolder> {
    private static final String TAG = "VEConversationListAdapter";
    private Context mContext;
    private List<VEConvBaseWrapper> data;
    private HashSet<String> checkSet;
    private OnItemClickListener onItemClickListener;
    private OnItemLongClickListener onItemLongClickListener;
    private ConversationInsertListener conversationInsertListener;
    private Handler mHandler = new Handler(Looper.getMainLooper());
    private RecyclerView recyclerView;

    public VEConversationListAdapter(Context context, RecyclerView recyclerView) {
        this.recyclerView = recyclerView;
        mContext = context;
        data = new ArrayList<>();
        checkSet = new HashSet<>();
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public void setOnItemLongClickListener(OnItemLongClickListener onItemLongClickListener) {
        this.onItemLongClickListener = onItemLongClickListener;
    }

    public void setConversationInsertListener(ConversationInsertListener conversationInsertListener) {
        this.conversationInsertListener = conversationInsertListener;
    }

    @NonNull
    @Override
    public VEViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int layout) {
        View v = LayoutInflater.from(mContext).inflate(layout, viewGroup, false);
        if (layout == R.layout.bim_im_item_conversation_stranger_box) {
            return new VEStrangeBoxViewHolder(v, recyclerView);
        } else if (layout == R.layout.bim_im_item_conversation) {
            return new VEConversationViewHolder(v, recyclerView);
        }
        return new VEConversationDefaultViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VEViewHolder veViewHolder, int position) {
        veViewHolder.bind(data.get(position));
        veViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onItemClickListener != null) {
                    int p = veViewHolder.getAdapterPosition();
                    mHandler.post(() -> veViewHolder.bind(veViewHolder.getWrapperInfo()));
                    if (p >= 0) {
                        onItemClickListener.onItemClick(data.get(p), p);
                    }
                }
            }
        });
        veViewHolder.itemView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if (onItemLongClickListener != null) {
                    int p = veViewHolder.getAdapterPosition();
                    return onItemLongClickListener.onItemLongClick(data.get(p), veViewHolder.getAdapterPosition());
                }
                return false;
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    @Override
    public int getItemViewType(int position) {
        return data.get(position).getType();
    }

    /**
     * 去重
     *
     * @param cid
     * @return
     */
    protected boolean checkExist(String cid) {
        if (checkSet.contains(cid)) {
            return true;
        } else {
            checkSet.add(cid);
            return false;
        }
    }

    public void appendConversation(List<BIMConversation> list) {
        if (list == null || list.isEmpty()) return;
        int count = 0;
        int size = data.size();
        for (BIMConversation conversation : list) {
            if (!checkExist(conversation.getConversationID())) {
                data.add(wrap(conversation));
                count++;
            }
        }
        notifyItemRangeInserted(size, count);
    }

    /**
     * 增加新的会话
     *
     * @param list
     */
    public void addNewConversation(List<BIMConversation> list) {
        BIMLog.i(TAG, "addNewConversation()");
        for (BIMConversation conversation : list) {
            if (!checkExist(conversation.getConversationID())) {
                VEConversationWrapper wrapper = wrap(conversation);
                insertConversation(wrapper);
            }
        }
    }

    //插入会话
    private void insertConversation(VEConvBaseWrapper wrapper) {
        int insertIndex = findInsertIndex(wrapper);
        insertIndex(insertIndex, wrapper);
    }

    /**
     * 更新会话
     *
     * @param list
     */
    public void updateConversation(List<BIMConversation> list) {
        BIMLog.i(TAG, "updateConversation()");
        for (BIMConversation conversation : list) {
            VEConversationWrapper wrapper = wrap(conversation);
            updateConversation(wrapper);
        }
    }

    /**
     * 固定置顶一个conversation
     * @param topConversation
     */
    public void insertOrUpdateTopConversation(BIMConversation topConversation) {
        long orderStart = Long.MAX_VALUE;

        VEConvBaseStickTopWrapper veConvBaseStickTopWrapper = new VEConvBaseStickTopWrapper(topConversation, R.layout.bim_im_item_conversation);
        veConvBaseStickTopWrapper.setSortOrder(orderStart);
        updateConversation(veConvBaseStickTopWrapper);
    }

    private void updateConversation(VEConvBaseWrapper wrapper){
        removeIndex(finIndex(wrapper));
        checkExist(wrapper.getConversationId());
        insertIndex(findInsertIndex(wrapper), wrapper);
    }


    /**
     * 移出会话。
     *
     * @param list
     */
    public void removeConversation(List<BIMConversation> list) {
        BIMLog.i(TAG, "removeConversation()");
        for (BIMConversation conversation : list) {
            VEConversationWrapper wrapper = wrap(conversation);
            removeIndex(finIndex(wrapper));
        }
    }

    public List<VEConvBaseWrapper> getData() {
        return data;
    }

    /**
     * 更新陌生人盒子
     * @param strangerBox
     */
    public void insertOrUpdateStrangeBox(BIMStrangeBox strangerBox){
        if (strangerBox == null) {
            int index = findStrangeBox();
            if (index >= 0) {
                data.remove(index);
                notifyItemRemoved(index);
                notifyItemRangeChanged(index, data.size() - index);
            }
        } else {
            VEStrangeBoxWrapper wrapper = new VEStrangeBoxWrapper(strangerBox, R.layout.bim_im_item_conversation_stranger_box);
            int index = findStrangeBox();
            if (index == -1) {
                insertConversation(wrapper);//添加
            } else {
                data.set(index, wrapper);
                notifyItemChanged(index);
            }
        }
    }

    private int findStrangeBox(){
        int index = -1;
        for (int i = 0; i < data.size(); i++) {
            VEConvBaseWrapper wrapper = data.get(i);
            if (wrapper instanceof VEStrangeBoxWrapper) {
                index = i;
                break;
            }
        }
        return index;
    }

    /**
     * 移出
     *
     * @param index
     */
    private void removeIndex(int index) {
        BIMLog.i(TAG, "removeIndex() index:" + index);
        if (index < 0) {
            BIMLog.i(TAG, "removeIndex failed! index: " + index);
            return;
        }
        data.remove(index);
        notifyItemRemoved(index);
        notifyItemRangeChanged(index, data.size() - index);
    }

    /**
     * 插入会话
     *
     * @param index
     * @param wrapper
     */
    private void insertIndex(int index, VEConvBaseWrapper wrapper) {
        BIMLog.i(TAG, "insertIndex() index:" + index);
        if (data.isEmpty()) {
            data.add(wrapper);
            notifyDataSetChanged();
        } else if (index == data.size()) {
            data.add(wrapper);
            notifyItemInserted(data.size());
        } else {
            if (index < data.size()) {
                data.add(index, wrapper);
                notifyItemInserted(index);
            } else {
                BIMLog.i(TAG, "insertIndex() index is bigger than size: " + data.size() + "index" + index);
            }
        }

        if (conversationInsertListener != null) {
            if (wrapper.getInfo() instanceof BIMConversation) {
                BIMConversation bimConversation = (BIMConversation) wrapper.getInfo();
                conversationInsertListener.afterConversationInsert(bimConversation, index);
            }
        }
    }

    /**
     * 插入位置
     *
     * @param wrapper
     * @return
     */
    private int findInsertIndex(VEConvBaseWrapper wrapper) {
        if (data == null || data.size() == 0) {
            return -1;
        }
        long target = wrapper.getSortOrder();
        int l = 0;
        int r = data.size();
        while (l < r) {
            int mid = (r - l) / 2 + l;
            long cur = data.get(mid).getSortOrder();
            if (cur < target) {
                r = mid;
            } else if (cur > target) {
                l = mid + 1;
            } else {
                long targetShortId = wrapper.getConversationShortId();
                long curShortId = data.get(mid).getConversationShortId();
                if (curShortId < targetShortId) {
                    r = mid;
                } else if (curShortId > targetShortId) {
                    l = mid + 1;
                } else {
                    return mid;
                }
            }
        }
        return l;
    }

    private int finIndex(VEConvBaseWrapper wrapper) {
        for (int i = 0; i < data.size(); i++) {
            if (data.get(i).getConversationId().equals(wrapper.getConversationId())) {
                return i;
            }
        }
        return -1;
    }

    public BIMConversation getConversation(String conversationId){
        if(data != null){
            for(VEConvBaseWrapper wrapper:data){
                if (wrapper.getType() == R.layout.bim_im_item_conversation) {
                    BIMConversation bimConversation = (BIMConversation) wrapper.getInfo();
                    if (bimConversation.getConversationID().equals(conversationId)) {
                        return bimConversation;
                    }
                }
            }
        }
        return null;
    }
    /**
     * 包装 Conversation 便于 UI 处理
     *
     * @param conversation
     * @return
     */
    private VEConversationWrapper wrap(BIMConversation conversation) {
        return new VEConversationWrapper(conversation, R.layout.bim_im_item_conversation);
    }


    public interface OnItemClickListener {
        void onItemClick(VEConvBaseWrapper wrapper, int position);
    }

    public interface OnItemLongClickListener {
        boolean onItemLongClick(VEConvBaseWrapper wrapper, int position);
    }

    public interface ConversationInsertListener {
        void afterConversationInsert(BIMConversation conversation, int position);
    }

    public void clear(){
        data.clear();
        checkSet.clear();
        notifyDataSetChanged();
    }
}
