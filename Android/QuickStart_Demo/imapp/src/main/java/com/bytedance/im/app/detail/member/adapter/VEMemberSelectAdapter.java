package com.bytedance.im.app.detail.member.adapter;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.VEMemberUtils;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;

import java.util.ArrayList;
import java.util.List;

public class VEMemberSelectAdapter extends RecyclerView.Adapter<MemberSelectViewHolder> {
    private Context mContext;
    private List<MemberWrapper> data;
    private boolean selectSingle = false;
    private boolean isShowTag = true;

    /**
     * 普通群是全量
     *
     * @param mContext
     * @param memberList
     * @param checkedList
     */
    public VEMemberSelectAdapter(Context mContext, List<MemberWrapper> memberWrapperList, List<MemberWrapper> checkedList, boolean isTag) {
        this.mContext = mContext;
        data = new ArrayList<>();
        this.isShowTag = isTag;
        List<Long> checkedIdList = new ArrayList<>();
        if (checkedList != null) {
            for (MemberWrapper memberWrapper : checkedList) {
                checkedIdList.add(memberWrapper.getMember().getUserID());
            }
        }
        if (memberWrapperList != null && !memberWrapperList.isEmpty()) {
            for (MemberWrapper wrapper : memberWrapperList) {
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
        MemberUtils.sort(data);
    }


    public VEMemberSelectAdapter(Context mContext) {
        this(mContext, new ArrayList<>(), new ArrayList<>(), true);
    }

    @NonNull
    @Override
    public MemberSelectViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_im_recycler_view_item_member_select_notid, viewGroup, false);
        return new MemberSelectViewHolder(view);
    }


    @Override
    public void onBindViewHolder(@NonNull MemberSelectViewHolder memberViewHolder, int i) {
        memberViewHolder.bind(data.get(i));
        memberViewHolder.itemView.setOnClickListener(v -> itemCheckChanged(memberViewHolder.getAdapterPosition()));
    }


    private void itemCheckChanged(int position) {
        if (data.get(position).isOwner()) {
            return;
        }
        if (selectSingle) {
            //单选
            List<MemberWrapper> selectList = getSelectWrapper();
            if (selectList.size() == 1) {
                MemberWrapper userSelectWrapper = data.get(position);
                MemberWrapper lastSelectWrapper = selectList.get(0);
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
        VEMemberUtils.getMemberWrapperList(list, new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> wrapperList) {
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

    public List<MemberWrapper> getSelectMember() {
        List<MemberWrapper> result = new ArrayList<>();
        for (MemberWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }

    private List<MemberWrapper> getSelectWrapper() {
        List<MemberWrapper> result = new ArrayList<>();
        for (MemberWrapper wrapper : data) {
            if (wrapper.isSelect) {
                result.add(wrapper);
            }
        }
        return result;
    }
}
