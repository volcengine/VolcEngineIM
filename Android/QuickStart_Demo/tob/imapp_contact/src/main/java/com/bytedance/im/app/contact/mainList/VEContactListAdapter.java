package com.bytedance.im.app.contact.mainList;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.contact.R;
import com.bytedance.im.app.contact.mainList.viewHolder.VEContactListActionViewHolder;
import com.bytedance.im.app.contact.mainList.viewHolder.VEContactListBaseViewHolder;
import com.bytedance.im.app.contact.mainList.viewHolder.VEContactListViewHolder;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.enums.BIMFriendOnlineStatus;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VEContactListAdapter extends RecyclerView.Adapter<VEContactListBaseViewHolder> {
    private OnClickListener listener;
    private final ContactStatusProvider provider;
    private List<ContactListDataInfo<?>> data = new ArrayList<>();
    private final List<ContactListDataInfo<?>> stickTopData = new ArrayList<>();

    public VEContactListAdapter(ContactStatusProvider provider) {
        this.provider = provider;
    }

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

        boolean isOnline = false;
        if (provider != null) {
            isOnline = provider.getFriendStatus(itemData.getId());
        }

        veContactListBaseViewHolder.onBind(itemData, preData, isOnline);
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
        if (veContactListBaseViewHolder instanceof VEContactListViewHolder) {
            veContactListBaseViewHolder.itemView.findViewById(R.id.iv_head).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (listener != null) {
                        listener.onPortraitClick(v, itemData);
                    }
                }
            });
        }
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

    public void refreshStatus() {
        if (provider != null) {
            List<Long> uidList = new ArrayList<>();
            for (ContactListDataInfo<?> d : data) {
                uidList.add(d.getId());
            }
            provider.refreshFriendStatus(uidList, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    notifyDataSetChanged();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    notifyDataSetChanged();
                }
            });
        } else {
            notifyDataSetChanged();
        }
    }

    public void appendData(List<ContactListDataInfo<?>> data, boolean needClear) {
        if (needClear) {
            this.data.clear();
            this.data.addAll(stickTopData);
        }
        this.data.addAll(data);
        refreshStatus();
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

        refreshItemStatus(newData);
    }

    private void refreshItemStatus(ContactListDataInfo<?> newData) {
        if (provider != null) {
            provider.refreshFriendStatus(Collections.singletonList(newData.getId()), new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    int index = Collections.binarySearch(data.subList(stickTopData.size(), data.size()), newData, ContactListDataInfo::compare);

                    if (index >= 0) {
                        index += stickTopData.size();
                        if (data.get(index).getId() == newData.getId()) {
                            // update
                            notifyItemRangeChanged(index, 1);
                        }
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
    }

    public void onStatusChanged(Map<Long, BIMFriendOnlineStatus> updateInfo) {
        if (provider != null) {
            provider.update(updateInfo);

            for (int i = 0; i < data.size(); i++) {
                long dataId = data.get(i).getId();
                if (updateInfo.get(dataId) != null) {
                    notifyItemChanged(i);
                }
            }
        }
    }

    public static class ContactStatusProvider {
        private final Map<Long, BIMFriendOnlineStatus> onlineStatusMap = new HashMap<>();

        private void update(Map<Long, BIMFriendOnlineStatus> newStatus) {
            onlineStatusMap.putAll(newStatus);
        }

        public void refreshFriendStatus(List<Long> uidList, BIMSimpleCallback callback) {
            BIMClient.getInstance().getServiceManager().getService(BIMContactExpandService.class).getFriendOnlineStatus(uidList, new BIMResultCallback<Map<Long, BIMFriendOnlineStatus>>() {
                @Override
                public void onSuccess(Map<Long, BIMFriendOnlineStatus> result) {
                    update(result);
                    if (callback != null) {
                        callback.onSuccess();
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    if (callback != null) {
                        callback.onFailed(code);
                    }
                }
            });
        }

        public boolean getFriendStatus(long uid) {
            BIMFriendOnlineStatus status = onlineStatusMap.get(uid);
            if (status != null) {
                return status == BIMFriendOnlineStatus.BIM_FRIEND_ONLINE_STATUS_ONLINE;
            } else {
                return false;
            }
        }
    }
}
