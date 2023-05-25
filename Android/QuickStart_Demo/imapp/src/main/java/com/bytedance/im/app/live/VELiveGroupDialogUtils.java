package com.bytedance.im.app.live;

import android.app.Dialog;
import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.Pair;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bytedance.im.app.R;

import java.util.List;

public class VELiveGroupDialogUtils {
    public static void showBottomInputDialog(Context context, String title, String confirmBtnText, String inputContentText, BottomInputDialogListener listener) {
        View view = View.inflate(context, R.layout.ve_im_bottom_dialog_input, null);
        Dialog dialog = new Dialog(context);
        ((TextView)view.findViewById(R.id.tv_dialog_bottom_title)).setText(title);
        EditText inputContentEditText = view.findViewById(R.id.et_input_content);
        if (inputContentText != null) {
            inputContentEditText.setText(inputContentText);
        }
        TextView confirmBtn = view.findViewById(R.id.tv_first_btn);
        confirmBtn.setOnClickListener((v1) -> {
            dialog.dismiss();
            listener.onClick(v1, inputContentEditText.getText().toString());
        });
        if (confirmBtnText != null) {
            confirmBtn.setText(confirmBtnText);
        }
        dialog.setContentView(view);
        showBottomDialog(dialog);
    }

    public static void showBottomMultiItemDialog(Context context, List<Pair<String, BottomInputDialogListener>> data) {
        View view = View.inflate(context, R.layout.ve_im_bottom_dialog_multi_item, null);
        Dialog dialog = new Dialog(context);
        LinearLayout llMain = view.findViewById(R.id.ll_main);

        for (Pair<String, BottomInputDialogListener> d: data) {
            View v = View.inflate(context, R.layout.ve_item_dialog_text, null);
            TextView tv = v.findViewById(R.id.tv_main);
            tv.setText(d.first);
            tv.setOnClickListener((clickView) -> {
                dialog.dismiss();
                if (null != d.second) {
                    d.second.onClick(clickView, d.first);
                }
            });

            llMain.addView(v);
        }

        dialog.setContentView(view);
        showBottomDialog(dialog);
    }

    private static void showBottomDialog(Dialog dialog) {
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

    public interface BottomInputDialogListener {
        void onClick(View v, String text);
    }
}
