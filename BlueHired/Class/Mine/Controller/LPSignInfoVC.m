//
//  LPSignInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSignInfoVC.h"
#import "LPCalendarSignCell.h"

@interface LPSignInfoVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) FSCalendar *calendar;
@property(nonatomic,strong) NSMutableArray *selectDateArray;

@end

@implementation LPSignInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"签到";
    self.selectDateArray = [NSMutableArray array];
    [self setupUI];
    NSArray *a = @[@"2018-09-06",@"2018-09-10",@"2018-09-17",@"2018-09-22"];
    [self.selectDateArray addObjectsFromArray:a];
    [self.calendar reloadData];
}
-(void)setupUI{
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(13, 20, SCREEN_WIDTH-26, 253)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.scrollEnabled = NO;
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    calendar.appearance.selectionColor = [UIColor baseColor];
    calendar.appearance.weekdayTextColor = [UIColor whiteColor];
    calendar.appearance.headerTitleColor = [UIColor whiteColor];
    calendar.appearance.todayColor = [UIColor baseColor];
    [calendar selectDate:[NSDate date]];
    calendar.appearance.headerDateFormat = @"yyyy-MM-dd";
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.userInteractionEnabled = NO;
    calendar.calendarHeaderView.backgroundColor = self.bgView.backgroundColor;
    calendar.calendarWeekdayView.backgroundColor = self.bgView.backgroundColor;
    [calendar registerClass:[LPCalendarSignCell class] forCellReuseIdentifier:@"cell"];
    [self.bgView addSubview:calendar];
    
    self.calendar = calendar;
}
//-(void)setSelectArray:(NSArray *)selectArray{
//    _selectArray = selectArray;
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM"];
//    NSString *string = [dateFormatter stringFromDate:currentDate];
//    self.selectDateArray = [NSMutableArray array];
//    for (NSString *str in selectArray) {
//        NSString *dateString = [NSString stringWithFormat:@"%@-%@",string,str];
//        [self.selectDateArray addObject:dateString];
//    }
//    [self.calendar reloadData];
//}

#pragma mark - FSCalendarDelegate
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    LPCalendarSignCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - Private methods

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    LPCalendarSignCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.imgView.hidden = YES;
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateFormatter stringFromDate:date];
    if ([self.selectDateArray containsObject:key]) {
        rangeCell.imgView.hidden = NO;
    }else{
        rangeCell.imgView.hidden = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
