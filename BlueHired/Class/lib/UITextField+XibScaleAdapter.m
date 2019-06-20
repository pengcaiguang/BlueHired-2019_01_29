//
//  UITextField+XibScaleAdapter.m
//  BlueHired
//
//  Created by iMac on 2019/5/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "UITextField+XibScaleAdapter.h"

@implementation UITextField (XibScaleAdapter)
//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKeyTextField";

- (BOOL)adapterScreen{
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenKey);
    return number.boolValue;
}

- (void)setAdapterScreen:(BOOL)adapterScreen {
    
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.font = [UIFont fontWithDescriptor:self.font.fontDescriptor size:FontSize(self.font.pointSize)];
    }
}
@end
