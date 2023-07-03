package com.bytedance.im.app.main;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;

import com.bytedance.im.app.R;
import com.bytedance.im.app.create.VECreateGroupActivity;
import com.bytedance.im.app.user.VEUserAddActivity;
import com.bytedance.im.app.create.VECreateSingleActivity;

public class VEConvFragment extends Fragment {
    private static final String TAG = "VEConvFragment";
    private ImageView createIv;
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.ve_im_fragment_conve, container, false);
        createIv = rootView.findViewById(R.id.iv_create);
        createIv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.i(TAG, "more onClick()");
                showPopUpWindow(v);
            }
        });
        return rootView;
    }

    private void showPopUpWindow(View createBtn) {
        View contentView = LayoutInflater.from(getActivity()).inflate(R.layout.ve_im_popup_window_create_chat, null);
        LinearLayout createSingle = contentView.findViewById(R.id.ll_create_single);
        LinearLayout createGroup = contentView.findViewById(R.id.ll_create_group);
        PopupWindow popupWindow = new PopupWindow(contentView, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setOutsideTouchable(true);
        popupWindow.showAsDropDown(createBtn, 0, 10);
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int id = v.getId();
                if (id == R.id.ll_create_single) {
                    VECreateSingleActivity.start(getActivity());
                } else if (id == R.id.ll_create_group) {
                    VECreateGroupActivity.start(getActivity());
                }
                popupWindow.dismiss();
            }
        };
        createSingle.setOnClickListener(listener);
        createGroup.setOnClickListener(listener);
        //弹窗显示时添加全局阴影
        WindowManager.LayoutParams lp = getActivity().getWindow().getAttributes();
        lp.alpha = 0.7f;
        getActivity().getWindow().setAttributes(lp);

        //弹窗消失时移出全局阴影
        popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                WindowManager.LayoutParams lp = getActivity().getWindow().getAttributes();
                lp.alpha = 1f;
                getActivity().getWindow().setAttributes(lp);
            }
        });
    }
}
