package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.live.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberOnlineInfo;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class VELiveOnlineQueryResultActivity extends Activity {
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";
    private static String UID_LIST = "uid_list";
    private static String KEY_UID = "uid";
    private static String KEY_JOIN_TIME = "join_time";
    private static String KEY_IS_IN_GROUP = "is_in_group";
    private static String KEY_LAST_PING_TIME = "last_ping_time";
    private ListView listView;
    private SimpleAdapter adapter;
    private List<Map<String, String>> data = new ArrayList<>();

    public static void start(Activity activity, long conversationShorId, ArrayList<Long> uidList) {
        Intent intent = new Intent(activity, VELiveOnlineQueryResultActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShorId);
        intent.putExtra(UID_LIST, uidList);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_query_online_result);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        long conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0);
        ArrayList<Long> uidList = (ArrayList<Long>) getIntent().getSerializableExtra(UID_LIST);
        adapter = getAdapter();
        listView = findViewById(R.id.rv_list);
        listView.setAdapter(adapter);
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberOnlineInfo(conversationShortId, uidList, new BIMResultCallback<List<BIMLiveMemberOnlineInfo>>() {
            @Override
            public void onSuccess(List<BIMLiveMemberOnlineInfo> list) {
                refreshData(list);
                Toast.makeText(VELiveOnlineQueryResultActivity.this, "查询成功！ ", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VELiveOnlineQueryResultActivity.this, "查询失败！: " + code, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void refreshData(List<BIMLiveMemberOnlineInfo> list) {
        for (BIMLiveMemberOnlineInfo info : list) {
            Map<String, String> map = new HashMap<>();
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
            String inStr = "";
            if (info.isInGroup()) {
                inStr = "在群";
            } else {
                inStr = "不在群";
            }
            map.put(KEY_UID, "" + info.getUserID());
            map.put(KEY_IS_IN_GROUP, inStr);
            map.put(KEY_JOIN_TIME, format.format(info.getJoinTime()) + " 进群");
            map.put(KEY_LAST_PING_TIME, format.format(info.getLastPingTime()) + " 退群");
            data.add(map);
        }
        adapter.notifyDataSetChanged();
    }

    private SimpleAdapter getAdapter() {
        return new SimpleAdapter(this, data, R.layout.ve_im_live_group_item_query_online_after,
                new String[]{KEY_UID, KEY_IS_IN_GROUP, KEY_LAST_PING_TIME, KEY_JOIN_TIME},
                new int[]{R.id.tv_uid_name, R.id.tv_in_group, R.id.tv_last_ping, R.id.tv_join_time}) {
            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                View view = super.getView(position, convertView, parent);
                TextView inGroup = view.findViewById(R.id.tv_in_group);
                TextView joinTime = view.findViewById(R.id.tv_join_time);
                if (data.get(position).get(KEY_IS_IN_GROUP).equals("不在群")) {
                    inGroup.setTextColor(Color.GRAY);
                    joinTime.setVisibility(View.GONE);
                } else {
                    inGroup.setTextColor(Color.BLACK);
                    joinTime.setVisibility(View.VISIBLE);
                }
                return view;
            }
        };
    }
}
