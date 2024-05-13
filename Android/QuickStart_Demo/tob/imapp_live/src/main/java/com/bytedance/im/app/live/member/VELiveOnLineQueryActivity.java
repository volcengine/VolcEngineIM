package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;


import com.bytedance.im.app.live.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 查询在线状态
 */
public class VELiveOnLineQueryActivity extends Activity {
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";
    private static String KEY_UID = "uid";
    private ListView listView;
    private TextView tvQuery;
    private EditText editText;
    private TextView tvAdd;
    private SimpleAdapter adapter;
    private List<Map<String, String>> data = new ArrayList<>();
    private Set<String> checkSet = new HashSet<String>();
    private long conversationShortId;

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VELiveOnLineQueryActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_query_online);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0);
        tvQuery = findViewById(R.id.tv_confirm);
        editText = findViewById(R.id.edit);
        tvAdd = findViewById(R.id.add);
        tvQuery.setOnClickListener(v -> {
            ArrayList<Long> uidList = getUidList();
            if (uidList == null || uidList.isEmpty()) {
                Toast.makeText(this, "请添加 UserID", Toast.LENGTH_SHORT).show();
                return;
            }
            VELiveOnlineQueryResultActivity.start(this, conversationShortId, uidList);
        });
        //比较工具类不再使用 recyclerView 实现
        adapter = createAdapter();
        tvAdd.setOnClickListener(v -> {
            String uidStr = editText.getText().toString();
            if (check(uidStr)) {
                Map<String, String> map = new HashMap<>();
                map.put(KEY_UID, uidStr);
                if (data.size() > 0) {
                    data.add(0, map);
                } else {
                    data.add(map);
                }
                checkSet.add(uidStr);
                adapter.notifyDataSetChanged();
                editText.setText("");
            }
        });
        listView = findViewById(R.id.rv_list);
        listView.setAdapter(adapter);
        tvAdd.setVisibility(View.GONE);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(30)});
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s == null || s.length() == 0) {
                    tvAdd.setVisibility(View.GONE);
                } else {
                    tvAdd.setVisibility(View.VISIBLE);
                }
            }
        });
    }

    private boolean check(String uidStr) {
        try {
            long uid = Long.parseLong(uidStr);
        } catch (Exception e) {
            Toast.makeText(this, "请输入数字", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (data.size() >= 200) {
            Toast.makeText(this, "已添加 200个用户ID", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (checkSet.contains(uidStr)) {
            Toast.makeText(this, "该 UserID 已添加”", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    private ArrayList<Long> getUidList() {
        ArrayList<Long> result = new ArrayList<>();
        for (Map<String, String> map : data) {
            String uid = map.get(KEY_UID);
            result.add(Long.parseLong(uid));
        }
        return result;
    }

    private SimpleAdapter createAdapter(){
       return new SimpleAdapter(this, data, R.layout.ve_im_live_group_item_query_online_before, new String[]{KEY_UID}, new int[]{R.id.tv_uid_name}){
            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                View view = super.getView(position, convertView, parent);
                ImageView btn= view.findViewById(R.id.remove);
                btn.setOnClickListener(v -> {
                    checkSet.remove(data.get(position).get(KEY_UID));
                    data.remove(position);
                    adapter.notifyDataSetChanged();
                });
                return view;
            }
        };
    }
}
