package com.bytedance.im.app.live.member.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.VELiveMemberUtils;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;

import java.util.ArrayList;
import java.util.List;

public class VELiveMemberSelectAdapter extends RecyclerView.Adapter<VELiveMemberSelectViewHolder> {
    private Context mContext;
    private List<VELiveMemberWrapper> data;
    private boolean selectSingle = false;
    private boolean isShowTag = true;

    /**
     * 普通群是全量
     *
     * @param mContext
     * @param checkedList
     */
    public VELiveMemberSelectAdapter(Context mContext, List<VELiveMemberWrapper> memberWrapperList, List<VELiveMemberWrapper> checkedList, boolean isTag) {
        this.mContext = mContext;
        data = new ArrayList<>();
        this.isShowTag = isTag;
        List<Long> checkedIdList = new ArrayList<>();
        if (checkedList != null) {
            for (VELiveMemberWrapper memberWrapper : checkedList) {
                checkedIdList.add(memberWrapper.getMember().getUserID());
            }
        }
        if (memberWrapperList != null && !memberWrapperList.isEmpty()) {
            for (VELiveMemberWrapper wrapper : memberWrapperList) {
                wrapper.setShowTag(isShowTag);
                if (checkedIdList.contains(wrapper.getMember().getUserID())) {
                    wrapper.isSelect = true;
                }
                if (wrapper.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                    wrapper.setOwner(true);
                }
                data.add(wrapper);
            }
        }
        VELiveMemberUtils.sort(data);
    }


    public VELiveMemberSelectAdapter(Context mContext) {
        this(mContext, new ArrayList<>(), new ArrayList<>(), true);
    }

    @NonNull
    @Override
    public VELiveMemberSelectViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_live_recycler_view_item_member_select_notid, viewGroup, false);
        return new VELiveMemberSelectViewHolder(view);
    }


    @Override
    public void onBindViewHolder(@NonNull VELiveMemberSelectViewHolder memberViewHolder, int i) {
        memberViewHolder.bind(data.get(i));
        memberViewHolder.itemView.setOnClickListener(v -> itemCheckChanged(memberViewHolder.getAdapterPosition()));
    }


    private void itemCheckChanged(int position) {
        if (data.get(position).isOwner()) {
            return;
        }
        if (selectSingle) {
            //单选
            List<VELiveMemberWrapper> selectList = getSelectWrapper();
            if (selectList.size() == 1) {
                VELiveMemberWrapper userSelectWrapper = data.get(position);
                VELiveMemberWrapper lastSelectWrapper = selectList.get(0);
                if (userSelectWrapper.getMember().getUserID() != lastSelectWrapper.getMember().getUserID()) {
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

    /**
     * 直播群是分页
     *
     * @param list
     */
    public void appendMemberList(List<BIMMember> list) {
        if (list == null) return;
        VELiveMemberUtils.getMemberWrapperList(list, new BIMResultCallback<List<VELiveMemberWrapper>>() {
            @Override
            public void onSuccess(List<VELiveMemberWrapper> wrapperList) {
                data.addAll(wrapperList);
                notifyDataSetChanged();
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public List<VELiveMemberWrapper> getSelectMember() {
        List<VELiveMemberWrapper> result = new ArrayList<>();
        for (VELiveMemberWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }

    private List<VELiveMemberWrapper> getSelectWrapper() {
        List<VELiveMemberWrapper> result = new ArrayList<>();
        for (VELiveMemberWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }
}
