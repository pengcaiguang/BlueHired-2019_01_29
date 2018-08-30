//
//  LoginUtils.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LoginUtils.h"
#import "LPLoginVC.h"

@implementation LoginUtils
+ (BOOL)validationLogin:(UIViewController *)controller{
    if (AlreadyLogin) {
        return YES;
    }else{
        LPLoginVC *vc = [[LPLoginVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:vc animated:YES];
        return NO;
    }
}
@end
