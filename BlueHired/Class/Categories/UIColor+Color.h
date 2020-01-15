//
//  UIColor+Color.h
//  BlueHired
//
//  Created by peng on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)
+(UIColor *) colorWithHexString: (NSString *) hexString;
+(UIColor *) colorWithHexString: (NSString *) hexString alpha:(CGFloat) alpha;
+ (UIColor *)baseColor;

@end
