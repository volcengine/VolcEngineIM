package com.bytedance.im.app.custom.operations;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMGetMessageOption;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageListResult;
import com.bytedance.im.core.model.inner.msg.BIMTextElement;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class VEUnreadMessageDetailActivity extends Activity implements View.OnClickListener {
    public static String CID = "CID";
    public static String MSG_ID = "MSG_ID";

    private MessageAdapter adapter = new MessageAdapter();
    private BIMMessageListResult msgResult = null;
    private TextView tvQuery, tvClearUnread;
    private EditText etMsgId, etConvId;
    private RecyclerView msgContainer;

    private int pageSize = 5;
    private boolean isQuery = false;
    private String conversationId = "";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_unread_msg_list);

        tvQuery = findViewById(R.id.tv_query);
        etMsgId = findViewById(R.id.et_msg_container);
        etConvId = findViewById(R.id.et_conv_container);
        tvClearUnread = findViewById(R.id.tv_clear_unread);
        msgContainer = findViewById(R.id.rv_msg_container);

        tvQuery.setOnClickListener(this);
        tvClearUnread.setOnClickListener(this);
        findViewById(R.id.iv_back).setOnClickListener(v -> { finish(); });

        msgContainer.setLayoutManager(new LinearLayoutManager(this, RecyclerView.VERTICAL, false));
        msgContainer.setAdapter(adapter);

        Intent intent = getIntent();
        if (intent != null) {
            if (!TextUtils.isEmpty(intent.getStringExtra(MSG_ID))) {
                etMsgId.setText(intent.getStringExtra(MSG_ID));
            }
            if (!TextUtils.isEmpty(intent.getStringExtra(CID))) {
                etConvId.setText(intent.getStringExtra(CID));
            }
        }

        msgContainer.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                        >= recyclerView.computeVerticalScrollRange()) {
                    loadData();
                }
            }
        });
        adapter.setOnclickListener(new MessageAdapter.ClickListener() {
            @Override
            public void onClick(BIMMessage message) {
                etMsgId.setText("" + message.getServerMsgId());
            }
        });
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.tv_query) {
            query();
        } else if (v.getId() == R.id.tv_clear_unread) {
            clearUnread();
        }
    }

    private void clearUnread() {
        String msgId = etMsgId.getText().toString();
        try {
            long messageId = Long.parseLong(msgId);
            BIMClient.getInstance().getMessageByServerID(messageId, 0, false, new BIMResultCallback<BIMMessage>() {
                @Override
                public void onSuccess(BIMMessage bimMessage) {
                    BIMClient.getInstance().markConversationRead(conversationId, bimMessage, new BIMSimpleCallback() {
                        @Override
                        public void onSuccess() {
                            Toast.makeText(VEUnreadMessageDetailActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                        }
                    });
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VEUnreadMessageDetailActivity.this, "无效消息，请检查输入参数：" + code, Toast.LENGTH_SHORT).show();
                    BIMClient.getInstance().markConversationRead(conversationId, null, new BIMSimpleCallback() {
                        @Override
                        public void onSuccess() {
                            Toast.makeText(VEUnreadMessageDetailActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            });
        } catch (Exception e) {
            Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：msgId 转换错误", Toast.LENGTH_SHORT).show();
        }
    }

    private void query() {
        if (!isQuery) {
            isQuery = true;
            adapter.reset();
            String msgId = etMsgId.getText().toString();
            conversationId = etConvId.getText().toString();
            try {
                long msgServerId = 0;
                if (!TextUtils.isEmpty(msgId)) {
                    msgServerId = Long.parseLong(msgId);
                }
                BIMClient.getInstance().getMessageByServerID(msgServerId, 0, false, new BIMResultCallback<BIMMessage>() {
                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        BIMGetMessageOption option = new BIMGetMessageOption.Builder().isNeedServer(true).limit(pageSize).anchorMessage(bimMessage).build();
                        BIMClient.getInstance().getConversationUnReadMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
                            @Override
                            public void onSuccess(BIMMessageListResult bimMessageListResult) {
                                adapter.add(bimMessageListResult.getMessageList());
                                msgResult = bimMessageListResult;
                                isQuery = false;
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                                isQuery = false;
                            }
                        });
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        if (msgId.length() != 0) {
                            Toast.makeText(VEUnreadMessageDetailActivity.this, "无效消息，请检查输入参数：" + code, Toast.LENGTH_SHORT).show();
                        }
                        BIMGetMessageOption option = new BIMGetMessageOption.Builder().isNeedServer(true).limit(pageSize).anchorMessage(null).build();
                        BIMClient.getInstance().getConversationUnReadMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
                            @Override
                            public void onSuccess(BIMMessageListResult bimMessageListResult) {
                                adapter.add(bimMessageListResult.getMessageList());
                                msgResult = bimMessageListResult;
                                isQuery = false;
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                                isQuery = false;
                            }
                        });
                    }
                });
            } catch (Exception e) {
                Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：msg ID 转换失败", Toast.LENGTH_SHORT).show();
                isQuery = false;
            }
        }
    }

    private void loadData() {
        if (!isQuery && msgResult != null && msgResult.isHasMore()) {
            BIMMessage msg = adapter.getOldestMessage();
            BIMGetMessageOption option = new BIMGetMessageOption.Builder().isNeedServer(true).limit(pageSize).anchorMessage(msg).build();
            BIMClient.getInstance().getConversationUnReadMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
                @Override
                public void onSuccess(BIMMessageListResult bimMessageListResult) {
                    adapter.add(bimMessageListResult.getMessageList());
                    msgResult = bimMessageListResult;
                    isQuery = false;
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VEUnreadMessageDetailActivity.this, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                    isQuery = false;
                }
            });
        }
    }
}

class MessageAdapter extends RecyclerView.Adapter<MessageViewHolder> {
    private ArrayList<BIMMessage> data = new ArrayList<>();
    private Set<String> uuids = new HashSet<>();
    private ClickListener clickListener;

    public interface ClickListener {
        void onClick(BIMMessage message);
    }

    public void setOnclickListener(ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public BIMMessage getOldestMessage() {
        if (data.size() > 0) {
            return data.get(data.size() -1);
        }
        return null;
    }

    public void add(List<BIMMessage> messageList) {
        if (messageList != null) {
            for (BIMMessage msg : messageList) {
//                if (msg != null && !uuids.contains(msg.getUuid())) {
//                    uuids.add(msg.getUUId());
//                    data.add(msg);
//                }
                data.add(msg);
            }
        }
        Collections.sort(data, (o1, o2) -> o1.getOrderIndex() - o2.getOrderIndex() > 0 ? 1: 0);
        notifyDataSetChanged();
    }

    public void reset() {
        data.clear();
        uuids.clear();
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public MessageViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        TextView v = new TextView(parent.getContext());
        return new MessageViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull MessageViewHolder holder, int position) {
        holder.bind(data.get(position), clickListener);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }
}

class MessageViewHolder extends RecyclerView.ViewHolder {

    public MessageViewHolder(@NonNull View itemView) {
        super(itemView);
    }

    public void bind(BIMMessage bimMessage, MessageAdapter.ClickListener clickListener) {
        itemView.setOnClickListener(v -> {
            if (clickListener != null) {
                clickListener.onClick(bimMessage);
            }
        });
        if (itemView instanceof TextView) {
            String contentText = "";
            ((TextView) itemView).setSingleLine(true);
            if (bimMessage != null) {
                if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
                    contentText = ((BIMTextElement) bimMessage.getElement()).getText();
                } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_FILE) {
                    contentText = "[文件]";
                } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE) {
                    contentText = "[图片]";
                } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO) {
                    contentText = "[视频]";
                } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_AUDIO) {
                    contentText = "[语音]";
                } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
                    contentText = "[自定义消息]";
                } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_UNKNOWN) {
                    contentText = "[未知]";
                } else {
                    contentText = "[错误]";
                }
            }
            ((TextView) itemView).setText("未读消息, text: " + contentText + ", order: " + bimMessage.getOrderIndex());
        }
    }
}
