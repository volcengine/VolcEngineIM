package com.bytedance.im.app.detail.member.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.model.BIMMember;

import java.util.ArrayList;
import java.util.List;

public class VEMemberListAdapter extends RecyclerView.Adapter<MemberViewHolder> {
    private Context mContext;
    private List<MemberWrapper> data;
    private OnMemberClickListener listener;
    private boolean foreSilentGone;

    public VEMemberListAdapter(Context mContext, List<BIMMember> memberList, OnMemberClickListener listener) {
        this.mContext = mContext;
        this.listener = listener;
        this.foreSilentGone = false;
        data = new ArrayList<>();
        if (memberList != null && !memberList.isEmpty()) {
            for (BIMMember member : memberList) {
                data.add(new MemberWrapper(member, MemberWrapper.TYPE_NORMAL));
            }
        }
        MemberUtils.sort(data);
    }

    public VEMemberListAdapter(Context mContext, OnMemberClickListener listener) {
        this(mContext, listener, false);
    }
    public VEMemberListAdapter(Context mContext, OnMemberClickListener listener, boolean foreSilentGone) {
        this.mContext = mContext;
        this.data = new ArrayList<>();
        this.listener = listener;
        this.foreSilentGone = foreSilentGone;
    }

    public void appendMemberList(List<BIMMember> list) {
        if (list != null) {
            for (BIMMember member : list) {
                MemberWrapper wrapper = new MemberWrapper(member, MemberWrapper.TYPE_NORMAL);
                wrapper.setForceSilentGone(foreSilentGone);
                data.add(wrapper);
            }
            notifyDataSetChanged();
        }
    }

    @NonNull
    @Override
    public MemberViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_recycler_view_item_member_notid, viewGroup, false);
        return new MemberViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MemberViewHolder memberViewHolder, int i) {
        memberViewHolder.bind(data.get(i));
        memberViewHolder.itemView.setOnClickListener(v -> listener.onMemberClick(data.get(memberViewHolder.getAdapterPosition()).getMember()));
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

    @Override
    public int getItemCount() {
        return data.size();
    }

    public interface OnMemberClickListener {
        void onMemberClick(BIMMember member);
    }
}
