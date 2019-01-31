//
//  LPDateSelectView.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPDateSelectView.h"
#import "LPCalendarCell.h"

@interface LPDateSelectView()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *selectView;
@property (weak, nonatomic) FSCalendar *calendar;
@property(nonatomic,strong) NSMutableArray *selectDateArray;

@end

@implementation LPDateSelectView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];
        
    }
    return self;
}

-(void)setHidden:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 253);
        } completion:^(BOOL finished) {
            self.bgView.hidden = YES;
            self.selectView.hidden = YES;
        }];
    }else{
        self.bgView.hidden = NO;
        self.selectView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT-253, SCREEN_WIDTH, 253);
        }];
    }
}
-(void)hidden{
    self.hidden = YES;
}

-(void)setSelectArray:(NSArray *)selectArray{
    _selectArray = selectArray;
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM"];
//    NSString *string = [dateFormatter stringFromDate:currentDate];
    self.selectDateArray = [NSMutableArray array];
    for (NSString *str in selectArray) {
//        NSString *dateString = [NSString stringWithFormat:@"%@-%@",string,str];
//        [self.selectDateArray addObject:dateString];
        [self.selectDateArray addObject:str];
    }
    [self.calendar reloadData];
}


#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [dateFormatter stringFromDate:date];
    NSLog(@"did select %@",string);
    if (self.block) {
        self.block(string);
    }
    [self hidden];
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy/MM/dd";
//    NSString *key = [dateFormatter stringFromDate:date];
//
//    NSDictionary  *fillSelectionColors = @{
//                                           @"2018/09/06":[UIColor redColor],
//                                           @"2018/09/27":[UIColor grayColor],
//                                           @"2018/09/08":[UIColor greenColor],
//                                           @"2018/09/17":[UIColor grayColor],
//                                           @"2018/09/21":[UIColor cyanColor]};
//
//    if ([fillSelectionColors.allKeys containsObject:key]) {
////        return fillSelectionColors[key];
//        return [UIColor baseColor];
//    }
//    return nil;
//}
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    LPCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}


- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    NSLog(@"calendar.currentPage--  %@",calendar.currentPage);
    //日历翻页时记录第一天
//        NSDate *changeDate = [calendar tomorrowOfDate:calendar.currentPage];
    NSDate *changeDate = calendar.currentPage;
    [self.calendar setCurrentPage:changeDate animated:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *string = [dateFormatter stringFromDate:calendar.currentPage];
    if (self.pageblock) {
        self.pageblock(string);
    }
}

#pragma mark - Private methods

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    LPCalendarCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.label.hidden = YES;
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateFormatter stringFromDate:date];
    
//    NSDictionary  *fillSelectionColors = @{
//                                           @"2018-09-06":[UIColor redColor],
//                                           @"2018-09-27":[UIColor grayColor],
//                                           @"2018-09-08":[UIColor greenColor],
//                                           @"2018-09-17":[UIColor grayColor],
//                                           @"2018-09-21":[UIColor cyanColor]
//                                           };
    
    if ([self.selectDateArray containsObject:key]) {
        rangeCell.label.hidden = NO;
    }else{
        rangeCell.label.hidden = YES;
    }
}

#pragma mark - lazy
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 253)];
        _selectView.backgroundColor = [UIColor whiteColor];
        
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253)];
        calendar.dataSource = self;
        calendar.delegate = self;
//        calendar.scrollDirection = FSCalendarScrollDirectionVertical;
        calendar.backgroundColor = [UIColor whiteColor];
//        calendar.scrollEnabled = NO;
        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        calendar.appearance.selectionColor = [UIColor baseColor];
        calendar.appearance.weekdayTextColor = [UIColor baseColor];
        calendar.appearance.headerTitleColor = [UIColor baseColor];
        calendar.appearance.todayColor = [UIColor baseColor];
        calendar.today = nil;
//        calendar.pagingEnabled = NO;
        [calendar selectDate:[NSDate date]];
        calendar.appearance.headerDateFormat = @"yyyy年MM月";
//         _calendar.headerHeight = 0.0f
        calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        calendar.appearance.headerMinimumDissolvedAlpha = 0;
        calendar.scope = FSCalendarScopeMonth;
        [calendar registerClass:[LPCalendarCell class] forCellReuseIdentifier:@"cell"];
        [_selectView addSubview:calendar];
        calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;

        UIButton *TopBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//        TopBt.backgroundColor = [UIColor redColor];
        [TopBt setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [TopBt addTarget:self action:@selector(TopBtTouch) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:TopBt];
        
        UIButton *NextBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 40)];
        [NextBt setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [NextBt addTarget:self action:@selector(NextBtTouch) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:NextBt];
 
        
        self.calendar = calendar;
        
//        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 253)];
//        calendar.dataSource = self;
//        calendar.delegate = self;
//        calendar.appearance.headerMinimumDissolvedAlpha = 0;
//        calendar.backgroundColor = [UIColor whiteColor];
//        [_selectView addSubview:calendar];
//        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        
    }
    return _selectView;
}

-(void)TopBtTouch{
    
     NSDate *changeDate = _calendar.currentPage;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     formatter.dateFormat = @"yyyy-MM-dd HH:mm";
     NSString *nowDate = [formatter stringFromDate:changeDate];
    
    NSString *da = [nowDate changeEndTimeByKind:1 withNum:-1];
    [self.calendar setCurrentPage:[formatter dateFromString:da] animated:YES];
 }

-(void)NextBtTouch{
    NSDate *changeDate = _calendar.currentPage;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     formatter.dateFormat = @"yyyy-MM-dd HH:mm";
     NSString *nowDate = [formatter stringFromDate:changeDate];
    
    NSString *da = [nowDate changeEndTimeByKind:1 withNum:1];
    [self.calendar setCurrentPage:[formatter dateFromString:da] animated:YES];

}




@end
