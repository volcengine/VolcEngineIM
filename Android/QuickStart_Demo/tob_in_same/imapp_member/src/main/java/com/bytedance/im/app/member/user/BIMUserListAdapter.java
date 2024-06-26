package com.bytedance.im.app.member.user;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


import com.bytedance.im.app.member.R;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.List;

public class BIMUserListAdapter extends RecyclerView.Adapter<UserViewHolder> {

    private Context mContext;
    private List<BIMUIUser> data;
    private OnUserLoginClickListener listener;

    public BIMUserListAdapter(Context mContext, List<BIMUIUser> data, OnUserLoginClickListener listener) {
        this.mContext = mContext;
        this.data = data;
        this.listener = listener;
    }

    @NonNull
    @Override
    public UserViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_recycler_view_item_user_notid, viewGroup, false);
        return new UserViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull UserViewHolder loginUserViewHolder, int i) {
        BIMUIUser user = data.get(i);
        loginUserViewHolder.bind(user);
        loginUserViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onUserClick(user);
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public interface OnUserLoginClickListener {
        void onUserClick(BIMUIUser user);
    }
}
