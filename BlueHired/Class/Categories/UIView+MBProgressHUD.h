//
//  UIView+MBProgressHUD.h
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define kDefaultShowTime 1

@interface UIView (MBProgressHUD)

- (MBProgressHUD *)showLoadingMeg:(NSString *)meg;
- (void)hideLoading;
- (void)showLoadingMeg:(NSString *)meg time:(NSUInteger)time;
- (void)showLoadingMeg:(NSString *)meg withImageName:(NSString *)imageName time:(NSUInteger)time;
- (void)delayHideLoading;//x秒后消失 由 kDefaultShowTime 的值决定
- (void)setLoadingUserInterfaceEnable:(BOOL)enable;

@end
