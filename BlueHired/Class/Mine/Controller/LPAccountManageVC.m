//
//  LPAccountManageVC.m
//  BlueHired
//
//  Created by iMac on 2019/4/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAccountManageVC.h"
#import "LPChangePhoneVC.h"
#import "LPChangePasswordVC.h"
#import "AppDelegate.h"
#import "LPUserProblemModel.h"
#import "LPBankcardwithDrawModel.h"
#import "LPSalarycCardChangePasswordVC.h"



@interface LPAccountManageVC ()<LPWxLoginHBDelegate>
@property (weak, nonatomic) IBOutlet UILabel *WXLabel;
 @property(nonatomic,strong) LPBankcardwithDrawModel *model;

 
@end

@implementation LPAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密码修改";
    [self requestQueryBankcardwithDraw];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

- (IBAction)TouchBT:(UIButton *)sender {
    if (sender.tag == 1001) {   //密码修改
        LPChangePasswordVC *vc = [[LPChangePasswordVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){     //提现密码修改
        if (_model.data.type.integerValue == 1) {
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
        vc.phone = self.model.data.phone;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)requestQueryBankcardwithDraw{
    [NetApiManager requestQueryBankcardwithDrawWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPBankcardwithDrawModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

  
@end
