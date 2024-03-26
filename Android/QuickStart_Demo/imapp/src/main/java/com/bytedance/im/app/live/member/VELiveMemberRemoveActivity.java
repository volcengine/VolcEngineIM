package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class VELiveMemberRemoveActivity extends VELiveMemberSelectListActivity {
    private ProgressDialog waitDialog;

    public static void start(Activity activity, long conversationShorId) {
        Intent intent = new Intent(activity, VELiveMemberRemoveActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShorId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView textView = findViewById(R.id.tv_title);
        textView.setText("移出群成员");
    }

    @Override
    protected List<BIMMember> filter(List<BIMMember> members) {
        if (members != null) {
            Iterator<BIMMember> iterator = members.iterator();
            while (iterator.hasNext()) {
                BIMMember bimMember = iterator.next();
                if (bimMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                    iterator.remove();
                }
            }
        }
        return members;
    }

    @Override
    protected void onConfirmClick(List<MemberWrapper> selectList) {
        super.onConfirmClick(selectList);
        if (selectList == null) {
            return;
        }
        List<Long> uidList = new ArrayList<>();
        for (MemberWrapper wrapper : selectList) {
            uidList.add(wrapper.getMember().getUserID());
        }
        waitDialog = ProgressDialog.show(VELiveMemberRemoveActivity.this, "移出中,稍等...", "");
        BIMClient.getInstance().getService(BIMLiveExpandService.class).kickLiveGroupMemberList(conversationId, uidList, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                Toast.makeText(VELiveMemberRemoveActivity.this,"移出成功",Toast.LENGTH_SHORT).show();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                Toast.makeText(VELiveMemberRemoveActivity.this,"移出失败",Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }
}
