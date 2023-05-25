package com.bytedance.im.ui.member;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.R;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class BIMGroupMemberListAdapter extends RecyclerView.Adapter<BIMMemberViewHolder> {
    private Context mContext;
    private List<BIMMemberWrapper> data;
    private OnMemberClickListener listener;

    public BIMGroupMemberListAdapter(Context mContext, List<BIMMember> memberList, OnMemberClickListener listener) {
        this.mContext = mContext;
        this.listener = listener;
        data = new ArrayList<>();
        if (memberList != null && !memberList.isEmpty()) {
            for (BIMMember member : memberList) {
                data.add(new BIMMemberWrapper(member, BIMMemberWrapper.TYPE_NORMAL));
            }
        }
        Collections.sort(data, (o1, o2) -> {
            int tr = o1.getOrder() - o2.getOrder();
            if (tr == 0) {
                return (int) (o1.getMember().getUserID() - (int)o2.getMember().getUserID());
            } else {
                return tr;
            }
        });
    }

    @NonNull
    @Override
    public BIMMemberViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.bim_recycler_view_item_member_notid, viewGroup, false);
        return new BIMMemberViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull BIMMemberViewHolder memberViewHolder, int i) {
        memberViewHolder.bind(data.get(i));
        memberViewHolder.itemView.setOnClickListener(v -> listener.onMemberClick(data.get(memberViewHolder.getAdapterPosition()).getMember()));
    }


    @Override
    public int getItemCount() {
        return data.size();
    }

    public interface OnMemberClickListener {
        void onMemberClick(BIMMember member);
    }
}
