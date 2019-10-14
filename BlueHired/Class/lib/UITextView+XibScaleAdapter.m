//
//  UITextView+XibScaleAdapter.m
//  BlueHIredDelegate
//
//  Created by iMac on 2019/8/21.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "UITextView+XibScaleAdapter.h"

@implementation UITextView (XibScaleAdapter)
//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKeyTextView";

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
