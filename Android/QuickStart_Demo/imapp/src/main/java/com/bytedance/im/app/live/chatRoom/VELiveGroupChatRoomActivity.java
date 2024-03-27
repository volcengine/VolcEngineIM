package com.bytedance.im.app.live.chatRoom;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;

import com.bytedance.im.app.R;

public class VELiveGroupChatRoomActivity extends Activity {
    private static final String TAG = "VELiveGroupChatRoomActivity";


    private Fragment msgFragment;
    private String TAG_MSG = "tag_msg";

    public static void startChat(Activity activity, long conversationShortId, String alias, String avatarUrl) {
        startChat(activity, conversationShortId, alias, avatarUrl, VELiveGroupMessageListFragment.TYPE_UPDATE_MY_MEMBER_INFO);
    }

    public static void startChat(Activity activity, long conversationShortId) {
        startChat(activity, conversationShortId, null, null, VELiveGroupMessageListFragment.TYPE_SKIP_UPDATE_MY_MEMBER_INFO);
    }
    public static void startChat(Activity activity, long conversationShortId, String alias, String avatarUrl, int startType) {
        Intent intent = new Intent(activity, VELiveGroupChatRoomActivity.class);
        intent.putExtra(VELiveGroupMessageListFragment.CONVERSATION_SHORT_ID, conversationShortId);
        intent.putExtra(VELiveGroupMessageListFragment.ALIAS, alias);
        intent.putExtra(VELiveGroupMessageListFragment.AVATAR_URL, avatarUrl);
        intent.putExtra(VELiveGroupMessageListFragment.START_TYPE, startType);
        activity.startActivity(intent);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_msg_list);
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
