//
//  LPSalaryBreakdownVC.m
//  BlueHired
//
//  Created by peng on 2018/9/11.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSalaryBreakdownVC.h"
#import "LPQuerySalarylistModel.h"
#import "LPSalaryDetailVC.h"
#import "LPSalaryBreakdownCell.h"
#import "LPBankcardwithDrawModel.h"
#import "LPSalarycCard2VC.h"
#import "LPSalarycCardBindPhoneVC.h"

static NSString *LPSalaryBreakdownCellID = @"LPSalaryBreakdownCell";

@interface LPSalaryBreakdownVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;
@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,assign) NSInteger month;
@property(nonatomic,strong) LPQuerySalarylistDataModel *selectModel;

@property(nonatomic,strong) LPQuerySalarylistModel *model;
@property(nonatomic,strong) LPBankcardwithDrawModel *Bankmodel;
@property(nonatomic,assign) NSInteger errorTimes;

@end

@implementation LPSalaryBreakdownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工资领取";
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"MM"];
    self.month = [dateFormatter stringFromDate:currentDate].integerValue;
    
    [self setupUI];
    [self requestQuerySalarylist];
    
    NSComparisonResult sCOM= [[NSDate date] compare:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]];
    
    if (sCOM == NSOrderedAscending) {
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"系统时间不对,请前往设置修改时间" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert show];
        return;
    }
    
}

-(void)setupUI{
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(LENGTH_SIZE(44));
    }];
    bgView.backgroundColor = [UIColor baseColor];
    
//    UIImageView *imgView = [[UIImageView alloc]init];
//    [bgView addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(14);
//        make.centerY.equalTo(bgView);
//        make.size.mas_equalTo(CGSizeMake(19, 20));
//    }];
//    imgView.image = [UIImage imageNamed:@"calendar"];
    
    self.timeButton = [[UIButton alloc]init];
    [bgView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    self.timeButton.titleLabel.font = FONT_SIZE(16);
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(chooseMonth) forControlEvents:UIControlEventTouchUpInside];

    UIButton *leftImgView = [[UIButton alloc]init];
    [bgView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
        make.centerY.equalTo(self.timeButton);
        make.right.equalTo(self.timeButton.mas_left).offset(-10);
    }];
//    leftImgView.image = [UIImage imageNamed:@"left"];
    [leftImgView setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    leftImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftImgView addTarget:self action:@selector(TouchLeftBt:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightImgView = [[UIButton alloc]init];
    [bgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LENGTH_SIZE(44), LENGTH_SIZE(44)));
        make.centerY.equalTo(self.timeButton);
        make.left.equalTo(self.timeButton.mas_right).offset(10);
    }];
//    rightImgView.image = [UIImage imageNamed:@"right"];
    [rightImgView setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    rightImgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightImgView addTarget:self action:@selector(TouchrightBt:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(bgView.mas_bottom);
    }];
}

-(void)TouchLeftBt:(UIButton *)sender{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"] options:0];
    
    
    if (delta.month>=0) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    self.currentDateString = [dateFormatter stringFromDate:StartDate];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self requestQuerySalarylist];

}
-(void)TouchrightBt:(UIButton *)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitMonth;//只比较天数差异
    NSDateComponents *delta = [calendar components:unit fromDate:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"] toDate:[NSDate date] options:0];

    
    if (delta.month<=0) {
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:self.currentDateString];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    self.currentDateString = [dateFormatter stringFromDate:StartDate];
    [self.timeButton setTitle:self.currentDateString forState:UIControlStateNormal];
    [self requestQuerySalarylist];
}

-(void)chooseMonth{
    
    NSComparisonResult sCOM= [[NSDate date] compare:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]];
    
    if (sCOM == NSOrderedAscending) {
        
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"系统时间不对,请前往设置修改时间" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
 
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alert show];
        return;
    }
    
    QFDatePickerView *datePickerView = [[QFDatePickerView  alloc]initDatePackerWith:[DataTimeTool dateFromString:self.currentDateString DateFormat:@"yyyy-MM"]
                                                                                minDate:[DataTimeTool dateFromString:@"2018-01" DateFormat:@"yyyy-MM"]
                                                                                maxDate:[NSDate date]
                                                                               Response:^(NSString *str) {
         NSLog(@"str = %@", str);
        [self.timeButton setTitle:str forState:UIControlStateNormal];
        self.currentDateString = self.timeButton.titleLabel.text;
         [self requestQuerySalarylist];
     }];
    
    [datePickerView show];
//    self.monthView.hidden = !self.monthView.isHidden;
//    self.monthBackView.hidden = !self.monthBackView.isHidden;
}
-(void)monthViewHidden{
    self.monthView.hidden = YES;
    self.monthBackView.hidden = YES;
}

-(void)touchMonthButton:(UIButton *)button{
    NSString *year = [self.currentDateString substringToIndex:4];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@-%02ld",year,button.tag+1] forState:UIControlStateNormal];
    self.currentDateString = self.timeButton.titleLabel.text;
    for (UIButton *button in self.monthButtonArray) {
        button.selected = NO;
        button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    button.selected = YES;
    button.backgroundColor = [UIColor baseColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self monthViewHidden];
    });
    [self requestQuerySalarylist];
}

#pragma mark - setter
- (void)setBankmodel:(LPBankcardwithDrawModel *)Bankmodel{
    _Bankmodel = Bankmodel;
    if (Bankmodel.data.type.integerValue == 1) {            //没有绑定
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"您还未添加工资卡，请先添加工资卡，再领取"
                                                             message:nil
                                                       textAlignment:NSTextAlignmentCenter
                                                        buttonTitles:@[@"取消",@"去添加"]
                                                        buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                             buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                         buttonClick:^(NSInteger buttonIndex) {
                                                             if (buttonIndex) {
                                                                 LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
                                                                 [self.navigationController pushViewController:vc animated:YES];
                                                             }
        }];
        [alert show];
    }else{
        [self TouchDraw:Bankmodel];
    }
}

-(void)setModel:(LPQuerySalarylistModel *)model{
    _model = model;
    if (model.data.count == 0) {
        [self addNodataViewHidden:NO];
    }else{
        [self addNodataViewHidden:YES];
    }
    [self.tableview reloadData];
}
-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:noDataView];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(LENGTH_SIZE(44));
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSalaryBreakdownCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSalaryBreakdownCellID];
    cell.companyNameLabel.text = self.model.data[indexPath.row].companyName;
    cell.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.model.data[indexPath.row].actualPay.floatValue];
    if (self.model.data[indexPath.row].status.integerValue == 1) {
        cell.DrawBt.hidden = NO;
        cell.AlreadyLabel.hidden = YES;
    }else if (self.model.data[indexPath.row].status.integerValue == 2){
        cell.DrawBt.hidden = YES;
        cell.AlreadyLabel.hidden = NO;
    }
    WEAK_SELF()
    cell.block = ^(void){
        [weakSelf requestQueryBankcardwithDraw];
        weakSelf.selectModel = weakSelf.model.data[indexPath.row];
    };
    
    return cell;
}

-(void)TouchDraw:(LPBankcardwithDrawModel *) m{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
    if (kUserDefaultsValue(ERRORTIMES)) {
        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
        if(errorString.length<17){
            kUserDefaultsRemove(ERRORTIMES);
        }else{
            NSString *d = [errorString substringToIndex:16];
            NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
            NSString *t = [errorString substringFromIndex:17];
            self.errorTimes = [t integerValue];
            if ([t integerValue] >= 3 && [str integerValue] < 10) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                }];
                [alert show];
                return;
            }
            else
            {
                kUserDefaultsRemove(ERRORTIMES);
            }
        }

    }
    
    float money = [self.selectModel.actualPay floatValue];
    
    
    NSString *str1 = [NSString stringWithFormat:@"金额%.2f元将领取至尾号为%@%@，请注意查收",money,m.data.bankNumber,m.data.bankName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置：在3~length-3个单位长度内的内容显示色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor] range:[str1 rangeOfString:[NSString stringWithFormat:@"%.2f",money]]];
    
    GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc]
                                      initWithTitle:str
                                      message:@""
                                      buttonTitles:@[]
                                      buttonsColor:@[[UIColor baseColor]]
                                      buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                                            
                                                NSString *passwordmd5 = [string md5];
                                                NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
                                          
                                                NSString *url = [NSString stringWithFormat:@"billrecord/withdraw_deposit_by_salary?drawPwd=%@&id=%@ ",newPasswordmd5,self.selectModel.id];
                                                [NetApiManager requestQueryBankcardwithDrawDepositWithParam:url WithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
                                                    NSLog(@"%@",responseObject);
                                                    if (isSuccess) {
                                                        if ([responseObject[@"code"] integerValue] ==0)
                                                        {
                                                            if ([responseObject[@"data"] integerValue] ==1) {
                                                                [self requestQuerySalarylist];
                                                            }else{
                                                                [self.view showLoadingMeg:@"领取失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                                                            }
                                                        }
                                                        else
                                                        {
                                                            if ([responseObject[@"code"] integerValue] == 20027) {
                                                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                                                                NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                                                                
                                                                if (kUserDefaultsValue(ERRORTIMES)) {
                                                                    NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                                                                    NSString *d = [errorString substringToIndex:16];
                                                                    NSString *t = [errorString substringFromIndex:17];
                                                                    NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                                                                    
                                                                    self.errorTimes = [t integerValue];
                                                                    if ([t integerValue] >= 3&& [str integerValue] < 10) {
                                                                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                        }];
                                                                        [alert show];
                                                                    }else{
                                                                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                                                                             message:nil
                                                                                                                       textAlignment:NSTextAlignmentCenter
                                                                                                                        buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                                                                        buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                                                                                             buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                                                                         buttonClick:^(NSInteger buttonIndex) {
                                                                                                                             if (buttonIndex == 0) {
                                                                                                                                 LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                                                                 vc.type = 1;
                                                                                                                                 vc.Phone = m.data.phone;
                                                                                                                                 [self.navigationController pushViewController:vc animated:YES];
                                                                                                                             }else if (buttonIndex == 1){
                                                                                                                                         [self TouchDraw:self.Bankmodel];
                                                                                                                             }
                                                                                                                             //                               [self.navigationController popViewControllerAnimated:YES];
                                                                                                                         }];
                                                                        
                                                                        [alert show];
                                                                        
                                                                        self.errorTimes += 1;
                                                                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                                                                        kUserDefaultsSave(str, ERRORTIMES);
                                                                    }
                                                                }else{
                                                                    if (self.errorTimes >2) {
                                                                        self.errorTimes = 0;
                                                                    }
                                                                    
                                                                    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                                                                         message:nil
                                                                                                                   textAlignment:NSTextAlignmentCenter
                                                                                                                    buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                                                                    buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                                                                                         buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                                                                     buttonClick:^(NSInteger buttonIndex) {
                                                                                                                         if (buttonIndex == 0) {
                                                                                                                             LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                                                             vc.type = 1;
                                                                                                                             vc.Phone = m.data.phone;
                                                                                                                             [self.navigationController pushViewController:vc animated:YES];
                                                                                                                         }else if (buttonIndex == 1){
                                                                                                                             [self TouchDraw:self.Bankmodel];
                                                                                                                         }
                                                                                                                     }];
                                                                    
                                                                    [alert show];
                                                                    self.errorTimes += 1;
                                                                    NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                                                                    kUserDefaultsSave(str, ERRORTIMES);
                                                                }
                                                            }else{
                                                                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                                                            }
                                                            
                                                            
                                                            //                   [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                                                        }
                                                        
                                                    }else{
                                                        [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
                                                    }
                                                }];
                                      }];
    [alert show];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPSalaryDetailVC *vc = [[LPSalaryDetailVC alloc]init];
    vc.model = self.model.data[indexPath.row];
    vc.currentDateString = self.currentDateString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
-(void)requestQuerySalarylist{
    NSDictionary *dic = @{
                          @"month":self.currentDateString,
                          @"versionType":@"2.3"
                          };
    [NetApiManager requestQuerySalarylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPQuerySalarylistModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryBankcardwithDraw{
    [NetApiManager requestQueryBankcardwithDrawWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Bankmodel = [LPBankcardwithDrawModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPSalaryBreakdownCellID bundle:nil] forCellReuseIdentifier:LPSalaryBreakdownCellID];

    }
    return _tableview;
}
-(UIView *)monthView{
    if (!_monthView) {
        _monthView = [[UIView alloc]init];
        [self.view addSubview:_monthView];
        [_monthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(48);
            make.bottom.mas_equalTo(0);
        }];
        _monthView.backgroundColor = [UIColor blackColor];
        _monthView.alpha = 0.5;
        _monthView.userInteractionEnabled = YES;
        _monthView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthViewHidden)];
        [_monthView addGestureRecognizer:tap];
        
        
        self.monthBackView = [[UIView alloc]init];
        [self.view addSubview:self.monthBackView];
        [self.monthBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(48);
            make.height.mas_equalTo(150);
        }];
        self.monthBackView.hidden = YES;
        self.monthBackView.backgroundColor = [UIColor whiteColor];
        
        self.monthButtonArray = [NSMutableArray array];
        
        for (int i = 0; i < 12; i++) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, floor(i/4)*51, SCREEN_WIDTH/4, 51);
            view.backgroundColor = [UIColor whiteColor];
            [self.monthBackView addSubview:view];
            
            UIButton *button = [[UIButton alloc]init];
            [view addSubview:button];
            button.frame = CGRectMake((SCREEN_WIDTH/4-41)/2, 5, 41, 41);
            button.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20.5;
            button.tag = i;
            [self.monthButtonArray addObject:button];
            [button addTarget:self action:@selector(touchMonthButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.monthButtonArray[self.month-1].selected = YES;
        self.monthButtonArray[self.month-1].backgroundColor = [UIColor baseColor];
    }
    return _monthView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
