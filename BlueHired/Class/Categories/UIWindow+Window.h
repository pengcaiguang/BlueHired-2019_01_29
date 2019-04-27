//
//  UIWindow+Window.h
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Window)
/**
 *获取当前可视ViewController
 */
+ (UIViewController *)visibleViewController;
@end
