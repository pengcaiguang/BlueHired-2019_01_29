//
//  UIButton+XibScaleAdapter.m
//  BlueHired
//
//  Created by iMac on 2019/5/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "UIButton+XibScaleAdapter.h"

@implementation UIButton (XibScaleAdapter)
//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKeyButton";

- (BOOL)adapterScreen{
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenKey);
    return number.boolValue;
}

- (void)setAdapterScreen:(BOOL)adapterScreen {
    
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.titleLabel.font = [UIFont fontWithDescriptor:self.titleLabel.font.fontDescriptor size:FontSize(self.titleLabel.font.pointSize)];
    }
}
@end
