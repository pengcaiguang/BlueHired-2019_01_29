//
//  UIWindow+Window.m
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import "UIWindow+Window.h"

@implementation UIWindow (Window)
+ (UIViewController *)visibleViewController {
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
@end
