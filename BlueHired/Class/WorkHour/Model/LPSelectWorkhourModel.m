//
//  LPSelectWorkhourModel.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/12.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSelectWorkhourModel.h"

@implementation LPSelectWorkhourModel

@end

@implementation LPSelectWorkhourDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"addHourList": @"LPSelectWorkhourDataAddHourListModel",
             @"leaveHourList": @"LPSelectWorkhourDataLeaveHourListModel",
             @"normalHourList": @"LPSelectWorkhourDataNormalHourListModel",
             };
}
@end


@implementation LPSelectWorkhourDataAddHourListModel
@end


@implementation LPSelectWorkhourDataLeaveHourListModel

@end

@implementation LPSelectWorkhourDataNormalHourListModel

@end
