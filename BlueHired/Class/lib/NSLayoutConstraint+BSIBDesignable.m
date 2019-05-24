//
//  NSLayoutConstraint+BSIBDesignable.m
//  BlueHired
//
//  Created by iMac on 2019/5/22.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "NSLayoutConstraint+BSIBDesignable.h"
#import <objc/runtime.h>

@implementation NSLayoutConstraint (BSIBDesignable)
//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKey";

- (BOOL)adapterScreen{
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenKey);
    return number.boolValue;
}

- (void)setAdapterScreen:(BOOL)adapterScreen {
    
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.constant = LENGTH_SIZE(self.constant);
    }
}


@end
