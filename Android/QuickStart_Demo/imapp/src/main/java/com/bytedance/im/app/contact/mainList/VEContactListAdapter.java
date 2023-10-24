package com.bytedance.im.app.contact.mainList;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.app.contact.mainList.viewHolder.VEContactListActionViewHolder;
import com.bytedance.im.app.contact.mainList.viewHolder.VEContactListBaseViewHolder;
import com.bytedance.im.app.contact.mainList.viewHolder.VEContactListViewHolder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VEContactListAdapter extends RecyclerView.Adapter<VEContactListBaseViewHolder> {
    private OnClickListener listener;
    private List<ContactListDataInfo<?>> data = new ArrayList<>();
    private final List<ContactListDataInfo<?>> stickTopData = new ArrayList<>();

    @NonNull
    @Override
    public VEContactListBaseViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType) {
        VEContactListBaseViewHolder viewHolder = null;
        switch (viewType) {
            case ContactListItemType.TYPE_CONTACT:
                View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_item_contact, viewGroup, false);
                viewHolder = new VEContactListViewHolder(v);
            break;
            default:
                v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_item_contact_list_action, viewGroup, false);
                viewHolder = new VEContactListActionViewHolder(v);
            break;
        }
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull VEContactListBaseViewHolder veContactListBaseViewHolder, int i) {
        ContactListDataInfo<?> preData = null;
        if (i > 0) {
            preData = data.get(i - 1);
        }
        ContactListDataInfo<?> itemData = data.get(i);
        veContactListBaseViewHolder.onBind(itemData, preData);
        veContactListBaseViewHolder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onClick(v, itemData);
            }
        });
        veContactListBaseViewHolder.itemView.setOnLongClickListener(v -> {
            if (listener != null) {
                listener.onLongClick(v, itemData);
            }
            return true;
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

    public void setListener(OnClickListener listener) {
        this.listener = listener;
    }

    public void appendData(List<ContactListDataInfo<?>> data, boolean needClear) {
        if (needClear) {
            this.data.clear();
            this.data.addAll(stickTopData);
        }
        this.data.addAll(data);
        this.notifyDataSetChanged();
    }

    public void setStickUpItem(List<ContactListDataInfo<?>> data) {
        this.data.removeAll(this.stickTopData);

        this.stickTopData.clear();
        this.stickTopData.addAll(data);
        this.data.addAll(0, this.stickTopData);
        this.notifyDataSetChanged();
    }

    public void updateStickTopData(ContactListDataInfo<?> newData) {
        for (int i = 0; i < this.stickTopData.size(); i++) {
            if (this.data.get(i).getId() == newData.getId()) {
                this.stickTopData.set(i, newData);
                this.data.set(i, newData);
                this.notifyItemChanged(i);
                break;
            }
        }
    }

    public void removeData(ContactListDataInfo<?> newData) {
        for (int i = 0; i < this.data.size(); i++) {
            if (this.data.get(i).getId() == newData.getId()) {
                this.data.remove(i);
                this.notifyItemRemoved(i);
                this.notifyItemChanged(i);
                break;
            }
        }
    }

    private void removePreData(ContactListDataInfo<?> newData) {
        for (int i = 0; i < this.data.size(); i++) {
            if (this.data.get(i) != newData && this.data.get(i).getId() == newData.getId()) {
                this.data.remove(i);
                this.notifyItemRemoved(i);
                this.notifyItemChanged(i);
                break;
            }
        }
    }

    public void insertOrUpdate(ContactListDataInfo<?> newData, boolean canAppend) {
        int index = Collections.binarySearch(this.data.subList(this.stickTopData.size(), this.data.size()), newData, ContactListDataInfo::compare);

        if (index < 0) {
            index = -index - 1;
            index += stickTopData.size();
            if (index < data.size() || canAppend) {
                this.data.add(index, newData);
                this.notifyItemInserted(index);
                this.notifyItemChanged(index + 1);
                removePreData(newData);
            }
        } else {
            index += stickTopData.size();
            if (this.data.get(index).getId() == newData.getId()) {
                // update
                this.data.set(index, newData);
                this.notifyItemRangeChanged(index, 2);
                removePreData(newData);
            } else {
                // insert
                if (index < data.size() || canAppend) {
                    this.data.add(index, newData);
                    this.notifyItemInserted(index);
                    this.notifyItemChanged(index + 1);
                    removePreData(newData);
                }
            }
        }
    }
}
