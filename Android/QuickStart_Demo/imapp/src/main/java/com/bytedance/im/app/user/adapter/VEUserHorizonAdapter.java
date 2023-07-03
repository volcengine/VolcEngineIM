package com.bytedance.im.app.user.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.api.BIMUser;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


public class VEUserHorizonAdapter extends RecyclerView.Adapter<VEUserHorizonAdapter.UserHorizonViewHolder> {
    private List<BIMUser> data = new ArrayList<>();
    private List<BIMUser> subData = new ArrayList<>();
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
        BIMUser user = subData.get(i);
        userHorizonViewHolder.headImg.setImageResource(user.getHeadImg());
        userHorizonViewHolder.userName.setText(user.getNickName());
    }

    @Override
    public int getItemCount() {
        return subData.size();
    }

    public void insertData(BIMUser bimUser) {
        if (data.isEmpty()) {
            data.add(bimUser);
        } else {
            data.add(0, bimUser);
        }
        notifyDataSetWithSubChanged();
    }

    public void removeData(List<Long> removed) {
        Iterator<BIMUser> iterator = data.iterator();
        while (iterator.hasNext()) {
            BIMUser user = iterator.next();
            if (removed.contains(user.getUserID())) {
                iterator.remove();
            }
        }
        notifyDataSetWithSubChanged();
    }

    public List<BIMUser> getUserList() {
        return data;
    }

    public ArrayList<Long> getUserIDList() {
        ArrayList<Long> uidList = new ArrayList<>();
        for (BIMUser user : data) {
            uidList.add(user.getUserID());
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
