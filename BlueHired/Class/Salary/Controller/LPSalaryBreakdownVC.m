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
#import "LPAddMoodeVC.h"
#import "LPPrizeMoney.h"
#import "LPPrizeMoneyCell.h"
#import "LPSalaryBreakdownTimeCell.h"

static NSString *LPSalaryBreakdownCellID = @"LPSalaryBreakdownCell";
static NSString *LPSalaryBreakdownTimeCellID = @"LPSalaryBreakdownTimeCell";

//static NSString *LPPrizeMoneyCellID = @"LPPrizeMoneyCell";

@interface LPSalaryBreakdownVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UITableView *Sharetableview;
@property(nonatomic,strong) UIButton *timeButton;
@property(nonatomic,strong) UIView *monthView;
@property(nonatomic,strong) UIView *monthBackView;
@property(nonatomic,strong) NSMutableArray <UIButton *>*monthButtonArray;
@property(nonatomic,assign) NSInteger month;
@property(nonatomic,strong) LPQuerySalarylistDataModel *selectModel;

@property(nonatomic,strong) LPQuerySalarylistModel *model;
@property(nonatomic,strong) LPBankcardwithDrawModel *Bankmodel;
@property(nonatomic,assign) NSInteger errorTimes;

@property(nonatomic,strong) NSArray *itemArray;
@property(nonatomic,strong) NSMutableArray <LPQuerySalarylistDataModel *>*listArray;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) CustomIOSAlertView *AlertView;

@end

@implementation LPSalaryBreakdownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工资领取";
    
    [self setupUI];
    self.page = 1;
    [self requestQuerySalarylist];
   
}

-(void)setupUI{
    
    [self.view addSubview:self.Sharetableview];
    self.Sharetableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.Sharetableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    self.Sharetableview.hidden = YES;
    
    
    
    

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"process"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_offset(LENGTH_SIZE(0));
    }];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(imageView.mas_top).offset(0);
        make.top.mas_equalTo(0);
    }];
}
 

#pragma mark - setter
- (void)setBankmodel:(LPBankcardwithDrawModel *)Bankmodel{
    _Bankmodel = Bankmodel;
    if (Bankmodel.data.type.integerValue == 1) {            //没有绑定
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"您还未绑定工资卡，请先绑定工资卡,再领取"
                                                             message:nil
                                                       textAlignment:NSTextAlignmentCenter
                                                        buttonTitles:@[@"取消",@"去绑定"]
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
        [self CustomAlertView:Bankmodel];
//        [self TouchDraw:Bankmodel];
    }
}

-(void)CustomAlertView:(LPBankcardwithDrawModel *)Bankmodel{
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    self.AlertView = alert;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LENGTH_SIZE(300), LENGTH_SIZE(332))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titlelabel = [[UILabel alloc] init];
    [view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(21));
        make.centerX.equalTo(view);
    }];
    titlelabel.font =[UIFont boldSystemFontOfSize:FontSize(18)];
    titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titlelabel.text = @"领取至";
    
    UILabel *bankName = [[UILabel alloc] init];
    [view addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlelabel.mas_bottom).offset(LENGTH_SIZE(21));
        make.left.mas_offset(LENGTH_SIZE(36));
    }];
    bankName.font = FONT_SIZE(15);
    bankName.textColor = [UIColor colorWithHexString:@"#666666"];
    bankName.text = [NSString stringWithFormat:@"银行：%@",Bankmodel.data.bankName];
    
    UILabel *bankNumber = [[UILabel alloc] init];
    [view addSubview:bankNumber];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankName.mas_bottom).offset(LENGTH_SIZE(8));
        make.left.mas_offset(LENGTH_SIZE(36));
    }];
    bankNumber.font = FONT_SIZE(15);
    bankNumber.textColor = [UIColor colorWithHexString:@"#666666"];
    bankNumber.text = [NSString stringWithFormat:@"卡号：**** **** **** %@",Bankmodel.data.bankNumber];
    
    UIView *backView = [[UIView alloc] init];
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNumber.mas_bottom).offset(LENGTH_SIZE(8));
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.height.mas_offset(LENGTH_SIZE(100));
    }];
    backView.layer.cornerRadius = 5;
    backView.backgroundColor = [UIColor colorWithHexString:@"#F5F7FA"];
    
    UILabel *MoneyLabel = [[UILabel alloc] init];
    [backView addSubview:MoneyLabel];
    [MoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(14));
        make.left.mas_offset(LENGTH_SIZE(16));
        make.right.mas_offset(LENGTH_SIZE(0));
    }];
    MoneyLabel.font = FONT_SIZE(15);
    MoneyLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    MoneyLabel.text = [NSString stringWithFormat:@"领取金额：￥%.2f",self.selectModel.actualPay.floatValue];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:MoneyLabel.text];
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(15)],
                            NSForegroundColorAttributeName: [UIColor baseColor]}
                    range:[MoneyLabel.text
                           rangeOfString:[NSString stringWithFormat:@"￥%.2f",self.selectModel.actualPay.floatValue]]];
    MoneyLabel.attributedText = string;
 
    UILabel *chargeMoney = [[UILabel alloc] init];
    [backView addSubview:chargeMoney];
    [chargeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MoneyLabel.mas_bottom).offset(LENGTH_SIZE(10));
        make.left.mas_offset(LENGTH_SIZE(16));
        make.right.mas_offset(LENGTH_SIZE(0));
    }];
    chargeMoney.font = FONT_SIZE(15);
    chargeMoney.textColor = [UIColor colorWithHexString:@"#666666"];
    chargeMoney.text = [NSString stringWithFormat:@"手续费：￥%.2f",self.Bankmodel.data.chargeMoney.floatValue];
    
    UILabel *realityMoney = [[UILabel alloc] init];
    [backView addSubview:realityMoney];
    [realityMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chargeMoney.mas_bottom).offset(LENGTH_SIZE(10));
        make.left.mas_offset(LENGTH_SIZE(16));
        make.right.mas_offset(LENGTH_SIZE(0));
    }];
    realityMoney.font = FONT_SIZE(15);
    realityMoney.textColor = [UIColor colorWithHexString:@"#666666"];
    realityMoney.text = [NSString stringWithFormat:@"实际到账：￥%.2f",self.selectModel.actualPay.floatValue-self.Bankmodel.data.chargeMoney.floatValue];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:realityMoney.text];
    [string2 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(15)],
                            NSForegroundColorAttributeName: [UIColor baseColor]}
                    range:[realityMoney.text
                           rangeOfString:[NSString stringWithFormat:@"￥%.2f",self.selectModel.actualPay.floatValue-self.Bankmodel.data.chargeMoney.floatValue]]];
    realityMoney.attributedText = string2;
    
    UILabel *Titlelabel2 = [[UILabel alloc] init];
    [view addSubview:Titlelabel2];
    [Titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(LENGTH_SIZE(17));
        make.centerX.equalTo(view);
    }];
    Titlelabel2.font = FONT_SIZE(14);
    Titlelabel2.textColor = [UIColor colorWithHexString:@"#999999"];
    Titlelabel2.text = @"预计到账时间为2小时内";
    
    UIButton *Btn  = [[UIButton alloc] init];
    [view addSubview:Btn];
    [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(LENGTH_SIZE(20));
        make.right.mas_offset(LENGTH_SIZE(-20));
        make.top.equalTo(Titlelabel2.mas_bottom).offset(LENGTH_SIZE(18));
        make.height.mas_offset(LENGTH_SIZE(48));
    }];
    Btn.backgroundColor = [UIColor baseColor];
    [Btn setTitle:@"确定" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.titleLabel.font = FONT_SIZE(17);
    Btn.layer.cornerRadius = 6;
    [Btn addTarget:self action:@selector(TouchAlertViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    alert.containerView = view;
    alert.buttonTitles=@[];
    [alert setUseMotionEffects:true];
    [alert setCloseOnTouchUpOutside:true];
    [alert show];

}

-(void)TouchAlertViewBtn:(UIButton *)sender{
    [self.AlertView close];
    [self TouchDraw: self.Bankmodel];
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
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        noDataView.hidden = hidden;
    }
}
#pragma mark - TableViewDelegate & Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.Sharetableview) {
        return LENGTH_SIZE(70);
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.Sharetableview) {
        UIView *HeadView = [[UIView alloc] init];
        
        UIView *view = [[UIView alloc] init];
        [HeadView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.top.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(60));
        }];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *month = [[UILabel alloc] init];
        [view addSubview:month];
        [month mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_offset(13);
            make.centerY.equalTo(view);
        }];
        month.textColor = [UIColor colorWithHexString:@"#333333"];
        month.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        month.text = self.selectModel.time;
        
        UILabel *money = [[UILabel alloc] init];
        [view addSubview:money];
        [money mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_offset(-13);
            make.centerY.equalTo(view);
        }];
        money.textColor = [UIColor baseColor];
        money.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        money.text = [NSString stringWithFormat:@"总计：%.2f元",self.selectModel.actualPay.floatValue];
        
        
        UIView *Lineview = [[UIView alloc] init];
        [HeadView addSubview:Lineview];
        [Lineview mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(10));
        }];
        Lineview.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        return HeadView;
    }
    
    return [[UIView alloc] init];
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (self.type == 1) {
//        return LENGTH_SIZE(66);
//    }
//    return CGFLOAT_MIN;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage imageNamed:@"process"];
//    return imageView;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.Sharetableview) {
        return self.itemArray.count;
    }

    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.Sharetableview) {
        static NSString *rid=@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:rid];
        }
        NSArray *array = [self.itemArray[indexPath.row] componentsSeparatedByString:@":"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",array[0]];
        cell.detailTextLabel.text = array[1];
        cell.textLabel.font = FONT_SIZE(15);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.detailTextLabel.font = FONT_SIZE(15);
        cell.detailTextLabel.textColor = [UIColor baseColor];
        
        return cell;
    }
    
    if (self.listArray[indexPath.row].id.integerValue == 0) {
        LPSalaryBreakdownTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSalaryBreakdownTimeCellID];
        cell.TimeLabel.text = self.listArray[indexPath.row].time;
        return cell;

    }else{
        LPSalaryBreakdownCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSalaryBreakdownCellID];
        
               cell.detailsLabel.hidden = NO;

               cell.companyNameLabel.text = self.listArray[indexPath.row].companyName;
               cell.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.listArray[indexPath.row].actualPay.floatValue];
               if (self.listArray[indexPath.row].status.integerValue == 1 ) {
                   cell.DrawBt.hidden = NO;
                   cell.AlreadyLabel.hidden = YES;
               }else if (self.listArray[indexPath.row].status.integerValue == 2){
                   cell.DrawBt.hidden = YES;
                   cell.AlreadyLabel.hidden = NO;
                   cell.AlreadyLabel.text  = @"本月已领取";
               }
               
               if (self.listArray[indexPath.row].actualPay.floatValue <= 0.0) {
                   cell.DrawBt.hidden = YES;
                   cell.AlreadyLabel.hidden = NO;
                   cell.AlreadyLabel.text  = @"不可领取";
               }
               
               WEAK_SELF()
               cell.block = ^(void){
                   weakSelf.selectModel = weakSelf.listArray[indexPath.row];

                   [weakSelf requestQueryBankcardwithDraw];
               };
        return cell;
    }
   
   
}

-(void)TouchDraw:(LPBankcardwithDrawModel *) m{
    
    [self requestQueryBankcardwithDrawDepositWithParam:@"" DrawModel:m];
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.selectModel = self.model.data[indexPath.row];
//    [self initShareImageView];
   if (self.listArray[indexPath.row].id.integerValue > 0) {
       LPSalaryDetailVC *vc = [[LPSalaryDetailVC alloc]init];
       vc.model = self.listArray[indexPath.row];
       [self.navigationController pushViewController:vc animated:YES];
   }

}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    if (self.model.data[indexPath.row].status.integerValue == 1){
//         return NO;
//    }
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self requestDelUserBill:self.model.data[indexPath.row]];
//    }
//}


#pragma mark - 秘密验证
-(void)requestQueryBankcardwithDrawDepositWithParam:(NSString *) string DrawModel:(LPBankcardwithDrawModel *) m{
//    NSString *passwordmd5 = [string md5];
//    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSString *url = [NSString stringWithFormat:@"billrecord/withdraw_deposit_by_salary?versionType=2.3&id=%@ ",self.selectModel.id];
    [NetApiManager requestQueryBankcardwithDrawDepositWithParam:url WithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] ==0)
            {
                if ([responseObject[@"data"] integerValue] ==1) {
                    
                    self.selectModel.status = @"2";
                    [self.tableview reloadData];
                    [self ToShareVC];

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
}

#pragma mark - 发布动态
-(void)ToShareVC{
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"恭喜您，工资领取成功，赶快发布动态跟好友分享吧~"
                                                         message:nil
                                                   textAlignment:NSTextAlignmentCenter
                                                    buttonTitles:@[@"取消",@"发布动态"]
                                                    buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                         buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                     buttonClick:^(NSInteger buttonIndex) {
                                                         if (buttonIndex) {
                                                             [self initShareImageView];
                                                         }
                                                     }];
    [alert show];
}

-(void)initShareImageView{
    NSMutableArray *mu = [NSMutableArray arrayWithArray:[self.selectModel.salaryDetails componentsSeparatedByString:@";"]];
    [mu removeObject:@""];
    for (NSInteger i = 0 ; i<mu.count ; i++) {
        NSString *str = [mu[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([str containsString:@"姓名"] ||
            [str containsString:@"身份证"]||
            [str containsString:@"单价"]||
            [str containsString:@"上月工价"]||
            [str containsString:@"本月工价"]||
            [str containsString:@"身份證"]||
            [str containsString:@"單價"]||
            [str containsString:@"上月工價"]||
            [str containsString:@"本月工價"]) {
            [mu removeObject:mu[i]];
            i--;
        }
    }
    
    self.itemArray = [mu copy];
    [self.Sharetableview reloadData];
 
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        self.Sharetableview.hidden = NO;
        self.navigationItem.title = @"工资明细";
        self.Sharetableview.lx_width = self.Sharetableview.contentSize.width;
        self.Sharetableview.lx_height = LENGTH_SIZE(70) + 44 * self.itemArray.count;
        
        UIImage *tableImage = [self getTableViewimage:self.Sharetableview];
        
        LPAddMoodeVC *vc = [[LPAddMoodeVC alloc] init];
        vc.Type = 1;
        vc.ShareImage = tableImage;
        vc.ShareString = self.selectModel.title;
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.title = @"工资领取";
    });
    
}


- (void)setModel:(LPQuerySalarylistModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:model.data];
            [self.tableview reloadData];
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.listArray.count == 0) {
            self.tableview.mj_footer.alpha = 0;
            [self addNodataViewHidden:NO];
        }else{
            self.tableview.mj_footer.alpha = 1;
            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


#pragma mark - request
-(void)requestQuerySalarylist{
    NSDictionary *dic = @{
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                          @"versionType":@"2.5"
                          };
    [NetApiManager requestQuerySalarylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
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
 

-(void)requestQueryUpdatePrizeMoney:(LPPrizeDataMoney *) m
                        moodDetails:(NSString *) moodDetails
                            moodUrl:(NSString *) moodUrl
                            address:(NSString *) address{
    NSDictionary *dic = @{
                          @"moodDetails":moodDetails,
                          @"moodUrl":moodUrl,
                          @"address":address,
                          };
    NSString *UrlStr = [NSString stringWithFormat:@"billrecord/update_prize_money?id=%@&type=%@",m.id,m.type];
    [NetApiManager requestQueryUpdatePrizeMoney:dic URLString:UrlStr  withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    m.status = @"1";
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"领取成功" time:MESSAGE_SHOW_TIME];
                    [self.tableview reloadData];
                    if ([responseObject[@"data"] integerValue] == 2) {
                        [LPTools AlertCircleView:@""];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"领取失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
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
        [_tableview registerNib:[UINib nibWithNibName:LPSalaryBreakdownTimeCellID bundle:nil] forCellReuseIdentifier:LPSalaryBreakdownTimeCellID];
            _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
                self.page = 1;
                [self requestQuerySalarylist];
            }];
            _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self requestQuerySalarylist];
            }];
   
//        [_tableview registerNib:[UINib nibWithNibName:LPPrizeMoneyCellID bundle:nil] forCellReuseIdentifier:LPPrizeMoneyCellID];

    }
    return _tableview;
}

- (UITableView *)Sharetableview{
    if (!_Sharetableview) {
        _Sharetableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _Sharetableview.delegate = self;
        _Sharetableview.dataSource = self;
        _Sharetableview.tableFooterView = [[UIView alloc]init];
        _Sharetableview.rowHeight = UITableViewAutomaticDimension;
        _Sharetableview.estimatedRowHeight = 44;
        _Sharetableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _Sharetableview.separatorColor = [UIColor colorWithHexString:@"#F5F5F5"];

    }
    return _Sharetableview;
}

 

-(UIImage *)getTableViewimage:(UITableView *) tableview{
    UIImage* viewImage = nil;


    UITableView *scrollView = tableview;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (UIImage *)getNormalImage:(UIView *)view
{
    UIImage* viewImage = nil;

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    {
         [view.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
    }
 
    
    return viewImage;
    
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
