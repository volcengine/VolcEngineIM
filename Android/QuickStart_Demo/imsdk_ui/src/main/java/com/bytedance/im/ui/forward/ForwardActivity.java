package com.bytedance.im.ui.forward;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.conversation.BIMConversationListFragment;
import com.bytedance.im.core.api.model.BIMConversation;

public class ForwardActivity extends Activity {
    public static final String FORWARD_CONVERSATION_ID = "forward_conversation_id";

    public static void startForResult(Fragment fragment, int requestCode) {
        Intent intent = new Intent(fragment.getActivity(), ForwardActivity.class);
        fragment.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bim_im_forward_activity_layout);
        BIMConversationListFragment fragment = (BIMConversationListFragment) getFragmentManager().findFragmentByTag("conversation_tag");
        fragment.setOnItemClickListener(new BIMConversationListFragment.OnConversationClickListener() {
            @Override
            public void onConversationClick(BIMConversation conversation) {
                Intent data = new Intent();
                data.putExtra(FORWARD_CONVERSATION_ID,conversation.getConversationID());
                setResult(RESULT_OK,data);
                finish();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
    }
}
