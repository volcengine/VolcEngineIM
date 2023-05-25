package com.bytedance.im.app.login.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.user.BIMUser;

import java.util.ArrayList;
import java.util.List;

public class VEUserSelectAdapter extends RecyclerView.Adapter<VEUserSelectViewHolder> {
    private List<VEUserSelectWrapper> data = new ArrayList<>();
    private Context context;
    private boolean selectSingle = false; //单选

    public VEUserSelectAdapter(Context context, List<BIMUser> list) {
        this(context, list, true);
    }

    public VEUserSelectAdapter(Context context, List<BIMUser> list, boolean isSelectSingle) {
        this.context = context;
        this.selectSingle = isSelectSingle;
        for (BIMUser user : list) {
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
                if (userSelectWrapper.getUser().getUuid() != lastSelectWrapper.getUser().getUuid()) {
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

    public List<BIMUser> getSelectUser() {
        List<BIMUser> result = new ArrayList<>();
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
