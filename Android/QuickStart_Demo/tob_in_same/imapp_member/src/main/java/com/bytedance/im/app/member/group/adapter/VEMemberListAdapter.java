package com.bytedance.im.app.member.group.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class VEMemberListAdapter extends RecyclerView.Adapter<MemberViewHolder> {
    private Context mContext;
    private List<MemberWrapper> data;
    private OnMemberClickListener listener;
    private boolean isShowSilent;
    private boolean isShowOnline;

    public VEMemberListAdapter(Context mContext, List<MemberWrapper> memberList, OnMemberClickListener listener) {
        this.mContext = mContext;
        this.listener = listener;
        this.isShowSilent = true;
        this.isShowOnline = false;
        data = new ArrayList<>();
        data.addAll(memberList);
        MemberUtils.sort(data);
    }

    public VEMemberListAdapter(Context mContext, OnMemberClickListener listener) {
        this(mContext, listener, true,false);
    }

    public VEMemberListAdapter(Context mContext, OnMemberClickListener listener, boolean isShowSilent, boolean isShowOnline) {
        this.mContext = mContext;
        this.data = new ArrayList<>();
        this.listener = listener;
        this.isShowSilent = isShowSilent;
        this.isShowOnline = isShowOnline;
    }

    public void appendMemberList(List<MemberWrapper> list) {
        if (list != null) {
            for (MemberWrapper wrapper : list) {
                wrapper.setShowSilent(isShowSilent);
                wrapper.setShowOnline(isShowOnline);
                data.add(wrapper);
            }
            notifyDataSetChanged();
        }
    }

    @NonNull
    @Override
    public MemberViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_msg_recycler_view_item_member_notid, viewGroup, false);
        return new MemberViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MemberViewHolder memberViewHolder, int i) {
        memberViewHolder.bind(data.get(i));
        memberViewHolder.itemView.setOnClickListener(v -> listener.onMemberClick(data.get(memberViewHolder.getAdapterPosition())));
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
            MemberWrapper wrapper = data.get(i);
            if (uid == wrapper.getMember().getUserID()) {
                wrapper.setUser(user);
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
        void onMemberClick(MemberWrapper memberWrapper);
    }
}
