//
//  VEIMDemoDateResultController.m
//  ByteBusiness
//
//  Created by hexi on 2025/1/7.
//  Copyright © 2025 loulan. All rights reserved.
//

#import "VEIMDemoDateResultController.h"

#import "VEIMDemoChatViewController.h"

#import <imsdk-tob/BIMSDK.h>
#import <OneKit/ByteDanceKit.h>
#import <FSCalendar/FSCalendar.h>
#import <OneKit/UIDevice+BTDAdditions.h>

// 指定指日期的开始时间 key
static NSString *const kStartDateInDayKey = @"start";
// 指定指日期的结束时间 key
static NSString *const kEndDateInDayKey = @"end";

@interface VEIMDemoDateResultController () <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>

@property (nonatomic, copy) NSString *conversationID;

@property (nonatomic, strong) FSCalendar *calendar;

@property (nonatomic, copy) NSDictionary<NSDate *,BIMMessage *> *meesageDict;

@end

@implementation VEIMDemoDateResultController

- (instancetype)initWithConversationID:(NSString *)conversationID
{
    self = [super init];
    if (self) {
        _conversationID = conversationID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self refreshMeesageDictWithDate:[NSDate date]];
}

- (void)setupViews
{
    [self.view addSubview:self.calendar];
}

#pragma mark - FSCalendarDelegate

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    [self refreshMeesageDictWithDate:calendar.currentPage];
}

/// 通过指定日期，获取对应月的日历信息
- (void)refreshMeesageDictWithDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
    NSInteger year = components.year;
    NSInteger month = components.month;
    
    /// 从月中每天取一条最早消息，生成 meesageDict <日期, 最早一条消息>
    NSArray<NSDictionary<NSString *, NSDate *> *> *dates = [self generateDatesForYear:year month:month];
    NSMutableDictionary *meesageDict = [NSMutableDictionary dictionary];
    dispatch_group_t group = dispatch_group_create();
    [dates enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSDate *> * _Nonnull dateDict, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_enter(group);
        BIMGetMessageOption *option = [[BIMGetMessageOption alloc] init];
        option.limit = 1;
        option.beginDate = [dateDict btd_objectForKey:kStartDateInDayKey default:nil];
        option.endDate = [dateDict btd_objectForKey:kEndDateInDayKey default:nil];
        [[BIMClient sharedInstance] getNewerMessageList:self.conversationID
                                                 option:option
                                             completion:^(NSArray<BIMMessage *> * _Nullable messages, BOOL hasMore, BIMMessage * _Nullable anchorMessage, BIMError * _Nullable error) {
            [meesageDict btd_setObject:messages.firstObject forKey:option.beginDate];
            dispatch_group_leave(group);
        }];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.meesageDict = [meesageDict copy];
        [self.calendar reloadData];
    });
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    BIMMessage *meesage = [self.meesageDict btd_objectForKey:date default:nil];
    if (!meesage) {
        return;
    }
    
    @weakify(self);
    [[BIMClient sharedInstance] getConversation:self.conversationID completion:^(BIMConversation * _Nullable conversation, BIMError * _Nullable error) {
        @strongify(self);
        if (!conversation || error) {
            return;
        }
        
        VEIMDemoChatViewController *chatVC = [VEIMDemoChatViewController chatVCWithConversation:conversation];
        chatVC.anchorMessage = meesage;
        btd_dispatch_async_on_main_queue(^{
            [self.navigationController pushViewController:chatVC animated:YES];
        });
    }];
}

#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return nil;
}

#pragma mark FSCalendarDelegateAppearance

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    return [UIColor whiteColor];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date
{
    BIMMessage *meesage = [self.meesageDict btd_objectForKey:date default:nil];
    return meesage ? [UIColor blackColor] : [UIColor systemGrayColor];
}

#pragma mark - Getter

- (FSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, [UIDevice btd_screenWidth], 300)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _calendar.locale = locale;  // 设置周次是中文显示
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        _calendar.appearance.headerDateFormat = @"yyyy 年 MM 月";
    }
    return _calendar;
}

#pragma mark - Private

// 生成指定年月中每一天的开始和结束时间
- (NSArray<NSDictionary<NSString *, NSDate *> *> *)generateDatesForYear:(NSInteger)year month:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = 1;
    
    // 获取该月的第一天
    NSDate *startOfMonth = [calendar dateFromComponents:components];
    
    // 获取该月的天数
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:startOfMonth];
    NSUInteger numberOfDays = range.length;
    
    NSMutableArray<NSDictionary<NSString *, NSDate *> *> *datesArray = [NSMutableArray array];
    
    for (NSUInteger day = 1; day <= numberOfDays; day++) {
        components.day = day;
        NSDate *date = [calendar dateFromComponents:components];
        
        // 获取当天的开始时间
        NSDate *startOfDay = [calendar startOfDayForDate:date];
        
        // 获取当天的结束时间
        NSDateComponents *endComponents = [[NSDateComponents alloc] init];
        endComponents.day = 1;
        NSDate *endOfDay = [calendar dateByAddingComponents:endComponents toDate:startOfDay options:0];
        endOfDay = [NSDate dateWithTimeInterval:-1 sinceDate:endOfDay];
        
        NSDictionary<NSString *, NSDate *> *dateDict = @{kStartDateInDayKey: startOfDay, kEndDateInDayKey: endOfDay};
        [datesArray addObject:dateDict];
    }
    
    return datesArray;
}

@end
