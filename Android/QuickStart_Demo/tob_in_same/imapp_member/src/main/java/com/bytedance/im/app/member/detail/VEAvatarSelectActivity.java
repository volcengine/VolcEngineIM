package com.bytedance.im.app.member.detail;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.member.R;

import java.util.ArrayList;
import java.util.List;

public class VEAvatarSelectActivity extends Activity {
    private RecyclerView recyclerView;
    public static final String RESULT_PORTRAIT_URL = "result_portrait_url";

    public static void startForResult(Activity activity, int requestCode) {
        Intent intent = new Intent(activity, VEAvatarSelectActivity.class);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_avatar_select_layout);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        recyclerView = findViewById(R.id.portrait_list);
        recyclerView.setLayoutManager(new GridLayoutManager(this, 3));
        recyclerView.setAnimation(null);
        recyclerView.setAdapter(new GroupAvatarAdapter(initData(), url -> setUrlResult(url)));
    }

    private List<String> initData() {
        List<String> data = new ArrayList<>();
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/fkeh7nuptbo/im_group_icon_1.png");
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/fkeh7nuptbo/im_group_icon_2.png");
        return data;
    }

    private void setUrlResult(String url) {
        Intent data = new Intent();
        data.putExtra(RESULT_PORTRAIT_URL, url);
        setResult(RESULT_OK, data);
        finish();
    }
}

class GroupAvatarAdapter extends RecyclerView.Adapter<AvatarViewHolder> {
    private List<String> data = new ArrayList<>();
    private OnItemClickListener listener;

    interface OnItemClickListener {
        void onItemClick(String url);
    }

    public GroupAvatarAdapter(List<String> data, OnItemClickListener listener) {
        this.data = data;
        this.listener = listener;
    }

    @NonNull
    @Override
    public AvatarViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_im_item_avatar, viewGroup, false);
        return new AvatarViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull AvatarViewHolder avatarViewHolder, int i) {
        ImageView ivPortrait = avatarViewHolder.itemView.findViewById(R.id.iv_portrait);
        Glide.with(ivPortrait.getContext())
                .load(data.get(i))
                .dontAnimate()
                .placeholder(R.drawable.default_icon_group)
                .into(ivPortrait);
        avatarViewHolder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onItemClick(data.get(i));
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }
}

class AvatarViewHolder extends RecyclerView.ViewHolder {

    public AvatarViewHolder(@NonNull View itemView) {
        super(itemView);
    }
}
