//
//  LPWorkHour2VC.m
//  BlueHired
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHour2VC.h"
#import "LPWorkHourHeadCell.h"
#import "LPWorkHourDetailsCell.h"
#import "LPWorkHourCalendarCell.h"
#import "LPWorkHourTallyBookCell.h"
#import "LPRecardWorkHourView.h"
#import "LPWorkHourDetail2VC.h"
#import "LPWorkHourCalendarVC.h"
#import "LPWorkHourBaseSalaryVC.h"
#import "LPWorkHourKQWeekVC.h"
#import "LPWorkdaySetVC.h"
#import "LPConsumeTypeVC.h"
#import "LPMonthWageModel.h"
#import "LPOverTimeAccountModel.h"
#import "LPWorkHourSetVC.h"
#import "LPWorkHourBaseSalary2VC.h"
#import "LPLabourCostSetVC.h"
#import "LPPieceListVC.h"
#import "LPActivityDatelisVC.h"
#import "LPActivityModel.h"
#import "ADAlertView.h"
#import "LPAdvertModel.h"
#import "ADModel.h"
#define BOOLFORKEYVC @"BOOLFORKEYVC"

static NSString *LPWorkHourHeadCellID = @"LPWorkHourHeadCell";
static NSString *LPWorkHourDetailsCellID = @"LPWorkHourDetailsCell";
static NSString *LPWorkHourCalendarCellID = @"LPWorkHourCalendarCell";
static NSString *LPWorkHourTallyBookCellID = @"LPWorkHourTallyBookCell";

@interface LPWorkHour2VC ()<UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource>
@property (nonatomic,strong)LPAdvertModel *AdvertModel;

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)LPRecardWorkHourView *RecardView;
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic, strong) UILabel *CustTitleLabel;

@property (nonatomic, strong) iCarousel *carous;
@property (nonatomic, strong) NSArray *carousImageList;
@property (nonatomic, strong) NSArray *carousColorList;
@property (nonatomic, strong) NSArray<UIButton *> *carousButtonList;
@property (nonatomic, assign) NSInteger carousIndex;

@property (nonatomic, strong)LPMonthWageModel *WageModel;
@property (nonatomic, strong)LPOverTimeAccountModel *OverModel;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger WorkHourType;
@property(nonatomic,strong) UIView *popView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIDatePicker *datePicker;

@end

@implementation LPWorkHour2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    if (kUserDefaultsValue(WORKTYPE).integerValue == 0) {
        self.WorkHourType = 3;
        kUserDefaultsSave(@"3", WORKTYPE);
    }else{
        self.WorkHourType = kUserDefaultsValue(WORKTYPE).integerValue;
    }
    
    

    
    self.carousIndex = 5;
    self.carousImageList = @[[UIImage imageNamed:@"WorkHourModelSwitch_icon3"],
                             [UIImage imageNamed:@"WorkHourModelSwitch_icon1"],
                             [UIImage imageNamed:@"WorkHourModelSwitch_icon2"],
                             [UIImage imageNamed:@"WorkHourModelSwitch_icon4"]];
    self.carousColorList = @[[UIColor baseColor],
                             [UIColor colorWithHexString:@"#0CC2DE"],
                             [UIColor colorWithHexString:@"##8F6AFF"],
                             [UIColor colorWithHexString:@"#FF6060"]];
    
    self.carousButtonList = @[[[UIButton alloc] init],[[UIButton alloc] init],[[UIButton alloc] init],[[UIButton alloc] init]];
    
    [self setNavigationButton];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBarHeight);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.carous];
    [self.carous mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.carous.hidden = YES;
    
    if (!self.isPush) {
        [self requestQueryDownload];
        [self requestQueryActivityadvert];
    }
     self.navigationController.navigationBar.hidden = YES;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];

    if (AlreadyLogin) {
        [self requestQueryGetOvertimeGetMonthWage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
 }

-(void)setNavigationButton{
//    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.title = @"加班记工时模式";
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"设置" forState:UIControlStateNormal];
////    button.frame = CGRectMake(0,100,60, 49);
//    [button addTarget:self action:@selector(touchNavButton) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem *navrightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = navrightButton;
    
    UIView *ConstView = [[UIView alloc] init];
    [self.view addSubview:ConstView];
    [ConstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavBarHeight);
        make.top.mas_equalTo(0);
    }];
    ConstView.backgroundColor = [UIColor baseColor];
    UILabel *TitleLabel = [[UILabel alloc] init];
    self.CustTitleLabel = TitleLabel;
    [ConstView addSubview:TitleLabel];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(ConstView);
    }];
    TitleLabel.textColor = [UIColor whiteColor];
    TitleLabel.font = FONT_SIZE(18);
    if (self.WorkHourType == 1) {
        self.CustTitleLabel.text = @"加班记工时模式";
    }else if (self.WorkHourType == 2){
        self.CustTitleLabel.text = @"综合记工时模式";
    }else if (self.WorkHourType == 3){
        self.CustTitleLabel.text = @"小时工记工时模式";
    }else if (self.WorkHourType == 4){
        self.CustTitleLabel.text = @"计件模式";
    }
    
    UIButton *backBt =[[UIButton alloc] init];
    [ConstView addSubview:backBt];
    [backBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(44);
    }];
    [backBt setImage:[UIImage imageNamed:@"BackBttonImage"] forState:UIControlStateNormal];
    [backBt setTitle:@" 返回" forState:UIControlStateNormal];
    [backBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBt sizeToFit];
    [backBt addTarget:self action:@selector(ToBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *LeftBt = [[UIButton alloc] init];
    [ConstView addSubview:LeftBt];
    [LeftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-14);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(28);
    }];
    LeftBt.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [LeftBt setTitle:@"切换模式" forState:UIControlStateNormal];
    LeftBt.layer.cornerRadius = 14;
    LeftBt.contentEdgeInsets = UIEdgeInsetsMake(0,7, 0, 0);
    LeftBt.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [LeftBt addTarget:self action:@selector(LeftBtTouch:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *RightBt = [[UIButton alloc] init];
    [ConstView addSubview:RightBt];
    [RightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
    }];
    RightBt.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [RightBt setTitle:@"设置" forState:UIControlStateNormal];
    [RightBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RightBt addTarget:self action:@selector(RightBtTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.isPush) {
        LeftBt.hidden = YES;
        backBt.hidden = NO;
    }else{
        LeftBt.hidden = NO;
        backBt.hidden = YES;
    }
    
}

-(void)ToBack:(UIButton *)sender{
    [self.navigationController   popViewControllerAnimated:YES];
}

-(void)LeftBtTouch:(UIButton *)sender{
    if ([LoginUtils validationLogin:self]) {
        NSInteger index = 0;
        if (self.WorkHourType == 3) {
            index = 0;
        }else if (self.WorkHourType == 1){
            index = 1;
        }else if (self.WorkHourType == 2){
            index = 2;
        }else if (self.WorkHourType == 4){
            index = 3;
        }
        [self.carous scrollToItemAtIndex:index animated:YES];
        self.carousIndex = index;
        [self openCountdown:index];
        self.carous.hidden = NO;
    }
}

-(void)RightBtTouch:(UIButton *)sender{
    if ([LoginUtils validationLogin:self]) {
        LPWorkHourSetVC *vc = [[LPWorkHourSetVC alloc] init];
        vc.WorkHourType = self.WorkHourType;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void)alertView:(NSInteger)index{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    self.popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    //    [self.popView addSubview:label];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,  10, SCREEN_WIDTH/2, 20)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.popView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,  10, SCREEN_WIDTH/2, 20)];
    confirmButton.tag = index;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBirthday:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.popView addSubview:confirmButton];
    
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT/3-30)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [DataTimeTool dateFromString:@"2010-01-01" DateFormat:@"yyyy-MM-dd"];
    _datePicker.maximumDate = [DataTimeTool dateFromString:@"2100-01-01" DateFormat:@"yyyy-MM-dd"];
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //    _datePicker.locale = [NSLocale systemLocale];
    _datePicker.date = [NSDate date];
    [self.popView addSubview:_datePicker];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.popView.frame.size.height, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        nil;
    }];
}


-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, SCREEN_HEIGHT/3);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.bgView removeFromSuperview];
        
    }];
}
-(void)confirmBirthday:(UIButton *)sender{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    
//    [_setdate setTitle:dateString forState:UIControlStateNormal];
    
    self.currentDateString =  dateString;
    //判断是否在考勤周期内
    NSArray *dateArr = [self.WageModel.data.period componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *oneDayStr = [dateFormatter dateFromString:dateArr[0]];
    NSDate *anotherDayStr = [dateFormatter dateFromString:dateArr[1]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *CurrentDate = [dateFormatter dateFromString:self.currentDateString];
    if ([NSString getNowTimestamp:CurrentDate]<[NSString getNowTimestamp:oneDayStr] ||
        [NSString getNowTimestamp:CurrentDate]>[NSString getNowTimestamp:anotherDayStr]) {
        [self requestQueryGetOvertimeGetMonthWage];
    }else{
        [self requestQueryGetOvertimeAccount];
    }
    
    
    
    
    [self removeView];
}



#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kUserDefaultsValue(BOOK).intValue == 1) {
        return 3;
    }
     return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
    //    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//手动计算高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kUserDefaultsValue(BOOK).intValue == 1) {
        if (indexPath.section == 0) {
            if (self.WorkHourType == 4) {
                NSInteger Count = self.OverModel.data.overtimeRecordList.count>3?3:self.OverModel.data.overtimeRecordList.count;
                return self.OverModel.data.overtimeRecordList.count>0 ? 46+12+72+39*Count+214 : 214+46+12+SCREEN_WIDTH/320*90.0;
            }
            return self.OverModel.data.overtimeRecordList.count>0 ? 46+12+185+214 : 214+46+12+SCREEN_WIDTH/320*90.0;
        }else if (indexPath.section == 1){
            return 47.0;
        }else {
            return 76.0;
        }
    }else{
        if (indexPath.section == 0) {
            if (self.WorkHourType == 4) {
                NSInteger Count = self.OverModel.data.overtimeRecordList.count>3?3:self.OverModel.data.overtimeRecordList.count;
                return self.OverModel.data.overtimeRecordList.count>0 ? 46+12+72+39*Count+214 : 214+46+12+SCREEN_WIDTH/320*90.0;
            }
            return self.OverModel.data.overtimeRecordList.count>0 ? 46+12+185+214 : 214+46+12+SCREEN_WIDTH/320*90.0;
        }else if (indexPath.section == 1){
            NSInteger RoeCount = self.OverModel.data.accountList.count>3?3:self.OverModel.data.accountList.count;
            return 80.0+RoeCount*41.0;
        }else if (indexPath.section == 2){
            return 47.0;
        }else {
            return 76.0;
        }
    }

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF()
    if (kUserDefaultsValue(BOOK).intValue == 1) {
        if (indexPath.section == 0) {
            LPWorkHourHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourHeadCellID];
            if(cell == nil){
                cell = [[LPWorkHourHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPWorkHourHeadCellID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.isPush = self.isPush;
            cell.WorkHourType = self.WorkHourType;
            cell.Model = self.WageModel.data;
            cell.RecordModelList = self.OverModel.data.overtimeRecordList;
            cell.BlockDate = ^(NSInteger date){
                if ([LoginUtils validationLogin:weakSelf]) {
                    if (date == 1) {
                        weakSelf.currentDateString =  [NSString dateAddFromString:self.currentDateString Day:-1];
                        //判断是否在考勤周期内
                        NSArray *dateArr = [weakSelf.WageModel.data.period componentsSeparatedByString:@"#"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
                        NSDate *oneDayStr = [dateFormatter dateFromString:dateArr[0]];
                        NSDate *anotherDayStr = [dateFormatter dateFromString:dateArr[1]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *CurrentDate = [dateFormatter dateFromString:weakSelf.currentDateString];
                        if ([NSString getNowTimestamp:CurrentDate]<[NSString getNowTimestamp:oneDayStr] ||
                            [NSString getNowTimestamp:CurrentDate]>[NSString getNowTimestamp:anotherDayStr]) {
                            [weakSelf requestQueryGetOvertimeGetMonthWage];
                        }else{
                            [weakSelf requestQueryGetOvertimeAccount];
                        }
                        
                        return ;
                    }else if (date == 2){
                        self.currentDateString =  [NSString dateAddFromString:self.currentDateString Day:1];
                        //判断是否在考勤周期内
                        NSArray *dateArr = [weakSelf.WageModel.data.period componentsSeparatedByString:@"#"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
                        NSDate *oneDayStr = [dateFormatter dateFromString:dateArr[0]];
                        NSDate *anotherDayStr = [dateFormatter dateFromString:dateArr[1]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *CurrentDate = [dateFormatter dateFromString:weakSelf.currentDateString];
                        if ([NSString getNowTimestamp:CurrentDate]<[NSString getNowTimestamp:oneDayStr] ||
                            [NSString getNowTimestamp:CurrentDate]>[NSString getNowTimestamp:anotherDayStr]) {
                            [weakSelf requestQueryGetOvertimeGetMonthWage];
                        }else{
                            [weakSelf requestQueryGetOvertimeAccount];
                        }
                        return;
                    }else if (date == 3){
                        if (!self.WageModel.data.baseSalary) {
                            
                            NSString *str1 = [NSString stringWithFormat:@"您尚未设置企业底薪，如果记录工时，则企业底薪默认为0，工资单价默认为0，是否继续记录?"];
                            if (self.WorkHourType == 2) {
                                str1 = @"您尚未设置企业底薪，如果记录工时，则企业底薪默认为0，工资单价默认为0，是否继续记录?";
                            }else if (self.WorkHourType == 3){
                                str1 = @"您尚未设置工价，如果要记录工时，必须先设置工价，是否前往设置工价？";
                            }else if (self.WorkHourType == 4){
                                str1 = @"您还没有设置产品信息，是否前往设置？";
                            }
                            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
                            //设置：在3~length-3个单位长度内的内容显示成橙色
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                if (buttonIndex) {
                                    if (self.WorkHourType == 3) {
                                        LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                                        vc.Type = 1;
                                        vc.WorkHourType = self.WorkHourType;
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }else if (self.WorkHourType == 4){
                                        LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                                        vc.Type = 2;
                                        vc.WorkHourType = self.WorkHourType;
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }else{
                                        [self requestQueryYsetInit];
                                    }
                                }
                            }];
                            [alert show];
                            return;
                        }
                        
                        if (self.WorkHourType == 4) {
                            LPPieceListVC *vc = [[LPPieceListVC alloc] init];
                            vc.currentDateString = weakSelf.currentDateString;
                            vc.KQDateString = weakSelf.WageModel.data.period;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            weakSelf.RecardView.currentDateString = weakSelf.currentDateString;
                            weakSelf.RecardView.monthHours = weakSelf.OverModel.data.monthHours;
                            weakSelf.RecardView.RecordModelList = weakSelf.self.OverModel.data.overtimeRecordList;
                            weakSelf.RecardView.WorkHourType = weakSelf.WorkHourType;
                            weakSelf.RecardView.hidden = NO;
                        }
                        
                        return;
                    }else if (date == 4){       //删除
                        NSString *str1 = [NSString stringWithFormat:@"是否删除 %@ 所记录的工时？",self.currentDateString];
                        if (self.WorkHourType == 4) {
                            str1 = [NSString stringWithFormat:@"是否删除 %@ 所记录的计件信息？",self.currentDateString];
                        }
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
                        //设置：在3~length-3个单位长度内的内容显示成橙色
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            if (buttonIndex) {
                                if (self.WorkHourType == 4) {
                                    [weakSelf requestQueryDeleteProRecord];
                                }else{
                                    [weakSelf requestQueryGetOvertime];
                                }
                            }
                        }];
                        [alert show];
                        return;
                    }else if (date == 5){       //设置企业底薪
                        if (self.WorkHourType == 4) {
                            LPWorkHourBaseSalary2VC *vc = [[LPWorkHourBaseSalary2VC alloc] init];
                            vc.WorkHourType = self.WorkHourType;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if (self.WorkHourType == 3){
                            LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                            vc.Type = 1;
                            vc.WorkHourType = self.WorkHourType;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        } else{
                            LPWorkHourBaseSalaryVC *vc = [[LPWorkHourBaseSalaryVC alloc] init];
                            vc.WorkHourType = self.WorkHourType;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    }else if (date == 6){
                        [weakSelf alertView:0];
                    }else if (date == 7){
                        [weakSelf LeftBtTouch:nil];
                    }
                }
            };
            //工时记录时间
            [cell.setDateBt setTitle:[NSString stringWithFormat:@"%@·%@",self.currentDateString,[NSString weekdayStringFromDate:self.currentDateString]] forState:UIControlStateNormal];
            return cell;
        }else if (indexPath.section == 1){
            static NSString *rid=@"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.imageView.image = [UIImage imageNamed:@"calendar_icon"];
            cell.textLabel.text = @"日历查看";
            return cell;
        }else{
            LPWorkHourDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailsCellID];
            if(cell == nil){
                cell = [[LPWorkHourDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPWorkHourDetailsCellID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            LPWorkHourHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourHeadCellID];
            if(cell == nil){
                cell = [[LPWorkHourHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPWorkHourHeadCellID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.isPush = self.isPush;
            cell.WorkHourType = self.WorkHourType;
            cell.Model = self.WageModel.data;
            cell.RecordModelList = self.OverModel.data.overtimeRecordList;
            cell.BlockDate = ^(NSInteger date){
                if ([LoginUtils validationLogin:weakSelf]) {
                    if (date == 1) {
                        weakSelf.currentDateString =  [NSString dateAddFromString:self.currentDateString Day:-1];
                        //判断是否在考勤周期内
                        NSArray *dateArr = [weakSelf.WageModel.data.period componentsSeparatedByString:@"#"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
                        NSDate *oneDayStr = [dateFormatter dateFromString:dateArr[0]];
                        NSDate *anotherDayStr = [dateFormatter dateFromString:dateArr[1]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *CurrentDate = [dateFormatter dateFromString:weakSelf.currentDateString];
                        if ([NSString getNowTimestamp:CurrentDate]<[NSString getNowTimestamp:oneDayStr] ||
                            [NSString getNowTimestamp:CurrentDate]>[NSString getNowTimestamp:anotherDayStr]) {
                            [weakSelf requestQueryGetOvertimeGetMonthWage];
                        }else{
                            [weakSelf requestQueryGetOvertimeAccount];
                        }
                        
                        return ;
                    }else if (date == 2){
                        self.currentDateString =  [NSString dateAddFromString:self.currentDateString Day:1];
                        //判断是否在考勤周期内
                        NSArray *dateArr = [weakSelf.WageModel.data.period componentsSeparatedByString:@"#"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
                        NSDate *oneDayStr = [dateFormatter dateFromString:dateArr[0]];
                        NSDate *anotherDayStr = [dateFormatter dateFromString:dateArr[1]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSDate *CurrentDate = [dateFormatter dateFromString:weakSelf.currentDateString];
                        if ([NSString getNowTimestamp:CurrentDate]<[NSString getNowTimestamp:oneDayStr] ||
                            [NSString getNowTimestamp:CurrentDate]>[NSString getNowTimestamp:anotherDayStr]) {
                            [weakSelf requestQueryGetOvertimeGetMonthWage];
                        }else{
                            [weakSelf requestQueryGetOvertimeAccount];
                        }
                        return;
                    }else if (date == 3){
                        if (!self.WageModel.data.baseSalary) {
                            
                            NSString *str1 = [NSString stringWithFormat:@"您尚未设置企业底薪，如果记录工时，则企业底薪默认为0，工资单价默认为0，是否继续记录?"];
                            if (self.WorkHourType == 2) {
                                str1 = @"您尚未设置企业底薪，如果记录工时，则企业底薪默认为0，工资单价默认为0，是否继续记录?";
                            }else if (self.WorkHourType == 3){
                                str1 = @"您尚未设置工价，如果要记录工时，必须先设置工价，是否前往设置工价？";
                            }else if (self.WorkHourType == 4){
                                str1 = @"您还没有设置产品信息，是否前往设置？";
                            }
                            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
                            //设置：在3~length-3个单位长度内的内容显示成橙色
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                if (buttonIndex) {
                                    if (self.WorkHourType == 3) {
                                        LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                                        vc.Type = 1;
                                        vc.WorkHourType = self.WorkHourType;
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }else if (self.WorkHourType == 4){
                                        LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                                        vc.Type = 2;
                                        vc.WorkHourType = self.WorkHourType;
                                        vc.hidesBottomBarWhenPushed = YES;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }else{
                                        [self requestQueryYsetInit];
                                    }
                                }
                            }];
                            [alert show];
                            return;
                        }
                        
                        if (self.WorkHourType == 4) {
                            LPPieceListVC *vc = [[LPPieceListVC alloc] init];
                            vc.currentDateString = weakSelf.currentDateString;
                            vc.KQDateString = weakSelf.WageModel.data.period;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            weakSelf.RecardView.currentDateString = weakSelf.currentDateString;
                            weakSelf.RecardView.monthHours = weakSelf.OverModel.data.monthHours;
                            weakSelf.RecardView.RecordModelList = weakSelf.self.OverModel.data.overtimeRecordList;
                            weakSelf.RecardView.WorkHourType = weakSelf.WorkHourType;
                            weakSelf.RecardView.hidden = NO;
                        }
                        return;
                    }else if (date == 4){       //删除
                        NSString *str1 = [NSString stringWithFormat:@"是否删除 %@ 所记录的工时？",self.currentDateString];
                        if (self.WorkHourType == 4) {
                            str1 = [NSString stringWithFormat:@"是否删除 %@ 所记录的计件信息？",self.currentDateString];
                        }
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
                        //设置：在3~length-3个单位长度内的内容显示成橙色
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            if (buttonIndex) {
                                if (self.WorkHourType == 4) {
                                    [weakSelf requestQueryDeleteProRecord];
                                }else{
                                    [weakSelf requestQueryGetOvertime];
                                }
                            }
                        }];
                        [alert show];
                        return;
                    }else if (date == 5){       //设置企业底薪
                        if (self.WorkHourType == 4) {
                            LPWorkHourBaseSalary2VC *vc = [[LPWorkHourBaseSalary2VC alloc] init];
                            vc.WorkHourType = self.WorkHourType;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if (self.WorkHourType == 3){
                            LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                            vc.Type = 1;
                            vc.WorkHourType = self.WorkHourType;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        } else{
                            LPWorkHourBaseSalaryVC *vc = [[LPWorkHourBaseSalaryVC alloc] init];
                            vc.WorkHourType = self.WorkHourType;
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }else if (date == 6){
                        [weakSelf alertView:0];
                    }
                    else if (date == 7){
                        [weakSelf LeftBtTouch:nil];
                    }
                }
            };
            //工时记录时间
            [cell.setDateBt setTitle:[NSString stringWithFormat:@"%@·%@",self.currentDateString,[NSString weekdayStringFromDate:self.currentDateString]] forState:UIControlStateNormal];
            return cell;
        }else if (indexPath.section == 1){
            LPWorkHourTallyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourTallyBookCellID];
            if(cell == nil){
                cell = [[LPWorkHourTallyBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPWorkHourTallyBookCellID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (self.OverModel.data.accountPrice.floatValue == 0.0) {
                cell.MoneyLabel.text = @"今日尚无消费记录";
            }else{
                cell.MoneyLabel.text = [NSString stringWithFormat:@"今日总消费%.2f元",self.OverModel.data.accountPrice.floatValue];
            }
            cell.accountList = self.OverModel.data.accountList;
            return cell;
        }else if (indexPath.section == 2){
            static NSString *rid=@"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.imageView.image = [UIImage imageNamed:@"calendar_icon"];
            cell.textLabel.text = @"日历查看";
            return cell;
        }else{
            LPWorkHourDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailsCellID];
            if(cell == nil){
                cell = [[LPWorkHourDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPWorkHourDetailsCellID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (kUserDefaultsValue(BOOK).intValue) {
        if (indexPath.section == 1){
            if ([LoginUtils validationLogin:self]) {
                LPWorkHourCalendarVC *vc = [[LPWorkHourCalendarVC alloc] init];
                vc.KQDateString = self.WageModel.data.period;
                vc.hidesBottomBarWhenPushed = YES;
                vc.WorkHourType = self.WorkHourType;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.section == 2){
            if ([LoginUtils validationLogin:self]) {
                LPWorkHourDetail2VC *vc = [[LPWorkHourDetail2VC alloc] init];
                vc.KQDateString = self.WageModel.data.period;
                vc.WorkHourType = self.WorkHourType;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        if (indexPath.section == 1) {
            if ([LoginUtils validationLogin:self]) {
                LPConsumeTypeVC *vc = [[LPConsumeTypeVC alloc] init];
                vc.currentDateString = self.currentDateString;
                vc.WorkHourType = self.WorkHourType;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.section == 2){
            if ([LoginUtils validationLogin:self]) {
                LPWorkHourCalendarVC *vc = [[LPWorkHourCalendarVC alloc] init];
                vc.KQDateString = self.WageModel.data.period;
                vc.hidesBottomBarWhenPushed = YES;
                vc.WorkHourType = self.WorkHourType;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.section == 3){
            if ([LoginUtils validationLogin:self]) {
                LPWorkHourDetail2VC *vc = [[LPWorkHourDetail2VC alloc] init];
                vc.KQDateString = self.WageModel.data.period;
                vc.hidesBottomBarWhenPushed = YES;
                vc.WorkHourType = self.WorkHourType;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
    
}
#pragma mark iCarouselDelegate#iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    
    return 4;
    
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
            //循环滑动效果
        case iCarouselOptionWrap:
        {
            return NO;
        }
            
        default:
            break;
    }
    
    return value;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 216.0/320*SCREEN_WIDTH, 352.0/320*SCREEN_WIDTH)];
    v.backgroundColor = [UIColor whiteColor];
    v.layer.cornerRadius = 8;
    
    UIImageView *iamgeView =[[UIImageView alloc] init];
    [v addSubview:iamgeView];
    [iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(255.0/320*SCREEN_WIDTH);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    iamgeView.image = self.carousImageList[index];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [v addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(Screen_Width == 320? 30:40);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"否" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#929292"] forState:UIControlStateNormal];
    cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.cornerRadius = Screen_Width == 320?15:20;
    [cancelButton addTarget:self action:@selector(TouchCarouselCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = self.carousButtonList[index];
    [v addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(Screen_Width == 320? 30:40);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(cancelButton.mas_top).offset(-10);
    }];
    saveButton.backgroundColor = [UIColor baseColor];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"是" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = Screen_Width == 320?15:20;;
    saveButton.tag = index +100;
    [saveButton addTarget:self action:@selector(TouchCarouselSaveButton:) forControlEvents:UIControlEventTouchUpInside];


    return v;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    if (carousel.currentItemIndex != self.carousIndex) {
        self.carousIndex = carousel.currentItemIndex;
        [self openCountdown:carousel.currentItemIndex];
    }
}




-(void)TouchCarouselSaveButton:(UIButton *)sender{
    NSLog(@"切换模式成功 %ld",sender.tag);
    NSInteger selectRow = sender.tag-100;
    self.carous.hidden = YES;
    if (selectRow == 1) {
        self.CustTitleLabel.text = @"加班记工时模式";
        self.WorkHourType = 1;
    }else if (selectRow == 2){
        self.CustTitleLabel.text = @"综合记工时模式";
        self.WorkHourType = 2;
    }else if (selectRow == 0){
        self.CustTitleLabel.text = @"小时工记工时模式";
        self.WorkHourType = 3;
    }else if (selectRow == 3){
        self.CustTitleLabel.text = @"计件模式";
        self.WorkHourType = 4;
    }
    
    NSString *Type = [NSString stringWithFormat:@"%ld",(long)self.WorkHourType];
    
    kUserDefaultsSave(Type, WORKTYPE);
    
    [self.view showLoadingMeg:@"模式切换成功！" time:MESSAGE_SHOW_TIME];
    [self requestQueryGetOvertimeGetMonthWage];
}
-(void)TouchCarouselCancelButton:(UIButton *)sender{
    self.carous.hidden = YES;
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourHeadCellID bundle:nil] forCellReuseIdentifier:LPWorkHourHeadCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourDetailsCellID bundle:nil] forCellReuseIdentifier:LPWorkHourDetailsCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourCalendarCellID bundle:nil] forCellReuseIdentifier:LPWorkHourCalendarCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourTallyBookCellID bundle:nil] forCellReuseIdentifier:LPWorkHourTallyBookCellID];
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            [self requestUserMaterial];
//            [self requestSelectCurIsSign];
//        }];
    }
    return _tableview;
}

-(iCarousel *)carous{
    if (!_carous) {
        _carous = [[iCarousel alloc] init];
        _carous.delegate = self;
        _carous.dataSource = self;
//        _carous.scrollOffset = 100;
        _carous.type = iCarouselTypeRotary;
//        _carous.autoscroll = 0;
        _carous.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.85];
    }
    return _carous;
}

-(LPRecardWorkHourView *)RecardView{
    WEAK_SELF()
    if (!_RecardView) {
        _RecardView = [[LPRecardWorkHourView alloc] init];
    }
    _RecardView.block = ^(NSInteger index){
        [weakSelf requestQueryGetOvertimeGetMonthWage];
    };
    return _RecardView;
}

-(void)setWageModel:(LPMonthWageModel *)WageModel{
    _WageModel = WageModel;
 
    [self requestQueryGetOvertimeAccount];
}

- (void)setOverModel:(LPOverTimeAccountModel *)OverModel{
    _OverModel = OverModel;
    [self.tableview reloadData];
}




#pragma mark - 更新
-(void)requestQueryDownload{
    NSDictionary *dic = @{
                          @"type":@"2"
                          };
    [NetApiManager requestQueryDownload:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"] != nil &&
                [responseObject[@"data"][@"version"] length]>0) {
                NSLog(@"%.2f",self.version.floatValue);
                if (self.version.floatValue <  [responseObject[@"data"][@"version"] floatValue]  ) {
                    NSString *updateStr = [NSString stringWithFormat:@"发现新版本V%@\n为保证软件的正常运行\n请及时更新到最新版本",responseObject[@"data"][@"version"]];
                    [self creatAlterView:updateStr];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//版本
-(NSString *)version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
//3. 弹框提示
-(void)creatAlterView:(NSString *)msg{
    UIAlertController *alertText = [UIAlertController alertControllerWithTitle:@"更新提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //增加按钮
    [alertText addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [alertText addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1441365926?mt=8"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    [self presentViewController:alertText animated:YES completion:nil];
}

-(void)requestQueryActivityadvert{
    [NetApiManager requestQueryActivityadvert:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                LPAdvertModel *model = [LPAdvertModel mj_objectWithKeyValues:responseObject];
                if (model.data.count) {
                    self.AdvertModel = model;
                    [ADAlertView  showInView:[UIWindow visibleViewController].view theDelegate:self theADInfo:model.data placeHolderImage:@"1"];
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)clickAlertViewAtIndex:(NSInteger)index{
    LPActivityDatelisVC *vc = [[LPActivityDatelisVC alloc] init];
    LPActivityDataModel *M = [[LPActivityDataModel alloc] init];
    M.id = self.AdvertModel.data[index].id;
    vc.Model = M;
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}


#pragma mark - request
-(void)requestQueryGetOvertimeGetMonthWage{
 
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"time":self.currentDateString
                          };
    [NetApiManager requestQueryGetOvertimeGetMonthWage:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.WageModel = [LPMonthWageModel mj_objectWithKeyValues:responseObject];
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];

        }
        
    }];
}

-(void)requestQueryGetOvertimeAccount{

    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"time":self.currentDateString,
                          @"status":@(3)
                          };
    [NetApiManager requestQueryGetOvertimeAccount:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.OverModel = [LPOverTimeAccountModel mj_objectWithKeyValues:responseObject];
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

-(void)requestQueryGetOvertime{
    NSDictionary *dic = @{
                          @"delStatus":@(1),
                          @"time":self.currentDateString,
                          @"type":[NSString stringWithFormat:@"%ld",(long)self.WorkHourType]
                          };
    WEAK_SELF()
    [NetApiManager requestQueryGetOvertime:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray  *dataArr = [responseObject[@"data"] componentsSeparatedByString:@"#"];//分隔符逗号
                if ([dataArr[1] integerValue] == 1) {
                    //                weakSelf.OverModel.data.overtimeRecordList = @[];
                    //                [weakSelf.tableview  reloadData];
                    [weakSelf requestQueryGetOvertimeGetMonthWage];
                }else{
                    [self.view showLoadingMeg:@"删除失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
       
    }];
}


-(void)requestQueryDeleteProRecord{
    NSDictionary *dic = @{@"time":self.currentDateString,
                          @"delStatus":@(1)
                          };
    WEAK_SELF()
    [NetApiManager requestQueryUpdateProRecord:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [weakSelf requestQueryGetOvertimeGetMonthWage];
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
            
        }
        
    }];
}




-(void)requestQueryYsetInit{
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType)
                          };
    WEAK_SELF()
    [NetApiManager requestQueryYsetInit:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                    weakSelf.RecardView.currentDateString = weakSelf.currentDateString;
                    weakSelf.RecardView.monthHours = weakSelf.OverModel.data.monthHours;
                    weakSelf.RecardView.RecordModelList = weakSelf.OverModel.data.overtimeRecordList;
                    weakSelf.RecardView.WorkHourType = weakSelf.WorkHourType;
                    weakSelf.RecardView.hidden = NO;
                    [self requestQueryGetOvertimeGetMonthWage];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

-(void)openCountdown:(NSInteger )index{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        for (UIButton *bt in self.carousButtonList) {
            [bt setTitle:@"是" forState:UIControlStateNormal];
            bt.userInteractionEnabled = NO;
        }
    }
    __block NSInteger time = 3; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.carousButtonList[index] setTitle:@"是" forState:UIControlStateNormal];
                 self.carousButtonList[index].userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 4;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.carousButtonList[index] setTitle:[NSString stringWithFormat:@"是(%d)", seconds] forState:UIControlStateNormal];
                 self.carousButtonList[index].userInteractionEnabled = NO;
             });
            time--;
        }
    });
    dispatch_resume(_timer);
}
@end
