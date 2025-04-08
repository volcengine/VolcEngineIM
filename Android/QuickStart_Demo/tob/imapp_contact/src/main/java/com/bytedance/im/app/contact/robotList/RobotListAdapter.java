package com.bytedance.im.app.contact.robotList;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.contact.R;
import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.user.api.model.BIMUserProfile;

import java.util.ArrayList;
import java.util.List;

public class RobotListAdapter extends RecyclerView.Adapter<RobotListViewHolder> {
    private List<RobotDataWrapper> data = new ArrayList<>();
    private OnClickListener onClickListener;
    private RobotDataWrapper selectedData;
    private boolean enableSelect = false;

    @NonNull
    @Override
    public RobotListViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_item_robot, parent, false);
        return new RobotListViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull RobotListViewHolder holder, int position) {
        final int pos = position;
        holder.bind(data.get(pos), enableSelect, (buttonView, isChecked) -> {
            if (selectedData != null) {
                selectedData.setIsSelected(false);
            }
            data.get(pos).setIsSelected(isChecked);
            selectedData = data.get(pos);
            notifyDataSetChanged();
        }, v -> {
            if (onClickListener != null) {
                onClickListener.onClick(data.get(pos).getRawData());
            }
        });
    }

    public void setEnableSelect(boolean enableSelect) {
        this.enableSelect = enableSelect;
        notifyDataSetChanged();
    }

    public void setOnclickListener(OnClickListener listener) {
        onClickListener = listener;
    }

    public RobotDataWrapper getSelectedData() {
        return selectedData;
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void addData(List<BIMUserFullInfo> userProfileList) {
        for (BIMUserFullInfo profile: userProfileList) {
            data.add(new RobotDataWrapper(profile));
        }
    }

    public interface OnClickListener {
        void onClick(BIMUserFullInfo profile);
    }
}

class RobotListViewHolder extends RecyclerView.ViewHolder {
    private final RadioButton rbSelect;
    private final ImageView ivAvatar;
    private final TextView tvName;

    private RobotDataWrapper dataWrapper;

    public RobotListViewHolder(@NonNull View itemView) {
        super(itemView);
        ivAvatar = itemView.findViewById(R.id.iv_head);
        rbSelect = itemView.findViewById(R.id.rb_select);
        tvName = itemView.findViewById(R.id.tv_nick_name);
    }

    public void bind(RobotDataWrapper dataWrapper, boolean enableSelect,
                     CompoundButton.OnCheckedChangeListener listener, View.OnClickListener onClickListener) {
        tvName.setText(dataWrapper.getName());
        rbSelect.setChecked(dataWrapper.getIsSelected());
        rbSelect.setVisibility(enableSelect ? View.VISIBLE : View.GONE);

        ivAvatar.setImageResource(R.drawable.icon_recommend_user_default);
        Glide.with(ivAvatar.getContext())
                .load(dataWrapper.getAvatarUrl())
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(ivAvatar);

        rbSelect.setOnCheckedChangeListener(listener);
        itemView.setOnClickListener(onClickListener);
    }
}