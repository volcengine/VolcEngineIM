package com.bytedance.im.app.main.edit;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserProfile;

import java.util.ArrayList;
import java.util.List;

public class VEMinePortraitEditActivity extends Activity {
    private RecyclerView recyclerView;
    public static final String RESULT_PORTRAIT_URL = "result_portrait_url";

    public static void startForResult(Activity activity, int requestCode) {
        Intent intent = new Intent(activity, VEMinePortraitEditActivity.class);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_actvity_mine_portrait_edit_layout);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        recyclerView = findViewById(R.id.portrait_list);
        recyclerView.setLayoutManager(new GridLayoutManager(this, 3));
        recyclerView.setAnimation(null);
        recyclerView.setAdapter(new PortraitAdapter(initData(), url -> setUrlResult(url)));
    }

    private List<String> initData() {
        List<String> data = new ArrayList<>();
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar1.png");
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar2.png");
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar3.png");
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar4.png");
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar5.png");
        data.add("https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar6.png");
        return data;
    }

    private void setUrlResult(String url) {
        Intent data = new Intent();
        data.putExtra(RESULT_PORTRAIT_URL, url);
        setResult(RESULT_OK, data);
        finish();
    }
}
