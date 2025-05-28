package com.bytedance.im.app.member.group.adapter;

import static com.bytedance.im.app.member.group.adapter.MemberWrapper.TYPE_ADD;
import static com.bytedance.im.app.member.group.adapter.MemberWrapper.TYPE_DELETE;
import static com.bytedance.im.app.member.group.adapter.MemberWrapper.TYPE_NORMAL;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.CircleCrop;
import com.bumptech.glide.request.RequestOptions;
import com.bytedance.im.app.member.R;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 横向的 adapter
 */
public class VEMemberHozionAdapter extends RecyclerView.Adapter<VEMemberHozionAdapter.ConversationDetailMemberHolder> {
    private static final String TAG = "ConversationDetailMemberAdapter";
    private static final int ADD_MEMBER_VIEW_MAX_COUNT = 5;
    private OnClickListener listener;
    private List<MemberWrapper> data;
    private Context mContext;

    public VEMemberHozionAdapter(Context context, OnClickListener listener) {
        mContext = context;
        this.listener = listener;
    }

    public void updateUserInfoList(List<MemberWrapper> memberList, boolean isShowAdd, boolean isShowRemove) {
        if (memberList == null) return;
        data = new ArrayList<>();
        data.addAll(memberList);
        MemberUtils.sortWrap(data);
        if (data.size() > 5) {
            data = new ArrayList<>(data.subList(0, 5));
        }
        if (isShowAdd) {
            data.add(new MemberWrapper(null,null, TYPE_ADD));
        }
        if (isShowRemove) {
            data.add(new MemberWrapper(null, null,TYPE_DELETE));
        }
        MemberUtils.sortWrap(data);
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ConversationDetailMemberHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.ve_recycler_view_item_message_group_memeber, null, false);
        return new ConversationDetailMemberHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ConversationDetailMemberHolder viewHolder, int position) {
        MemberWrapper memberWrapper = data.get(position);
        int type = memberWrapper.getType();
        if (type == TYPE_NORMAL) {
            BIMMember member = memberWrapper.getMember();
            int resId = R.drawable.icon_recommend_user_default;
            BIMUIUser user  = memberWrapper.getUser();;
            String name = BIMUINameUtils.getShowNameInGroup(memberWrapper.getMember(), user);
            String avatarUrl = BIMUINameUtils.getPortraitUrl(memberWrapper.getMember(), user);
            Drawable drawable = mContext.getResources().getDrawable(resId);
            if (TextUtils.isEmpty(avatarUrl)) {
                Glide.with(mContext).load(drawable).apply(RequestOptions.placeholderOf(R.drawable.icon_recommend_user_default))
                        .apply(RequestOptions.bitmapTransform(new CircleCrop())).into(viewHolder.headImg);
            } else {
                Glide.with(mContext).load(avatarUrl).apply(RequestOptions.placeholderOf(R.drawable.icon_recommend_user_default))
                        .apply(RequestOptions.bitmapTransform(new CircleCrop())).error(drawable).into(viewHolder.headImg);
            }

            viewHolder.userName.setText(name);
            viewHolder.userName.setVisibility(View.VISIBLE);
            viewHolder.itemView.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onMemberClick(member);
                }
            });
        } else if (type == TYPE_ADD) {
            viewHolder.headImg.setImageResource(R.drawable.icon_im_conversation_member_add);
            viewHolder.userName.setVisibility(View.VISIBLE);
            viewHolder.userName.setText("添加");
            viewHolder.itemView.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onAddClick();
                }
            });
        } else if (type == TYPE_DELETE) {
            viewHolder.headImg.setImageResource(R.drawable.icon_im_conversation_member_delete);
            viewHolder.userName.setVisibility(View.VISIBLE);
            viewHolder.userName.setText("移除");
            viewHolder.itemView.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onDeleteClick();
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        return data == null ? 0 : data.size();
    }

    public static class ConversationDetailMemberHolder extends RecyclerView.ViewHolder {

        private ImageView headImg;
        private TextView userName;

        public ConversationDetailMemberHolder(@NonNull View itemView) {
            super(itemView);
            headImg = itemView.findViewById(R.id.iv_conversation_member_head_img);
            userName = itemView.findViewById(R.id.tv_conversation_member_name);
        }
    }

    public interface OnClickListener {
        void onAddClick();

        void onDeleteClick();

        void onMemberClick(BIMMember member);
    }
}
