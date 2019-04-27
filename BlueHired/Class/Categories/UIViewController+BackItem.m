//
//  UIViewController+BackItem.m
//  QSAPP
//
//  Created by peng on 2018/4/24.
//  Copyright © 2018年 peng. All rights reserved.
//

#import "UIViewController+BackItem.h"
#import <objc/runtime.h>

static NSString *backItemImageKey = @"ic_back_black";

@implementation UIViewController (BackItem)

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:self.backItemImage ? self.backItemImage : [UIImage imageNamed:@"ic_back_black"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)setBackItemImage:(UIImage *)backItemImage{
    objc_setAssociatedObject(self, &backItemImageKey, backItemImage, OBJC_ASSOCIATION_COPY);
}
-(UIImage *)backItemImage{
    return objc_getAssociatedObject(self, &backItemImageKey);
}


@end
