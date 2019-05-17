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


@property (weak, nonatomic) IBOutlet UILabel *text3;
@property (weak, nonatomic) IBOutlet UILabel *text4;
@property (weak, nonatomic) IBOutlet UILabel *text5;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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
        if ([self.modelstate.type integerValue] == 1)
        {
            self.time1.text = [NSString convertStringToTime:[_modelstate.time stringValue]];
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_normal"];
            self.image3.image = [UIImage imageNamed:@"add_ record_normal"];

            self.lineView2.backgroundColor = [UIColor colorWithHexString:@"#C5C5C5"];
            self.Label2.text = @" ";
            self.Label3.text = @" ";

        }
        else
        {
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image3.image = [UIImage imageNamed:@"add_ record_normal"];
//            self.lineView.backgroundColor = random(78, 191, 252, 1);
            self.time1.text = [NSString convertStringToTime:[_modelstate.time stringValue]];
            self.time2.text = [NSString convertStringToTime:[_modelstate.set_time stringValue]];
            self.lineView2.backgroundColor = [UIColor baseColor];
            self.Label2.text = @"财务处理提现，已提交到银行进行转账";
            self.Label3.text = @" ";
        }
        
        long long timeSet=[[self.model.set_time stringValue] longLongValue];

//        NSLog(@"  %f    %f",[NSString getNowTimestamp]/1000.0-timeSet/1000.0,60*60*2.0);
        
        if (timeSet/1000.0+60*60*2<[NSString getNowTimestamp]/1000.0 && timeSet >0) {
            self.image1.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image2.image = [UIImage imageNamed:@"add_ record_selected"];
            self.image3.image = [UIImage imageNamed:@"add_ record_selected"];

            //            self.lineView.backgroundColor = random(78, 191, 252, 1);
            self.time1.text = [NSString convertStringToTime:[_modelstate.time stringValue]];
            self.time2.text = [NSString convertStringToTime:[_modelstate.set_time stringValue]];
            self.lineView2.backgroundColor = [UIColor baseColor];
            self.Label2.text = @"财务处理提现，已提交到银行进行转账";
            self.Label3.text = @"银行处理转账，具体到账时间请留意银行短信通知";

        }
        
        _text3.text = [NSString stringWithFormat:@"¥%@",[LPTools isNullToString:_modelstate.money]];
        _text5.text = [NSString stringWithFormat:@"%@ ",[LPTools isNullToString:_modelstate.bankName]];
        _text4.text = [NSString stringWithFormat:@"尾号%@",[LPTools isNullToString:_modelstate.bankNum]];

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
                        str = @"注册返利到账";
        }
        else if ([_modelstate.type integerValue] == 7)
        {
                        str = @"代扣借支到账";
        }
        else if ([_modelstate.type integerValue] == 8)
        {
                        str = @"邀请奖励到账";
        }
        else if ([_modelstate.type integerValue] == 9)
        {
                        str = @"蓝聘红包";
        }
        _typeLabel.text = str;
        _moneyLabel.text = [NSString stringWithFormat:@"+ %.2f",_model.money.floatValue];
        _stateLabel.text = @"已到账";
        _dateLabel.text = [NSString convertStringToTime:[_modelstate.set_time stringValue]];
    }
}

#pragma mark - request
-(void)requestQueryWithdrawreCord{
      NSString *url = [NSString stringWithFormat:@"billrecord/query_withdrawrecord?id=%@&type=%@",_model.id,_model.billType];
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
