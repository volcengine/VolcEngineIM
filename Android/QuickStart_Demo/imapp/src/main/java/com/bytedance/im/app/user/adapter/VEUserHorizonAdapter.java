package com.bytedance.im.app.user.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


public class VEUserHorizonAdapter extends RecyclerView.Adapter<VEUserHorizonAdapter.UserHorizonViewHolder> {
    private List<BIMUserFullInfo> data = new ArrayList<>();
    private List<BIMUserFullInfo> subData = new ArrayList<>();
    private Context mContext;

    public VEUserHorizonAdapter(Context context) {
        mContext = context;
    }

    @NonNull
    @Override
    public UserHorizonViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_recycler_view_item_conversation_group_memeber, null, false);
        return new VEUserHorizonAdapter.UserHorizonViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull UserHorizonViewHolder userHorizonViewHolder, int i) {
        BIMUserFullInfo user = subData.get(i);
        Glide.with(userHorizonViewHolder.headImg.getContext()).load(user.getPortraitUrl()).placeholder(R.drawable.icon_recommend_user_default).into(userHorizonViewHolder.headImg);
        userHorizonViewHolder.userName.setText(VENameUtils.getShowName(user));
    }

    @Override
    public int getItemCount() {
        return subData.size();
    }

    public void insertData(BIMUserFullInfo userFullInfo) {
        if (data.isEmpty()) {
            data.add(userFullInfo);
        } else {
            data.add(0, userFullInfo);
        }
        notifyDataSetWithSubChanged();
    }

    public void removeData(List<Long> removed) {
        Iterator<BIMUserFullInfo> iterator = data.iterator();
        while (iterator.hasNext()) {
            BIMUserFullInfo user = iterator.next();
            if (removed.contains(user.getUid())) {
                iterator.remove();
            }
        }
        notifyDataSetWithSubChanged();
    }

    public List<BIMUserFullInfo> getUserList() {
        return data;
    }

    public ArrayList<Long> getUserIDList() {
        ArrayList<Long> uidList = new ArrayList<>();
        for (BIMUserFullInfo user : data) {
            uidList.add(user.getUid());
        }
        return uidList;
    }

    public void notifyDataSetWithSubChanged(){
        if (data.size() >= 5) {
            subData = new ArrayList<>(data.subList(0, 5));
        } else {
            subData = data;
        }
        notifyDataSetChanged();
    }

    public static class UserHorizonViewHolder extends RecyclerView.ViewHolder {

        private ImageView headImg;
        private TextView userName;

        public UserHorizonViewHolder(@NonNull View itemView) {
            super(itemView);
            headImg = itemView.findViewById(R.id.iv_conversation_member_head_img);
            userName = itemView.findViewById(R.id.tv_conversation_member_name);
        }
    }
}
