package com.bytedance.im.app.live.member.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import com.bytedance.im.app.live.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


public class VELiveUserHorizonAdapter extends RecyclerView.Adapter<VELiveUserHorizonAdapter.UserHorizonViewHolder> {
    private List<BIMUIUser> data = new ArrayList<>();
    private List<BIMUIUser> subData = new ArrayList<>();
    private Context mContext;

    public VELiveUserHorizonAdapter(Context context) {
        mContext = context;
    }

    @NonNull
    @Override
    public UserHorizonViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_live_recycler_view_item_conversation_group_memeber, null, false);
        return new UserHorizonViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull UserHorizonViewHolder userHorizonViewHolder, int i) {
        BIMUIUser user = subData.get(i);
        Glide.with(userHorizonViewHolder.headImg.getContext()).load(user.getPortraitUrl()).placeholder(R.drawable.icon_recommend_user_default).into(userHorizonViewHolder.headImg);
        userHorizonViewHolder.userName.setText(BIMUINameUtils.getShowName(user));
    }

    @Override
    public int getItemCount() {
        return subData.size();
    }

    public void insertData(BIMUIUser userFullInfo) {
        if (data.isEmpty()) {
            data.add(userFullInfo);
        } else {
            data.add(0, userFullInfo);
        }
        notifyDataSetWithSubChanged();
    }

    public void removeData(List<Long> removed) {
        Iterator<BIMUIUser> iterator = data.iterator();
        while (iterator.hasNext()) {
            BIMUIUser user = iterator.next();
            if (removed.contains(user.getUid())) {
                iterator.remove();
            }
        }
        notifyDataSetWithSubChanged();
    }

    public List<BIMUIUser> getUserList() {
        return data;
    }

    public ArrayList<Long> getUserIDList() {
        ArrayList<Long> uidList = new ArrayList<>();
        for (BIMUIUser user : data) {
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
