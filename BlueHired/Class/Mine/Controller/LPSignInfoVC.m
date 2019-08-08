//
//  LPSignInfoVC.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSignInfoVC.h"
#import "LPCalendarSignCell.h"
#import "LPSignInfoModel.h"
#import <WebKit/WebKit.h>

@interface LPSignInfoVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,WKNavigationDelegate, WKUIDelegate>{
    WKWebView *webview;
}
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *signNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayScoreLabel;

@property (weak, nonatomic) FSCalendar *calendar;
@property(nonatomic,strong) NSArray *selectDateArray;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,strong) LPSignInfoModel *model;
@property(nonatomic,strong) FSCalendar *Customcalendar;
@property(nonatomic,assign) BOOL IsSign;

@property (nonatomic,weak) CALayer *progressLayer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;


@end

@implementation LPSignInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LPTools deleteWebCache];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"签到";
    self.selectDateArray = [NSMutableArray array];
    
    self.signButton.titleLabel.numberOfLines = 0;
    self.signButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.signButton.adjustsImageWhenHighlighted=NO;
    self.IsSign = NO;
//    [self setupUI];
//    [self requestSelectSignInfo];

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    
    [self WebKit];
    
//    WKWebView *webview = [[WKWebView alloc] init];
//    [self.view addSubview:webview];
//    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.152:8020/bluehired/sign.html?sign=%ld",(long)[kUserDefaultsValue(LOGINID) integerValue]]];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webview loadRequest:request];
    
    
    
    
}
-(void)setupUI{
//    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(13, 20, SCREEN_WIDTH-26, 253)];
//    self.Customcalendar = calendar;
//    calendar.dataSource = self;
//    calendar.delegate = self;
//    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
//    calendar.backgroundColor = [UIColor whiteColor];
//    calendar.scrollEnabled = NO;
//    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
//    calendar.appearance.selectionColor = [UIColor baseColor];
//    calendar.appearance.weekdayTextColor = [UIColor whiteColor];
//    calendar.appearance.headerTitleColor = [UIColor whiteColor];
//    calendar.appearance.todayColor = [UIColor baseColor];
//    [calendar selectDate:[NSDate date]];
////    calendar.calendarHeaderView
//
//    calendar.appearance.headerDateFormat = @"yyyy-MM-dd";
//
//
//    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
//    calendar.userInteractionEnabled = YES;
//    calendar.allowsMultipleSelection = YES;
//    calendar.calendarHeaderView.backgroundColor = self.bgView.backgroundColor;
//    calendar.calendarWeekdayView.backgroundColor = self.bgView.backgroundColor;
//    [calendar registerClass:[LPCalendarSignCell class] forCellReuseIdentifier:@"cell"];
//    [self.bgView addSubview:calendar];
//    self.calendar = calendar;
    
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
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.userInteractionEnabled = NO;
    calendar.calendarHeaderView.backgroundColor = self.bgView.backgroundColor;
    calendar.calendarWeekdayView.backgroundColor = self.bgView.backgroundColor;
    [calendar registerClass:[LPCalendarSignCell class] forCellReuseIdentifier:@"cell"];
    [self.bgView addSubview:calendar];
    self.calendar = calendar;
    
}

- (void)getCache{
    //从缓存中先把数据取出来
//    NSString *key = [NSString stringWithFormat:@"arrayDate"];
//    NSMutableArray *cache = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    //允许用户选择,其实是允许系统来选中签到日期
    self.calendar.allowsSelection = YES;
    self.calendar.allowsMultipleSelection = YES;
    if (self.selectDateArray.count) {//如果cache里面有数据
        //选中日期,只有不在选中之列的才去选中它
        for (NSInteger i = 0; i<self.selectDateArray.count; i++) {
            if (![self.calendar.selectedDates containsObject:self.selectDateArray[i]]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd";
                NSDate *key = [dateFormatter dateFromString:self.selectDateArray[i]];
                
                [self.calendar selectDate:key];
            }
        }
    }else{//如果cache里面没有数据,说明第一次启动
        //创建个可变数组储存进缓存
//        NSMutableArray *cache = [NSMutableArray array];
//        [[NSUserDefaults standardUserDefaults] setValue:cache forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //选择完毕后关闭可选项,不让用户自己点
    self.calendar.allowsSelection = NO;
}



- (IBAction)touchSignButton:(UIButton *)sender {
        self.IsSign = YES;
    [NetApiManager requestUserSignAddWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] >0) {
                [self requestSelectSignInfo];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)setModel:(LPSignInfoModel *)model{
    _model = model;
    self.signNumberLabel.text = [NSString stringWithFormat:@"本周已连续签到%@天",model.data.signNumber];
    self.dayScoreLabel.text = [NSString stringWithFormat:@"今日签到%@积分",model.data.gainDayScore];
    self.signButton.enabled = YES;
    self.dayScoreLabel.hidden = NO;
    self.selectDateArray = model.data.signTimeList;
    [self.calendar reloadData];
    
    if ([self.selectDateArray containsObject:self.currentDateString]) {
        
        if ([model.data.gainDayScore integerValue] >0) {
            if (self.IsSign) {
                [LPTools AlertSignInView:[NSString stringWithFormat:@"%ld",(long)model.data.gainDayScore.integerValue]];
                self.IsSign = NO;
            }
            self.dayScoreLabel.text = [NSString stringWithFormat:@"今日签到%@积分",model.data.gainDayScore];
        }else{
            self.dayScoreLabel.text = [NSString stringWithFormat:@"今日签到%@积分",model.data.dayScore];
        }
        
        self.signButton.enabled = NO;
        self.dayScoreLabel.hidden = YES;
        [self.signButton setTitle:[NSString stringWithFormat:@"今日签到%@积分",model.data.gainDayScore] forState:UIControlStateNormal];
    }else{
        [self touchSignButton:nil];
        self.dayScoreLabel.text = [NSString stringWithFormat:@"今日签到%@积分",model.data.dayScore];
    }
    
    [self getCache];

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

}
-(void)requestSelectSignInfo{
    [NetApiManager requestSelectSignInfoWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPSignInfoModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



- (void)WebKit {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat view_w = self.view.frame.size.width;
    CGFloat view_h = self.view.frame.size.height;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    
    webview = [[WKWebView alloc] init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@resident/#/sign?sign=%ld",BaseRequestWeiXiURL,(long)[kUserDefaultsValue(LOGINID) integerValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self setupProgress];
    
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (webview.canGoBack) {
            [webview goBack];
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (webview.canGoForward) {
            [webview goForward];
        }
    }
}

-(void)setupProgress{
    UIView *progress = [[UIView alloc]init];
    progress.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    progress.backgroundColor = [UIColor  clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 1);
    layer.backgroundColor = [UIColor baseColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
}

#pragma mark - KVO回馈
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        if ([change[@"new"] floatValue] <[change[@"old"] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, 0, self.view.frame.size.width*[change[@"new"] floatValue], 1);
        if ([change[@"new"]floatValue] == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
                self.progressLayer.frame = CGRectMake(0, 0, 0, 1);
            });
        }
    }
    
}

- (void)dealloc {
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
