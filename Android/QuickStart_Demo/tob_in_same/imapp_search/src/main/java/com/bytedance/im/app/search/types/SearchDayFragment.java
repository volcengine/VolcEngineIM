package com.bytedance.im.app.search.types;

import static com.prolificinteractive.materialcalendarview.MaterialCalendarView.SELECTION_MODE_NONE;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.util.Pair;
import android.view.View;
import android.app.Fragment;
import android.view.ViewGroup;
import android.view.LayoutInflater;

import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;

import com.bytedance.im.app.search.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMGetMessageOption;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageListResult;
import com.bytedance.im.ui.BIMUIClient;
import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.DayViewDecorator;
import com.prolificinteractive.materialcalendarview.DayViewFacade;
import com.prolificinteractive.materialcalendarview.MaterialCalendarView;
import com.prolificinteractive.materialcalendarview.format.ArrayWeekDayFormatter;
import com.prolificinteractive.materialcalendarview.format.TitleFormatter;
import com.prolificinteractive.materialcalendarview.format.WeekDayFormatter;
import com.prolificinteractive.materialcalendarview.spans.DotSpan;

import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;

public class SearchDayFragment extends Fragment {
    private static final String TAG = "SearchDayFragment";

    private String conversationId;
    private MaterialCalendarView calendarView;
    private ConcurrentHashMap<String, BIMMessage> data = new ConcurrentHashMap<>();

    public static SearchDayFragment create(String conversationID){
        SearchDayFragment searchDayFragment = new SearchDayFragment();
        Bundle bundle = new Bundle();
        bundle.putString("search_cid", conversationID);
        searchDayFragment.setArguments(bundle);
        return searchDayFragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_fragment_search_day, container, false);
        this.conversationId = getArguments().getString("search_cid");
        calendarView = view.findViewById(R.id.calendar_view);

        calendarView.setClickable(false);
        calendarView.setAllowClickDaysOutsideCurrentMonth(false);
        calendarView.setOnDateChangedListener((widget, date, selected) -> {
            BIMMessage message = data.get(generateDayText(date));
            if (message == null) {
                return;
            }
            BIMUIClient.getInstance().getModuleStarter().startMessageModule(getActivity(), message.getUuid(), conversationId);
        });

        Drawable defaultSelector = getDefaultSelector(getActivity());
        calendarView.addDecorators(new DayViewDecorator() {
            @Override
            public boolean shouldDecorate(CalendarDay day) {
                String dayText = generateDayText(day);
                return data.get(dayText) == null;
            }

            @Override
            public void decorate(DayViewFacade view) {
                view.addSpan(new ForegroundColorSpan(Color.GRAY));
                view.setSelectionDrawable(defaultSelector);
            }
        });

        calendarView.addDecorators(new DayViewDecorator() {
            @Override
            public boolean shouldDecorate(CalendarDay day) {
                String dayText = generateDayText(day);
                return data.get(dayText) != null;
            }

            @Override
            public void decorate(DayViewFacade view) {
                view.addSpan(new StyleSpan(android.graphics.Typeface.BOLD));
            }
        });
        calendarView.setTitleFormatter(day -> {
            String month = day.getMonth() < 10 ? "0" + day.getMonth() : day.getMonth() + "";
            return day.getYear() + " 年 " + month + " 月 ";
        });
        calendarView.setWeekDayFormatter(new ArrayWeekDayFormatter(new CharSequence[]{"日", "一", "二", "三", "四", "五", "六"}));

        calendarView.setOnMonthChangedListener((widget, date) -> {
            data.clear();
            loadData(date);
        });
        CalendarDay nowDate = calendarView.getCurrentDate();
        loadData(nowDate);

        return view;
    }

    private String generateDayText(CalendarDay day) {
        return day.getYear() + "-" + (day.getMonth() < 10 ? "0" + day.getMonth() : day.getMonth()) + "-" + (day.getDay() < 10? "0" + day.getDay() : day.getDay());
    }

    private Pair<Long, Long> getCurrentMonthTimeRange(int year, int month) {
        Date firstDay = new Date(year - 1900, month - 1, 1);
        long startTime = firstDay.getTime();

        Calendar calender = Calendar.getInstance();
        calender.setTime(firstDay);
        calender.add(Calendar.MONTH, 1);
        Date endDay = calender.getTime();
        long endTime = endDay.getTime() - 1;

        return new Pair<>(startTime, endTime);
    }

    private void loadData(CalendarDay day) {
        Pair<Long, Long> timeRange = getCurrentMonthTimeRange(day.getYear(), day.getMonth());
        loadData(timeRange.first, timeRange.second);
    }

    private void loadData(long startTime, long endTime) {

        BIMGetMessageOption option = new BIMGetMessageOption.Builder()
                .startTime(startTime)
                .endTime(endTime)
                .limit(100)
                .build();
        BIMClient.getInstance().getHistoryMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
            @Override
            public void onSuccess(BIMMessageListResult result) {
                if (result == null || result.getMessageList() == null || result.getMessageList().isEmpty()) {
                    return;
                }
                for (BIMMessage message: result.getMessageList()) {
                    if (message == null) continue;
                    String time = DateFormat.format("yyyy-MM-dd", message.getCreatedTime()).toString();
                    data.put(time, message);
                }

                if (result.isHasMore()) {
                    loadData(startTime, result.getAnchorMessage().getCreatedTime() - 1);
                } else {
                    calendarView.invalidateDecorators();
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    private static Drawable getDefaultSelector(Context context) {
        return AppCompatResources.getDrawable(context, R.drawable.calendar_selector);
    }
}