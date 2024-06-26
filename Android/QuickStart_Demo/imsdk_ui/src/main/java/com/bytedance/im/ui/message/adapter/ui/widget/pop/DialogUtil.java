package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.ui.R;


public class DialogUtil {

    public static void showFileInfoDialog(Context context, String fileType, String fileSize) {
        try {
            AlertDialog.Builder builder = new AlertDialog.Builder(context);
            builder.setCancelable(false);
            AlertDialog dialog = builder.create();
            dialog.show();

            if (null != dialog.getWindow()) {
                Window window = dialog.getWindow();

                window.setGravity(Gravity.CENTER);
                window.setContentView(R.layout.bim_im_file_info_dialog);
                window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

                TextView tvType = window.findViewById(R.id.tv_type);
                TextView tvSize = window.findViewById(R.id.tv_size);
                TextView tvAgree = window.findViewById(R.id.tv_agree);

                tvType.setText("文件格式: " + fileType);
                tvSize.setText("文件大小: " + fileSize);
                tvAgree.setOnClickListener(v -> {
                    dialog.dismiss();
                });
            }
        } catch (Exception e) {
            // ignore
        }
    }

    public static void showBottomConfirmDialog(Context context, String title, String firstBtnText, ConfirmDialogClickListener listener) {
        View view = View.inflate(context, R.layout.bim_bottom_dialog_confirm, null);
        Dialog dialog = new Dialog(context);
        ((TextView) view.findViewById(R.id.tv_dialog_bottom_title)).setText(title);
        TextView firstBtn = view.findViewById(R.id.tv_first_btn);
        firstBtn.setText(firstBtnText);
        firstBtn.setOnClickListener(v -> {
            listener.onConfirmClick(v);
            dialog.dismiss();
        });
        view.findViewById(R.id.tv_second_btn).setOnClickListener(v -> {
            listener.onCancelClick(v);
            dialog.dismiss();
        });
        dialog.setContentView(view);
        showBottomDialog(dialog);
    }

    public static void showBottomChooseDialog(Context context, String firstText, String secondText, ChooseDialogClickListener listener) {
        showBottomChooseDialog(context, firstText, 0, secondText, 0, listener);
    }

    public static void showBottomChooseDialog(Context context,
                                              String firstText, int firstIcon,
                                              String secondText, int secondIcon,
                                              ChooseDialogClickListener listener) {
        if (context == null) {
            return;
        }
        Dialog dialog = new Dialog(context);
        View view = View.inflate(context, R.layout.bim_bottom_dialog_choose, null);
        view.findViewById(R.id.ll_first_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onChooseClick(v, 0);
                }
                dialog.dismiss();
            }
        });
        ((TextView) view.findViewById(R.id.tv_first)).setText(firstText);
        ImageView firstIv = view.findViewById(R.id.iv_first);
        if (firstIcon <= 0) {
            firstIv.setVisibility(View.GONE);
        } else {
            firstIv.setVisibility(View.VISIBLE);
            firstIv.setImageResource(firstIcon);
        }

        view.findViewById(R.id.ll_second_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onChooseClick(v, 1);
                }
                dialog.dismiss();
            }
        });
        ((TextView) view.findViewById(R.id.tv_second)).setText(secondText);
        ImageView secondIv = view.findViewById(R.id.iv_second);
        if (secondIcon <= 0) {
            secondIv.setVisibility(View.GONE);
        } else {
            secondIv.setVisibility(View.VISIBLE);
            secondIv.setImageResource(secondIcon);
        }

        view.findViewById(R.id.tv_cancel_btn).setOnClickListener(v -> {
            if (listener != null) {
                listener.onCancelClick(v);
            }
            dialog.dismiss();
        });
        dialog.setContentView(view);
        showBottomDialog(dialog);
    }

    public static void showBottomDialog(Dialog dialog) {
        if (dialog == null || dialog.getWindow() == null || dialog.isShowing()) {
            return;
        }
        WindowManager.LayoutParams lp = dialog.getWindow().getAttributes();
        lp.gravity = Gravity.BOTTOM;
        lp.width = WindowManager.LayoutParams.MATCH_PARENT;
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
        dialog.getWindow().setAttributes(lp);
        dialog.getWindow().setBackgroundDrawable(null);
        dialog.show();
    }

    public interface ConfirmDialogClickListener {
        void onConfirmClick(View view);

        default void onCancelClick(View view) {
        }
    }

    public interface ChooseDialogClickListener {
        void onChooseClick(View view, int pos);

        default void onCancelClick(View view) {
        }
    }
}
