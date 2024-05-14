package com.bytedance.im.app.contact.inviteList;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.contact.R;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VEContactInviteAdapter extends RecyclerView.Adapter<VEContactInviteViewHolder> {
    private InviteContactClickListener listener;
    private final List<BIMFriendApplyInfo> data = new ArrayList<>();
    private final Map<Long, BIMFriendApplyInfo> dataIds = new HashMap<>();

    @NonNull
    @Override
    public VEContactInviteViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_item_contact_invite, viewGroup, false);
        return new VEContactInviteViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VEContactInviteViewHolder veContactInviteViewHolder, int i) {
        veContactInviteViewHolder.onBind(data.get(i), this.listener);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<BIMFriendApplyInfo> appendData, boolean needClear) {
        if (needClear) {
            data.clear();
            dataIds.clear();
        }

        int size = data.size();
        data.addAll(appendData);

        for (BIMFriendApplyInfo info : appendData) {
            dataIds.put(info.getFromUid(), info);
        }

        if (needClear) {
            this.notifyDataSetChanged();
        } else {
            this.notifyItemRangeInserted(size, appendData.size());
        }
    }

    public int insertOrUpdateData(BIMFriendApplyInfo newData, boolean canAppend) {
        int index = Collections.binarySearch(this.data, newData, (o1, o2) ->  - Long.compare(o1.getIndex(), o2.getIndex()));

        BIMFriendApplyInfo replaceInfo = dataIds.get(newData.getFromUid());
        if (index < 0) {
            index = -index - 1;
        }
        if (null != replaceInfo) {
            // has same item, index changed
            int oldIndex = data.indexOf(replaceInfo);
            if (index < data.size() || canAppend) {
                this.data.add(index, newData);
                this.data.remove(oldIndex < index ? oldIndex : oldIndex + 1);
                this.dataIds.put(newData.getFromUid(), newData);
                this.notifyItemMoved(oldIndex, index);
                this.notifyItemChanged(index);
            }
        } else {
            // insert a new
            if (index < data.size() || canAppend) {
                this.data.add(index, newData);
                this.dataIds.put(newData.getFromUid(), newData);
                this.notifyItemInserted(index);
            }
        }

        return index;
    }

    public void setListener(InviteContactClickListener listener) {
        this.listener = listener;
    }
}
