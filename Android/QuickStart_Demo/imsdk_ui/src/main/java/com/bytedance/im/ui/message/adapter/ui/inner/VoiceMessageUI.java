package com.bytedance.im.ui.message.adapter.ui.inner;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.core.api.interfaces.BIMDownloadCallback;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.download.api.BIMDownloadExpandService;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.widget.custom.CircleProgressView;
import com.bytedance.im.ui.utils.media.AudioHelper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.utils.BIMUtils;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMAudioElement;

import java.io.File;
import java.util.Collections;


@CustomUIType(contentCls = BIMAudioElement.class)
public class VoiceMessageUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_voice;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View itemView, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView asrTextTv = itemView.findViewById(R.id.tv_msg_asr_text_content);

        BIMMessage bimMessage = messageWrapper.getBimMessage();
        BIMAudioElement audioElement = (BIMAudioElement) messageWrapper.getBimMessage().getElement();
        View sendContent = itemView.findViewById(R.id.ll_voice_content_send);
        View receiveContent = itemView.findViewById(R.id.ll_voice_content_receive);

        CircleProgressView circleProgressView = itemView.findViewById(R.id.pv_circle_view);
        circleProgressView.setVisibility(View.GONE);
        if (bimMessage.isSelf()) {
            sendContent.setVisibility(View.VISIBLE);
            receiveContent.setVisibility(View.GONE);
            TextView voiceDuration = itemView.findViewById(R.id.tv_voice_duration_send);
            ImageView voiceIcon = itemView.findViewById(R.id.voice_icon_send);
            voiceIcon.setImageResource(R.drawable.icon_im_voice_send);
            sendContent.setBackgroundResource(R.drawable.shape_im_conversation_msg_send_bg);
            voiceDuration.setTextColor(itemView.getContext().getResources().getColor(R.color.business_base_white));
            updateDuration(voiceDuration, audioElement);
            if (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_PENDING
                    || (audioElement.getProgress() >= 0 && bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SENDING_FILE_PARTS)) {
                circleProgressView.setVisibility(View.VISIBLE);
                circleProgressView.setProgress(audioElement.getProgress());
                circleProgressView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        BIMClient.getInstance().cancelMediaFileMessageUpload(bimMessage, null);
                    }
                });
            }
        } else {
            sendContent.setVisibility(View.GONE);
            receiveContent.setVisibility(View.VISIBLE);
            ImageView voiceIcon = itemView.findViewById(R.id.voice_icon_receive);
            voiceIcon.setImageResource(R.drawable.icon_im_voice_recevie);
            TextView reDuration = itemView.findViewById(R.id.tv_voice_duration_receive);
            receiveContent.setBackgroundResource(R.drawable.shape_im_conversation_msg_receive_bg);
            reDuration.setTextColor(itemView.getContext().getResources().getColor(R.color.business_im_222));
            updateDuration(reDuration, audioElement);
        }
        if (audioElement == null) {
            return;
        }
        // 语音识别的文字，暂不支持
        asrTextTv.setVisibility(View.GONE);
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        BIMAudioElement audioElement = (BIMAudioElement) messageWrapper.getBimMessage().getElement();
        BIMClient.getInstance().sendMessageReadReceipts(Collections.singletonList(messageWrapper.getBimMessage()), new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                BIMLog.i("VoiceMessageUI", "sendMessageReadReceipts success");
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.e("VoiceMessageUI", "sendMessageReadReceipts failed: " + code);
            }
        });

        BIMMessage bimMessage = messageWrapper.getBimMessage();
        if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT) {
            if (audioElement != null) {
                if (audioElement.isExpired()) {
                    holder.getOnOutListener().refreshMediaMessage(messageWrapper.getBimMessage(), new BIMResultCallback<BIMMessage>() {
                        @Override
                        public void onSuccess(BIMMessage bimMessage) {
                            AudioHelper.getInstance().play(audioElement.getURL());
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {

                        }

                    });
                } else {
                    String url = audioElement.getLocalPath();
                    if (TextUtils.isEmpty(url)) {
                        url = audioElement.getURL();
                    }
                    AudioHelper.getInstance().play(url);
                }
            }
        } else {
            if (audioElement != null) {
                String localPath = audioElement.getDownloadPath();
                boolean localFileExist = new File(localPath).exists();
                if (!localFileExist) {
                    BIMClient.getInstance().downloadFile(bimMessage, audioElement.getURL(), new BIMDownloadCallback() {
                        @Override
                        public void onSuccess(BIMMessage bimMessage) {
                            Toast.makeText(v.getContext(), "下载成功", Toast.LENGTH_SHORT).show();
                            AudioHelper.getInstance().play(audioElement.getDownloadPath());
                        }

                        @Override
                        public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                            if (code == BIMErrorCode.BIM_DOWNLOAD_FILE_DUPLICATE) {
                                Toast.makeText(v.getContext(), "下载中", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(v.getContext(), "下载失败，请重试", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                } else {
                    AudioHelper.getInstance().play(audioElement.getDownloadPath());
                }
            }
        }
    }

    private void updateDuration(TextView textView, BIMAudioElement audioElement) {
        try {
            int duration = audioElement.getDuration();
            textView.setText(duration + "\"");
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) textView.getLayoutParams();
            params.width = getAudioDisplayWidth(textView.getContext(), duration);
            textView.setLayoutParams(params);
        } catch (Exception e) {

        }
    }

    public static int getAudioDisplayWidth(Context context, int duration) {
        if (context == null) {
            return 0;
        }
        int widthDp, minDp = 20, maxDp = 180, minDuration = 2, maxDuration = 60;
        if (duration <= minDuration) {
            widthDp = minDp;
        } else if (duration >= maxDuration) {
            widthDp = maxDp;
        } else {
            widthDp = minDp + (duration - minDuration) * 5;
            if (widthDp > maxDp) {
                widthDp = maxDp;
            }
        }
        return BIMUtils.dip2px(context, widthDp);
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return bimMessage.isSelf() && bimMessage.getServerMsgId() > 0;
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return bimMessage.getServerMsgId() > 0;
    }
}
