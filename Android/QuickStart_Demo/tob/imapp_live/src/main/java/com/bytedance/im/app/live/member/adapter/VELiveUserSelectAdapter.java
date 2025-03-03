package com.bytedance.im.app.live.member.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;


import com.bytedance.im.app.live.R;
import com.bytedance.im.ui.api.BIMUIUser;


import java.util.ArrayList;
import java.util.List;

public class VELiveUserSelectAdapter extends RecyclerView.Adapter<VELiveBaseSelectViewHolder> {
    private List<VELiveUserSelectWrapper> data = new ArrayList<>();
    private Context context;
    private boolean selectSingle = false; //单选

    public VELiveUserSelectAdapter(Context context, List<BIMUIUser> list) {
        this(context, list, false,false);
    }

    public VELiveUserSelectAdapter(Context context, List<BIMUIUser> list, boolean isSelectSingle, boolean isShowUid) {
        this.context = context;
        this.selectSingle = isSelectSingle;
        for (BIMUIUser user : list) {
            data.add(new VELiveUserSelectWrapper(user, R.layout.ve_im_live_recycler_view_item_user_select_notid, isShowUid));
        }
    }

    @NonNull
    @Override
    public VELiveBaseSelectViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(context).inflate(data.get(i).layoutId, viewGroup, false);
        VELiveBaseSelectViewHolder baseSelectViewHolder = null;
        if (data.get(i).getLayoutId() == R.layout.ve_im_live_recycler_view_item_user_select_notid) {
            baseSelectViewHolder = new VELiveUserSelectViewHolder(view);
        }
        return baseSelectViewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull VELiveBaseSelectViewHolder baseSelectViewHolder, int i) {
        baseSelectViewHolder.bind(data.get(i));
        baseSelectViewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemCheckChanged(baseSelectViewHolder.getAdapterPosition());
            }
        });
    }


    private void itemCheckChanged(int position) {
        if (selectSingle) {
            //单选
            List<VELiveUserSelectWrapper> selectList = getSelectWrapper();
            if (selectList.size() == 1) {
                VELiveUserSelectWrapper userSelectWrapper = data.get(position);
                VELiveUserSelectWrapper lastSelectWrapper = selectList.get(0);
                if (userSelectWrapper.getInfo().getUid() != lastSelectWrapper.getInfo().getUid()) {
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
        for (VELiveUserSelectWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper.getInfo());
            }
        }
        return result;
    }

    private List<VELiveUserSelectWrapper> getSelectWrapper() {
        List<VELiveUserSelectWrapper> result = new ArrayList<>();
        for (VELiveUserSelectWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }
}
