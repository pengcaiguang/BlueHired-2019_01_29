//
//  LPAwardVC.m
//  BlueHired
//
//  Created by iMac on 2019/7/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAwardVC.h"
#import "LPAwardInvitationVC.h"
#import "LPReMoneyDrawVC.h"

@interface LPAwardVC ()

@end

@implementation LPAwardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"奖励领取";
}

- (IBAction)TouchBtn:(UIButton *)sender {
    if (sender.tag == 1000) {       //邀请奖励领取
        LPAwardInvitationVC *vc = [[LPAwardInvitationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){  //返费奖励领取
        LPReMoneyDrawVC *vc = [[LPReMoneyDrawVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
