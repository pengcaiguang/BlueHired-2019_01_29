//
//  LPMyWalletVC.m
//  BlueHired
//
//  Created by iMac on 2020/1/4.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import "LPMyWalletVC.h"
#import "LPSalarycCardChangePasswordVC.h"
#import "LPWithDrawalVC.h"
#import "LPSalarycCard2VC.h"
#import "LPSelectBindbankcardModel.h"

@interface LPMyWalletVC ()
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property(nonatomic,strong) LPSelectBindbankcardModel *model;

@end

@implementation LPMyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    [self requestSelectBindbankcard];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.model.data) {
        self.MoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.model.data.accountBalance.floatValue];
    }else{
        self.MoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.userMaterialModel.data.money.floatValue];
    }

}

- (IBAction)touchBtn:(UIButton *)sender {
    if (sender.tag == 1000) {       //提现
        if (self.userMaterialModel.data.isBank.integerValue == 0) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"您还未绑定工资卡，请先绑定再提现！" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
            }];
            [alert show];
            return;
        }
        
        LPWithDrawalVC *vc = [[LPWithDrawalVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.model = self.model;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){     //换绑
        LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){     //提现密码修改
        if (self.userMaterialModel.data.isBank.integerValue == 0) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请先进行工资卡绑定！" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor whiteColor]] buttonsBackgroundColors:@[[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex) {
            }];
            [alert show];
            return;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *string = [dateFormatter stringFromDate:[NSDate date]];
        
        if (kUserDefaultsValue(ERRORTIMES)) {
            NSString *errorString = kUserDefaultsValue(ERRORTIMES);
            NSString *d = [errorString substringToIndex:16];
            NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
            NSString *t = [errorString substringFromIndex:17];
            if ([t integerValue] >= 3 && [str integerValue] < 10) {
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                }];
                [alert show];
                return;
            }
        }
        LPSalarycCardChangePasswordVC *vc = [[LPSalarycCardChangePasswordVC alloc]init];
        vc.phone = self.userMaterialModel.data.userTel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)setModel:(LPSelectBindbankcardModel *)model{
    _model = model;
    if (model.data) {
        self.MoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",model.data.accountBalance.floatValue];
    }
}

#pragma mark - request
-(void)requestSelectBindbankcard{
    [DSBaActivityView showActiviTy];

    [NetApiManager requestSelectBindbankcardWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [DSBaActivityView hideActiviTy];

        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPSelectBindbankcardModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

 
@end
