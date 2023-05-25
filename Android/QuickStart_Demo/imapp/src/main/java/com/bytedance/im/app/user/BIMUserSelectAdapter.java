package com.bytedance.im.app.user;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.user.BIMUser;

import java.util.ArrayList;
import java.util.List;

public class BIMUserSelectAdapter extends RecyclerView.Adapter<BaseSelectViewHolder> {
    private List<UserSelectWrapper> data = new ArrayList<>();
    private Context context;
    private boolean selectSingle = false; //单选

    public BIMUserSelectAdapter(Context context, List<BIMUser> list) {
        this(context, list, false,false);
    }

    public BIMUserSelectAdapter(Context context, List<BIMUser> list, boolean isSelectSingle, boolean isShowUid) {
        this.context = context;
        this.selectSingle = isSelectSingle;
        for (BIMUser user : list) {
            if (user.getUuid() == BIMUIClient.getInstance().getCurUserId()) continue; //排除掉自己
            data.add(new UserSelectWrapper(user, R.layout.ve_im_recycler_view_item_user_select_notid, isShowUid));
        }
    }

    @NonNull
    @Override
    public BaseSelectViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(context).inflate(data.get(i).layoutId, viewGroup, false);
        BaseSelectViewHolder baseSelectViewHolder = null;
        if (data.get(i).getLayoutId() == R.layout.ve_im_recycler_view_item_user_select_notid) {
            baseSelectViewHolder = new BIMUserSelectViewHolder(view);
        }
        return baseSelectViewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull BaseSelectViewHolder baseSelectViewHolder, int i) {
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
            List<UserSelectWrapper> selectList = getSelectWrapper();
            if (selectList.size() == 1) {
                UserSelectWrapper userSelectWrapper = data.get(position);
                UserSelectWrapper lastSelectWrapper = selectList.get(0);
                if (userSelectWrapper.getInfo().getUuid() != lastSelectWrapper.getInfo().getUuid()) {
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
        for (UserSelectWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper.getInfo());
            }
        }
        return result;
    }

    private List<UserSelectWrapper> getSelectWrapper() {
        List<UserSelectWrapper> result = new ArrayList<>();
        for (UserSelectWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }
}
