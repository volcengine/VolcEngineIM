package com.bytedance.im.app.member.user.adapter;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.user.VEUserSelectWrapper;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class VEUserSelectAdapter extends RecyclerView.Adapter<VEUserSelectViewHolder> {
    private List<VEUserSelectWrapper> data = new ArrayList<>();
    private Context context;
    private boolean selectSingle = false; //单选

    public VEUserSelectAdapter(Context context, List<BIMUIUser> list) {
        this(context, list, true);
    }

    public VEUserSelectAdapter(Context context, List<BIMUIUser> list, boolean isSelectSingle) {
        this.context = context;
        this.selectSingle = isSelectSingle;
        for (BIMUIUser user : list) {
            data.add(new VEUserSelectWrapper(user));
        }
    }

    @NonNull
    @Override
    public VEUserSelectViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(context).inflate(R.layout.ve_item_login_layout, viewGroup, false);
        VEUserSelectViewHolder baseSelectViewHolder = new VEUserSelectViewHolder(view);
        return baseSelectViewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull VEUserSelectViewHolder veUserSelectViewHolder, int i) {
        veUserSelectViewHolder.bind(data.get(i));
        veUserSelectViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemCheckChanged(veUserSelectViewHolder.getAdapterPosition());
            }
        });
    }

    private void itemCheckChanged(int position) {
        if (selectSingle) {
            //单选
            List<VEUserSelectWrapper> selectList = getSelectWrapper();
            if (selectList.size() == 1) {
                VEUserSelectWrapper userSelectWrapper = data.get(position);
                VEUserSelectWrapper lastSelectWrapper = selectList.get(0);
                if (userSelectWrapper.getUser().getUid() != lastSelectWrapper.getUser().getUid()) {
                    lastSelectWrapper.isSelect = !lastSelectWrapper.isSelect;
                    userSelectWrapper.isSelect = true;
                } else {
                    userSelectWrapper.isSelect = !userSelectWrapper.isSelect;
                }
            } else {
                data.get(position).isSelect = !data.get(position).isSelect;
            }
        } else {
            //多选
            data.get(position).isSelect = !data.get(position).isSelect;
        }
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public List<BIMUIUser> getSelectUser() {
        List<BIMUIUser> result = new ArrayList<>();
        for (VEUserSelectWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper.getUser());
            }
        }
        return result;
    }

    private List<VEUserSelectWrapper> getSelectWrapper() {
        List<VEUserSelectWrapper> result = new ArrayList<>();
        for (VEUserSelectWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }
}
