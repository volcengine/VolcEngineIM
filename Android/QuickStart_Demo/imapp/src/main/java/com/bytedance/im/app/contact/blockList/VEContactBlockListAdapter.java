package com.bytedance.im.app.contact.blockList;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VEContactBlockListAdapter extends RecyclerView.Adapter<VEContactBlockListViewHolder> {
    private BlockListClickListener listener;
    private final List<BIMFriendApplyInfo> data = new ArrayList<>();

    @NonNull
    @Override
    public VEContactBlockListViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_item_contact, viewGroup, false);
        return new VEContactBlockListViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VEContactBlockListViewHolder veContactInviteViewHolder, int i) {
        veContactInviteViewHolder.onBind(data.get(i), this.listener);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<BIMFriendApplyInfo> appendData, boolean needClear) {
        if (needClear) {
            data.clear();
        }

        int size = data.size();
        data.addAll(appendData);
        if (needClear) {
            this.notifyDataSetChanged();
        } else {
            this.notifyItemRangeInserted(size, appendData.size());
        }
    }

    public int insertOrUpdateData(BIMFriendApplyInfo newData, boolean canAppend) {
        int index = Collections.binarySearch(this.data, newData, (o1, o2) -> o1.getIndex() - o2.getIndex() > 0 ? -1 : (o1.getIndex() - o2.getIndex() < 0 ? 1 : 0));
        if (index < 0) { // not same，index change
            index = -index - 1;

            int oldIndex = -1;
            for (int i = index; i < this.data.size(); i++) {
                if (this.data.get(i).getFromUid() == newData.getFromUid()) {
                    oldIndex = i;
                    this.data.remove(i);
                    break;
                }
            }

            // insert
            if (index < data.size() || canAppend) {
                this.data.add(index, newData);

                if (oldIndex >= 0) {
                    this.notifyItemMoved(oldIndex, index);
                    this.notifyItemChanged(index);
                } else {
                    this.notifyItemInserted(index);
                }
            }

        } else {
            // find same index
            this.data.set(index, newData);
            this.notifyItemChanged(index);
        }

        return index;
    }

    public void setListener(BlockListClickListener listener) {
        this.listener = listener;
    }
}
