//
//  NSString+String.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)
//毫秒时间戳转时间
+ (NSString *)convertStringToTime:(NSString *)timeString;

//验证手机号
+ (BOOL)isMobilePhoneNumber:(NSString *)mobileNum;

@end
