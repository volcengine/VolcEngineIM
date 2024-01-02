package com.bytedance.im.ui.message.adapter.ui.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.RelativeLayout;


import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiInfo;
import com.bytedance.im.ui.emoji.EmojiManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmojiGroupView extends RelativeLayout implements AbsListView.OnItemClickListener {

    private static final String TAG = EmojiGroupView.class.getSimpleName() + " ";
    private static final int COLUMNS = 7;
    private static final int LINES = 3;
    private static final int PAGE_COUNT = COLUMNS * LINES;//每页表情个数
    public static final int DELETE_CODE = -10000;
    public static final int EMPTY_CODE = -10001;
    public static final int ATTRIBUTE_VALUE_DELETE = 0;
    public static final int ATTRIBUTE_VALUE_CLOSE = 1;

    private ViewPager mViewPager;
    private ViewPagerAdapter mPagerAdapter;
    private EmojiClickListener mEmojiClickListener;
    private int mExtraIcon;
    private boolean needFillSpace = true;

    private Map<Integer, List<EmojiInfo>> mEmotionGroups = new HashMap<>();

    public EmojiGroupView(Context context) {
        super(context);
        initView();
    }

    public EmojiGroupView(Context context, AttributeSet attrs) {
        super(context, attrs);
        TypedArray typedArray = context.obtainStyledAttributes(attrs,R.styleable.EmojiGroupView);
        if (typedArray != null){
            int attributeValue =  typedArray.getInt(R.styleable.EmojiGroupView_extraIcon,0);
            if (attributeValue == ATTRIBUTE_VALUE_DELETE){
                mExtraIcon = R.drawable.icon_msg_emoji_delete;
            } else if (attributeValue == ATTRIBUTE_VALUE_CLOSE) {
                mExtraIcon = R.drawable.icon_msg_option_menu_close_emoji;
            }
        }
        initView();
    }

    public void setEmojiClickListener(EmojiClickListener listener) {
        mEmojiClickListener = listener;
    }

    public void reset() {
        if (mViewPager != null) {
            mViewPager.setCurrentItem(0);
        }
    }

    private void initView() {
        View.inflate(getContext(), R.layout.bim_layout_emoji_panel, this);
        mViewPager = findViewById(R.id.view_pager_emoji);
        mPagerAdapter = new ViewPagerAdapter();
        mViewPager.setAdapter(mPagerAdapter);
        initEmojiData();
        initEmotionPager();
    }

    private void initEmojiData() {
        List<EmojiInfo> emojiInfos = new ArrayList<>(EmojiManager.getInstance().getEmojis(getContext()));
        if (emojiInfos == null) {
            return;
        }
        insertOptionIcon(emojiInfos);
        int total = emojiInfos.size();
        for (int i = 0; i < total; i++) {
            int page = i / PAGE_COUNT;
            List<EmojiInfo> pageData = mEmotionGroups.get(page);
            if (pageData == null) {
                pageData = new ArrayList<>();
                mEmotionGroups.put(page, pageData);
            }
            pageData.add(emojiInfos.get(i));
        }
    }

    private void insertOptionIcon(List<EmojiInfo> emojiInfos){
        int lastIndex = emojiInfos.size() % (PAGE_COUNT - 1);

        for (int index = PAGE_COUNT-1; index < emojiInfos.size(); index += PAGE_COUNT){
            EmojiInfo info = new EmojiInfo();
            info.code = DELETE_CODE;
            info.resId = mExtraIcon;
            info.text = "[删除]";
            emojiInfos.add(index,info);
        }

        if (lastIndex != 0){
            if (needFillSpace) {
                fillEmojiSpace(lastIndex, emojiInfos);
            }
            EmojiInfo info = new EmojiInfo();
            info.code = DELETE_CODE;
            info.resId = mExtraIcon;
            info.text = "[删除]";
            emojiInfos.add(emojiInfos.size(), info);
        }
    }

    private void fillEmojiSpace(int lastIndex, List<EmojiInfo> emojiInfos) {
        for (int i = lastIndex; i < PAGE_COUNT - 1; i++) {
            EmojiInfo info = new EmojiInfo();
            info.code = EMPTY_CODE;
            info.resId = 0;
            info.text = "";
            emojiInfos.add(emojiInfos.size(), info);
        }
    }

    private void initEmotionPager() {
        int pages = mEmotionGroups.size();
        Context context = getContext();
        if (pages == 0 || context == null) {
            return;
        }
        List<View> viewList = new ArrayList<>();
        LayoutInflater inflater = LayoutInflater.from(context);
        for (int i = 0; i < pages; i++) {
            GridView gridView = (GridView) inflater.inflate(R.layout.bim_grid_view_emoji_page, null);
            gridView.setNumColumns(COLUMNS);
            gridView.setOnItemClickListener(this);
            EmojiGridAdapter adapter = new EmojiGridAdapter(context);
            gridView.setAdapter(adapter);
            adapter.setDataList(mEmotionGroups.get(i));
            gridView.setTag(i);
            viewList.add(gridView);
        }
        mPagerAdapter.setViewList(viewList);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        if (mEmojiClickListener == null) {
            return;
        }
        int page = (int) adapterView.getTag();
        List<EmojiInfo> emojiInfos = mEmotionGroups.get(page);
        if (emojiInfos == null || emojiInfos.isEmpty()) {
            return;
        }
        EmojiInfo emojiInfo = null;
        if (i >= 0 && i < emojiInfos.size()) {
            emojiInfo = emojiInfos.get(i);
        }
        mEmojiClickListener.OnEmojiClick(emojiInfo);
    }

    public interface EmojiClickListener {
        void OnEmojiClick(EmojiInfo info);
    }
}
