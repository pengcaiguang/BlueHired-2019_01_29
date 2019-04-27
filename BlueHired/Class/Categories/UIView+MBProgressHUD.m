//
//  UIView+MBProgressHUD.m
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import "UIView+MBProgressHUD.h"

@implementation UIView (MBProgressHUD)
- (MBProgressHUD *)showLoadingMeg:(NSString *)meg
{
    MBProgressHUD *hudView = [MBProgressHUD HUDForView:self];
    if (!hudView) {
        hudView = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }else{
        [hudView showAnimated:YES];
    }
    hudView.detailsLabel.text = meg;
    return hudView;
}

- (void)hideLoading
{
    [MBProgressHUD hideHUDForView:self animated:NO];
}

- (void)showLoadingMeg:(NSString *)meg time:(NSUInteger)time
{
    MBProgressHUD *hud = [self showLoadingMeg:meg];
    hud.mode = MBProgressHUDModeCustomView;
    if (time > 0) {
        [self performSelector:@selector(hideLoading) withObject:nil afterDelay:time];
    }
}

- (void)showLoadingMeg:(NSString *)meg withImageName:(NSString *)imageName time:(NSUInteger)time
{
    MBProgressHUD *hud = [self showLoadingMeg:meg];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    if (time > 0) {
        [self performSelector:@selector(hideLoading) withObject:nil afterDelay:time];
    }
}

- (void)delayHideLoading
{
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:kDefaultShowTime];
}
- (void)setLoadingUserInterfaceEnable:(BOOL)enable
{
    [MBProgressHUD HUDForView:self].userInteractionEnabled = enable;
}
@end
