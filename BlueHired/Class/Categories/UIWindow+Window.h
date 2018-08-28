//
//  UIWindow+Window.h
//  RedPacket
//
//  Created by 邢晓亮 on 2018/6/8.
//  Copyright © 2018年 邢晓亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Window)
/**
 *获取当前可视ViewController
 */
+ (UIViewController *)visibleViewController;
@end
