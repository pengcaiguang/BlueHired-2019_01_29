//
//  LPBillRecordStateVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBillRecordStateVC.h"
#import "LPDrawalStateModel.h"

@interface LPBillRecordStateVC ()
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UILabel *Label2;

@property (weak, nonatomic) IBOutlet UILabel *time3;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *Label3;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel3;


@property (weak, nonatomic) IBOutlet UILabel *text3;
@property (weak, nonatomic) IBOutlet UILabel *text4;
@property (weak, nonatomic) IBOutlet UILabel *text5;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeMoneyLabel;


@end 

@implementation LPBillRecordStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
    [self requestQueryWithdrawreCord];
}

-(void)initView
{
    if ([self.model.billType integerValue] == 2)   //提现
    {
        self.view1.hidden = NO;
        self.view2.hidden = YES;
        if ([self.modelstate.status integerValue] == 1)
        {
            self.time1.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_normal"];
            self.image3.image = [UIImage imageNamed:@"add_ record_normal"];

            self.lineView2.backgroundColor = [UIColor colorWithHexString:@"#C5C5C5"];
            self.Label2.text = @" ";
            self.Label3.text = @" ";
        }else if ([self.modelstate.status integerValue] == 2) {
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image3.image = [UIImage imageNamed:@"add_ record_normal"];
//            self.lineView.backgroundColor = random(78, 191, 252, 1);
            self.time1.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            self.time2.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.set_time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            self.lineView2.backgroundColor = [UIColor baseColor];
            self.Label2.text = @" ";
            self.Label3.text = @" ";
        }else if ([self.modelstate.status integerValue] == 3  ){
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image3.image = [UIImage imageNamed:@"add_ record_selected"];
            
            self.time1.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            self.time2.text = @" ";
            self.time3.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.set_time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];

            self.lineView2.backgroundColor = [UIColor baseColor];
            self.Label2.text = @" ";
            self.Label3.text = @"银行已完成转账处理，请您留意银行到账短信通知";
        }else if ([self.modelstate.status integerValue] == 4 ){
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image3.image = [UIImage imageNamed:@"error"];
            
            self.time1.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            self.time2.text = @" ";
            self.time3.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.set_time stringValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            
            self.lineView2.backgroundColor = [UIColor baseColor];
            self.Label2.text = @" ";
            self.TitleLabel3.text = @"到账失败";
            self.Label3.text = self.model.errorRemark;
        }
        
//        long long timeSet=[[self.model.set_time stringValue] longLongValue];

//        NSLog(@"  %f    %f",[NSString getNowTimestamp]/1000.0-timeSet/1000.0,60*60*2.0);
        
//        if (timeSet/1000.0+60*60*2<[NSString getNowTimestamp]/1000.0 && timeSet >0) {
//
//
//        }
        
        _text3.text = [NSString stringWithFormat:@"¥%.2f",_modelstate.money.floatValue+_modelstate.chargeMoney.floatValue];
        _text5.text = [NSString stringWithFormat:@"%@ ",[LPTools isNullToString:_modelstate.bankName]];
        _text4.text = [NSString stringWithFormat:@"尾号%@",[LPTools isNullToString:_modelstate.bankNum]];
        _chargeMoneyLabel.text = [NSString stringWithFormat:@"手续费%.2f元，实际到账%.2f元",_modelstate.chargeMoney.floatValue,
                                  _modelstate.money.floatValue];
    }
    else
    {
        self.view1.hidden = YES;
        self.view2.hidden = NO;
        
        NSString *str = @"";
        
        if ([_modelstate.type integerValue] == 0)
        {
            str = @"其他到账";
        }
        else if ([_modelstate.type integerValue] == 1)
        {
                        str = @"借支到账";
        }
        else if ([_modelstate.type integerValue] == 2)
        {
                        str = @"管理费到账";
        }
        else if ([_modelstate.type integerValue] == 3)
        {
                        str = @"工资到账";
        }
        else if ([_modelstate.type integerValue] == 4)
        {
                        str = @"返费到账";
        }
        else if ([_modelstate.type integerValue] == 5)
        {
                        str = @"邀请注册奖励";
        }
        else if ([_modelstate.type integerValue] == 7)
        {
                        str = @"代扣借支到账";
        }
        else if ([_modelstate.type integerValue] == 8)
        {
                        str = @"邀请入职奖励";
        }
        else if ([_modelstate.type integerValue] == 9)
        {
                        str = @"蓝聘红包";
        }
        else if ([_model.type integerValue] == 10)
        {
                        str = @"完善资料奖励";
        }
        else if ([_model.type integerValue] == 11)
        {
                        str = @"积分兑换奖励";
        }
        else if ([_model.type integerValue] == 12)
        {
                        str = @"分享点赞奖励";
        }
        _typeLabel.text = str;
        _moneyLabel.text = [NSString stringWithFormat:@" %.2f",_model.money.floatValue];
        _stateLabel.text = @"已到蓝聘账户";
        _dateLabel.text = [DataTimeTool getDataTime:[NSString convertStringToTime:[_modelstate.set_time stringValue]] DateFormat:@"yyyy-MM-dd" oldDateFormat:@"yyyy/MM/dd HH:mm:ss"] ;
    }
}

#pragma mark - request
-(void)requestQueryWithdrawreCord{
      NSString *url = [NSString stringWithFormat:@"billrecord/query_withdrawrecord?id=%@&type=%@&versionType=2.3",_model.id,_model.billType];
    [NetApiManager requestQueryBankcardwithWithdrawreCordWithParam:url WithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.modelstate = [LPDrawalStateModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self initView];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
