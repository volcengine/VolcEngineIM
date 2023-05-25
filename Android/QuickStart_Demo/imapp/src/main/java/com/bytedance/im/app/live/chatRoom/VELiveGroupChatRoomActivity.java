package com.bytedance.im.app.live.chatRoom;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import com.bytedance.im.app.R;
import com.bytedance.im.app.live.detail.VELiveDetailActivity;

public class VELiveGroupChatRoomActivity extends Activity {
    private static String TAG = "VELiveGroupChatRoomActivity";
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";

    private Fragment msgFragment;
    private String TAG_MSG = "tag_msg";
    private long conversationShortId = -1;


    public static void startChat(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VELiveGroupChatRoomActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_msg_list);
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1L);
    }

    @Override
    protected void onStart() {
        super.onStart();
        FragmentTransaction transaction = getFragmentManager().beginTransaction();
        if (msgFragment == null) {
            msgFragment = new VELiveGroupMessageListFragment();
            transaction.add(R.id.page_container, msgFragment, TAG_MSG);
            transaction.show(msgFragment);
        }
        transaction.commit();
    }
}
