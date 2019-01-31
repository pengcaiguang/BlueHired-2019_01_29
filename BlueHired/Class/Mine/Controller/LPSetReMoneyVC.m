//
//  LPSetReMoneyVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSetReMoneyVC.h"

@interface LPSetReMoneyVC ()

@end

@implementation LPSetReMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置返费";
    self.userName.text = [LPTools isNullToString:_model.userName];
    self.MechanismName.text = [LPTools isNullToString:_model.mechanismName];
}

- (IBAction)touchSet:(id)sender {
    if (self.textTF.text.floatValue>[LPTools isNullToString:_model.platReMoney].floatValue) {
        [self.view showLoadingMeg:@"返费金额过高,请重新设置" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.textTF.text.floatValue>0.0) {
        [self requestQuerylabourlist];
    }else{
        [self.view showLoadingMeg:@"请输入返费" time:MESSAGE_SHOW_TIME];
    }
}

#pragma mark - request
-(void)requestQuerylabourlist{
    
    CGFloat money = [self.textTF.text floatValue];
    
    NSDictionary *dic = @{@"id":[LPTools isNullToString:self.model.userId],
                          @"mechanismId":[LPTools isNullToString:self.model.workAddress],
                          @"reMoney":[NSString stringWithFormat:@"%.2f",money],
                          @"workId":[LPTools isNullToString:self.model.workId]};
    
     [NetApiManager requestQueryadd_overseer:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0 && [responseObject[@"data"] integerValue] == 1) {
                [self.view showLoadingMeg:@"设置成功" time:MESSAGE_SHOW_TIME];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
