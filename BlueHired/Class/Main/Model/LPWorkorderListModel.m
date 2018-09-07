//
//  LPWorkorderListModel.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/7.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkorderListModel.h"

@implementation LPWorkorderListModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"data": @"LPWorkorderListDataModel",
             };
}
@end

@implementation LPWorkorderListDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"teacherList": @"LPWorkorderListDataTeacherListModel",
             };
}
@end

@implementation LPWorkorderListDataTeacherListModel

@end
