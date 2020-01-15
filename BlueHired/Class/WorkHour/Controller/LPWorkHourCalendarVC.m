//
//  LPWorkHourCalendarVC.m
//  BlueHired
//
//  Created by iMac on 2019/2/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourCalendarVC.h"
#import "LXCalender.h"
#import "LPLabourCostSetVC.h"
#import "LPPieceListVC.h"
#import "LPRecardWorkHourView.h"
#import "LPOverTimeAccountModel.h"
@interface LPWorkHourCalendarVC ()
@property(nonatomic,strong)LXCalendarView *calenderView;
@property(nonatomic,strong)UILabel *TitleLabel;
@property (nonatomic, strong)LPRecardWorkHourView *RecardView;
@property (nonatomic, strong)LPOverTimeAccountModel *OverModel;

@property(nonatomic,copy) NSString *baseSalary;
@property (nonatomic, copy)NSString *monthHours;
@property (nonatomic, strong)NSDictionary *Dictionary;

@end

@implementation LPWorkHourCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width , Screen_Height - kNavBarHeight - 65)];
    [self.view addSubview:ScrollView];

    UIButton *Button = [[UIButton alloc] init];
    [self.view addSubview:Button];
    [Button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
//
        make.height.mas_equalTo(48);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-13);
        } else {
            // Fallback on earlier versions
             make.bottom.mas_equalTo(-13);
        }
    }];
    Button.layer.cornerRadius = 4;
    Button.backgroundColor = [UIColor baseColor];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setTitle:@"分享" forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(ShareTouch) forControlEvents:UIControlEventTouchUpInside];
    
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 0)];
    
//    self.calenderView.currentMonthTitleColor =[UIColor colorWithHexString:@"#2c2c2c"];
//    self.calenderView.lastMonthTitleColor =[UIColor colorWithHexString:@"#8a8a8a"];
//    self.calenderView.nextMonthTitleColor =[UIColor colorWithHexString:@"#8a8a8a"];
    self.calenderView.WorkHourType = self.WorkHourType;
    
    self.calenderView.isHaveAnimation = NO;
    self.calenderView.backgroundColor = [UIColor redColor];
 
    self.calenderView.isCanScroll = NO;
    self.calenderView.isShowLastAndNextBtn = NO;
    
    self.calenderView.isShowLastAndNextDate = NO;
    
    self.calenderView.todayTitleColor =[UIColor redColor];
    
    self.calenderView.selectBackColor =[UIColor greenColor];
    self.calenderView.KQDateString = self.KQDateString;
//    self.calenderView.KQDateString = @"2019-03-09#2019-04-08";
//    [self.calenderView dealData:nil];
    
    self.calenderView.backgroundColor =[UIColor whiteColor];
    [ScrollView addSubview:self.calenderView];
    ScrollView.contentSize = CGSizeMake(Screen_Width, self.calenderView.lx_height);

    WEAK_SELF()
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
        NSString *dateStr = [NSString stringWithFormat:@"%.4ld-%.2ld-%.2ld",year,month,day];
        if ([weakSelf.Dictionary[@"data"] objectForKey:dateStr] && self.WorkHourType != 4) {
            [weakSelf requestQueryGetOvertimeAccount:dateStr];
        }else{
            weakSelf.OverModel = nil;
            [weakSelf initRecardView:dateStr];
        }
    };
    [self setupTitleView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestQueryGetCalenderList];
}


-(void)ShareTouch{
    [self.calenderView SetscreenshotView];
}



-(void)setupTitleView{
    UIView *navigationView = [[UIView alloc]init];
    navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 49);
    navigationView.center = CGPointMake(navigationView.superview.center.x, navigationView.superview.frame.size.height/2);
    self.navigationItem.titleView = navigationView;
    
    self.TitleLabel = [[UILabel alloc] init];
    [navigationView addSubview:self.TitleLabel];
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(navigationView);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH==320?154:200);
    }];
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    
    self.TitleLabel.textAlignment = NSTextAlignmentCenter;
    self.TitleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH==320?12:16];

    
    UIButton *leftButton = [[UIButton alloc] init];
    [navigationView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.TitleLabel.mas_left).offset(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [leftButton setImage:[UIImage imageNamed:@"WorkHourDateLeftBT_icon"] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftButton addTarget:self action:@selector(TouchLeftButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *RightButton = [[UIButton alloc] init];
    [navigationView addSubview:RightButton];
    [RightButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.TitleLabel.mas_right).offset(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [RightButton setImage:[UIImage imageNamed:@"WorkHourDateRightBT_icon"] forState:UIControlStateNormal];
    RightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [RightButton addTarget:self action:@selector(TouchRightButton) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)TouchLeftButton{
    NSArray *dateArr = [self.KQDateString componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateArr[0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setMonth:1];
    [comps2 setDay:-1];
    NSDate *endDate = [calender dateByAddingComponents:comps2 toDate:StartDate options:0];
    NSString *KQ = [NSString stringWithFormat:@"%@#%@",[dateFormatter stringFromDate:StartDate],[dateFormatter stringFromDate:endDate]];
    self.KQDateString = KQ;
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
//    for (LPWorkHourScrollView *view in self.ViewArray) {
//        view.KQDateString = self.KQDateString;
//    }
    [self requestQueryGetCalenderList];

}

-(void)TouchRightButton{
    NSArray *dateArr = [self.KQDateString componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateArr[0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setMonth:1];
    [comps2 setDay:-1];
    NSDate *endDate = [calender dateByAddingComponents:comps2 toDate:StartDate options:0];
    NSString *KQ = [NSString stringWithFormat:@"%@#%@",[dateFormatter stringFromDate:StartDate],[dateFormatter stringFromDate:endDate]];
    self.KQDateString = KQ;
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
//    for (LPWorkHourScrollView *view in self.ViewArray) {
//        view.KQDateString = self.KQDateString;
//    }
    [self requestQueryGetCalenderList];
}


//日历记加班
-(void)initRecardView:(NSString *)currentDateString{
    
    if (ISNIL(self.baseSalary)) {
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
                } else if (self.WorkHourType == 4){
                    LPLabourCostSetVC *vc = [[LPLabourCostSetVC alloc] init];
                    vc.Type = 2;
                    vc.WorkHourType = self.WorkHourType;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self requestQueryYsetInit];
                    self.RecardView.currentDateString = currentDateString;
                    self.RecardView.monthHours = self.monthHours;
                    self.RecardView.RecordModelList = self.OverModel.data.overtimeRecordList;
                    self.RecardView.WorkHourType = self.WorkHourType;
                    self.RecardView.hidden = NO;
                }
            }
        }];
        [alert show];
        return;
    }
    
    if (self.WorkHourType == 4) {
        LPPieceListVC *vc = [[LPPieceListVC alloc] init];
        vc.currentDateString = currentDateString;
        vc.KQDateString = self.KQDateString;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.RecardView.currentDateString = currentDateString;
        self.RecardView.monthHours = self.monthHours;
        self.RecardView.RecordModelList = self.OverModel.data.overtimeRecordList;
        self.RecardView.WorkHourType = self.WorkHourType;
        self.RecardView.hidden = NO;
    }
    
    return;
}
#pragma mark lazy
-(LPRecardWorkHourView *)RecardView{
    WEAK_SELF()
    if (!_RecardView) {
        _RecardView = [[LPRecardWorkHourView alloc] init];
    }
    _RecardView.block = ^(NSInteger index){
        [weakSelf requestQueryGetCalenderList];
    };
    return _RecardView;
}

- (void)setOverModel:(LPOverTimeAccountModel *)OverModel{
    _OverModel = OverModel;
}

#pragma mark - request
-(void)requestQueryGetCalenderList{
    NSDictionary *dic = @{@"type":@(self.WorkHourType),
                          @"timeRange":[LPTools isNullToString:self.KQDateString],
                          };
    [NetApiManager requestQueryGetCalenderList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.baseSalary = responseObject[@"data"][@"baseSalary"];
                self.monthHours = responseObject[@"data"][@"monthHours"];
                self.Dictionary = responseObject;
                self.calenderView.KQDateString = self.KQDateString;
                [self.calenderView dealData:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
//            self.model = [LPWorkHourYsetModel mj_objectWithKeyValues:responseObject];

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetOvertimeAccount:(NSString *) currentDateString{
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"time":currentDateString,
                          @"status":@(2)
                          };
    [NetApiManager requestQueryGetOvertimeAccount:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.OverModel = [LPOverTimeAccountModel mj_objectWithKeyValues:responseObject];
                [self initRecardView:currentDateString];
            }else{
                if ([responseObject[@"code"] integerValue] == 10002) {
                    [LPTools UserDefaulatsRemove];
                }
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else {
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
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self requestQueryGetCalenderList];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        
    }];
}

@end
