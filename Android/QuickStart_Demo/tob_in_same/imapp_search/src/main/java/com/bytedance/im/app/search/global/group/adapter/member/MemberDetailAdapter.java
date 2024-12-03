package com.bytedance.im.app.search.global.group.adapter.member;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.search.api.model.BIMSearchMemberInfo;

import java.util.ArrayList;
import java.util.List;

public class MemberDetailAdapter extends RecyclerView.Adapter<MemberDetailViewHolder> {

    List<BIMSearchMemberInfo> data = new ArrayList<>();

    public MemberDetailAdapter(List<BIMSearchMemberInfo> data) {
        if (data == null) {
            this.data = new ArrayList<>();
        } else {
            this.data = data;
        }
    }

    @NonNull
    @Override
    public MemberDetailViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_group_member, parent, false);
        return new MemberDetailViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MemberDetailViewHolder holder, int position) {
        holder.update(data.get(position));
    }

    @Override
    public int getItemCount() {
        return data.size();
    }
}
