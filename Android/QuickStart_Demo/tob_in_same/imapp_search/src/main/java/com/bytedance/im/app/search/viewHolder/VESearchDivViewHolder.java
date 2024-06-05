package com.bytedance.im.app.search.viewHolder;

import androidx.annotation.NonNull;
import android.view.View;
import android.widget.TextView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.model.VESearchDivWrapper;


public class VESearchDivViewHolder extends VESearchViewHolder<VESearchDivWrapper> {
    private TextView textView;

    public VESearchDivViewHolder(@NonNull View itemView) {
        super(itemView);
        textView = itemView.findViewById(R.id.div_title);
    }

    @Override
    public void bind(VESearchDivWrapper t) {
        super.bind(t);
        textView.setText(t.getInfo());
    }
}
