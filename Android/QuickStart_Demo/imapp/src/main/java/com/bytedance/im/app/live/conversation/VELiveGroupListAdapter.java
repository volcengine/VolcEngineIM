package com.bytedance.im.app.live.conversation;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.conversation.adapter.VEConversationListAdapter;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.conversation.model.VEConversationWrapper;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

public class VELiveGroupListAdapter extends RecyclerView.Adapter<VELiveGroupViewHolder> {
    private static String TAG = "VELiveGroupConversationAdapter";

    private Context context;
    private HashSet<String> checkSet = new HashSet<>();
    private List<VEConvBaseWrapper<BIMConversation>> data = new ArrayList<>();
    private VEConversationListAdapter.OnItemClickListener onItemClickListener = null;
    private VEConversationListAdapter.OnItemLongClickListener onItemLongClickListener = null;

    public VELiveGroupListAdapter(Context context) {
        super();
        this.context = context;
    }

    @NonNull
    @Override
    public VELiveGroupViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        int layout = data.get(i).getType();
        View v = LayoutInflater.from(context).inflate(layout, viewGroup, false);
        return new VELiveGroupViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VELiveGroupViewHolder holder, int i) {
        holder.bind(data.get(i));
        holder.itemView.setOnClickListener((view) -> {
            if (onItemClickListener != null) {
                onItemClickListener.onItemClick(data.get(i), holder.getAdapterPosition());
            }
        });
        holder.itemView.setOnLongClickListener((view) -> {
            if (onItemLongClickListener != null) {
                return onItemLongClickListener.onItemLongClick(data.get(i), holder.getAdapterPosition());
            }
            return false;
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    private Boolean checkExist(String cid) {
        if (checkSet.contains(cid)) {
            return true;
        } else {
            checkSet.add(cid);
            return false;
        }
    }

    public void appendConversation(List<BIMConversation> list) {
        if (list == null || list.isEmpty()) {
            return;
        }
        int count = 0;
        int startPosition = data.size();
        for (BIMConversation conversation: list) {
            if (!checkExist(conversation.getConversationID())) {
                VEConversationWrapper c = wrap(conversation);
                if (c != null) {
                    data.add(c);
                }
                count++;
            }
        }
        notifyItemRangeInserted(startPosition, count);
    }

    public void clearConversation() {
        this.data.clear();
        this.checkSet.clear();
        notifyDataSetChanged();
    }

    private VEConversationWrapper wrap(BIMConversation conversation) {
        return new VEConversationWrapper(conversation, R.layout.ve_im_item_live_conversation);
    }

    public void setOnItemClickListener(VEConversationListAdapter.OnItemClickListener listener) {
        this.onItemClickListener = listener;
    }

    public void setOnItemLongClickListener(VEConversationListAdapter.OnItemLongClickListener listener) {
        this.onItemLongClickListener = listener;
    }
}
