package com.bytedance.im.app.live.member.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.VELiveMemberUtils;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class VELiveMemberListAdapter extends RecyclerView.Adapter<VELiveMemberViewHolder> {
    private Context mContext;
    private List<VELiveMemberWrapper> data;
    private OnMemberClickListener listener;
    private boolean isShowSilent;
    private boolean isShowOnline;

    public VELiveMemberListAdapter(Context mContext, List<VELiveMemberWrapper> memberList, OnMemberClickListener listener) {
        this.mContext = mContext;
        this.listener = listener;
        this.isShowSilent = true;
        this.isShowOnline = false;
        data = new ArrayList<>();
        data.addAll(memberList);
        VELiveMemberUtils.sort(data);
    }

    public VELiveMemberListAdapter(Context mContext, OnMemberClickListener listener) {
        this(mContext, listener, true,false);
    }

    public VELiveMemberListAdapter(Context mContext, OnMemberClickListener listener, boolean isShowSilent, boolean isShowOnline) {
        this.mContext = mContext;
        this.data = new ArrayList<>();
        this.listener = listener;
        this.isShowSilent = isShowSilent;
        this.isShowOnline = isShowOnline;
    }

    public void appendMemberList(List<VELiveMemberWrapper> list) {
        if (list != null) {
            for (VELiveMemberWrapper wrapper : list) {
                wrapper.setShowSilent(isShowSilent);
                wrapper.setShowOnline(isShowOnline);
                data.add(wrapper);
            }
            notifyDataSetChanged();
        }
    }

    @NonNull
    @Override
    public VELiveMemberViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_live_recycler_view_item_member_notid, viewGroup, false);
        return new VELiveMemberViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull VELiveMemberViewHolder VELiveMemberViewHolder, int i) {
        VELiveMemberViewHolder.bind(data.get(i));
        VELiveMemberViewHolder.itemView.setOnClickListener(v -> listener.onMemberClick(data.get(VELiveMemberViewHolder.getAdapterPosition())));
    }

    public void remove(long uid){
        int findIndex = -1;
        if (data != null) {
            for (int i = 0; i < data.size(); i++) {
                BIMMember member = data.get(i).getMember();
                if(member.getUserID() == uid){
                    findIndex = i;
                    break;
                }
            }
        }
        data.remove(findIndex);
        notifyItemRemoved(findIndex);
    }


    public void clear() {
        if (data != null) {
            data.clear();
        }
    }

    public void updateUserInfo(BIMUIUser user){
        long uid = user.getUid();
        for (int i = 0; i < data.size(); i++) {
            VELiveMemberWrapper wrapper = data.get(i);
            if (uid == wrapper.getMember().getUserID()) {
                wrapper.setFullInfo(user);
                notifyItemChanged(i);
                break;
            }
        }
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public interface OnMemberClickListener {
        void onMemberClick(VELiveMemberWrapper memberWrapper);
    }
}
