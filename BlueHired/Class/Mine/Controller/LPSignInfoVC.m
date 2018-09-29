//
//  LPSignInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSignInfoVC.h"
#import "LPCalendarSignCell.h"
#import "LPSignInfoModel.h"

@interface LPSignInfoVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *signNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayScoreLabel;

@property (weak, nonatomic) FSCalendar *calendar;
@property(nonatomic,strong) NSArray *selectDateArray;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,strong) LPSignInfoModel *model;
@end

@implementation LPSignInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"签到";
    self.selectDateArray = [NSMutableArray array];
    
    self.signButton.titleLabel.numberOfLines = 0;
    self.signButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.signButton.adjustsImageWhenHighlighted=NO;
    [self setupUI];
    [self requestSelectSignInfo];

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
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
- (IBAction)touchSignButton:(UIButton *)sender {
    [NetApiManager requestUserSignAddWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            [self requestSelectSignInfo];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)setModel:(LPSignInfoModel *)model{
    _model = model;
    self.signNumberLabel.text = [NSString stringWithFormat:@"本周已连续签到%@天",model.data.signNumber];
    self.dayScoreLabel.text = [NSString stringWithFormat:@"今日签到%@积分",model.data.dayScore];
    self.selectDateArray = model.data.signTimeList;
    [self.calendar reloadData];
    
    if ([self.selectDateArray containsObject:self.currentDateString]) {
        self.signButton.enabled = NO;
        self.dayScoreLabel.hidden = YES;
        [self.signButton setTitle:[NSString stringWithFormat:@"今日签到%@积分",model.data.dayScore] forState:UIControlStateNormal];
    }
}


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
    if ([self.selectDateArray containsObject:key] && ![self.selectDateArray containsObject:self.currentDateString]) {
        rangeCell.imgView.hidden = NO;
    }else{
        rangeCell.imgView.hidden = YES;
    }
}
-(void)requestSelectSignInfo{
    [NetApiManager requestSelectSignInfoWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPSignInfoModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
