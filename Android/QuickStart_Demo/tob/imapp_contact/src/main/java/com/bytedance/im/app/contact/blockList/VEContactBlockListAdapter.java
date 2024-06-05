package com.bytedance.im.app.contact.blockList;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


import com.bytedance.im.app.contact.R;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VEContactBlockListAdapter extends RecyclerView.Adapter<VEContactBlockListViewHolder> {
    private BlackListClickListener listener;
    private final List<VEContactBlackListData> data = new ArrayList<>();

    @NonNull
    @Override
    public VEContactBlockListViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_item_contact, viewGroup, false);
        return new VEContactBlockListViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VEContactBlockListViewHolder veContactInviteViewHolder, int i) {
        VEContactBlackListData preData = null;
        if (i > 0) {
            preData = data.get(i - 1);
        }
        VEContactBlackListData itemData = data.get(i);
        veContactInviteViewHolder.onBind(itemData, preData, this.listener);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<VEContactBlackListData> appendData, boolean needClear) {
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

    public void insertOrUpdateData(VEContactBlackListData newData) {
        for (int i = 0; i < this.data.size(); i++) {
            if (this.data.get(i).getId() == newData.getId()) {
                this.data.remove(i);
                break;
            }
        }

        this.data.add(newData);
        Collections.sort(this.data, VEContactBlackListData::compare);
        notifyDataSetChanged();
    }

    public void removeData(VEContactBlackListData deleteData) {
        int index = -1;
        for (int i = 0; i < getItemCount(); i++) {
            if (data.get(i).getId() == deleteData.getId()) {
                index = i;
                break;
            }
        }
        if (index >= 0) {
            boolean needNotifyNext = index != data.size() - 1;
            data.remove(index);
            notifyItemRemoved(index);
            if (needNotifyNext) {
                notifyItemChanged(index);
            }
        }
    }

    public VEContactBlackListData getData(long uid) {
        for (VEContactBlackListData d: data) {
            if (d.getId() == uid) {
                return d;
            }
        }
        return null;
    }

    public void setListener(BlackListClickListener listener) {
        this.listener = listener;
    }
}
